
/*
 * Copyright (c) 2020 Alex Spataru <https://github.com/alex-spataru>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "Export.h"
#include "JsonParser.h"
#include "SerialManager.h"

#include <QDir>
#include <QUrl>
#include <QMessageBox>
#include <QApplication>
#include <QJsonDocument>
#include <QDesktopServices>

static Export *INSTANCE = Q_NULLPTR;

Export *Export::getInstance()
{
   if (!INSTANCE)
      INSTANCE = new Export();

   return INSTANCE;
}

Export::Export()
{
   auto jp = JsonParser::getInstance();
   auto sp = SerialManager::getInstance();
   connect(jp, SIGNAL(packetReceived()), this, SLOT(updateValues()));
   connect(sp, SIGNAL(connectedChanged()), this, SLOT(closeFile()));

   QTimer::singleShot(1000, this, SLOT(writeValues()));
}

Export::~Export()
{
   closeFile();
}

bool Export::isOpen() const
{
   return m_csvFile.isOpen();
}

void Export::openCsv()
{
   if (isOpen())
      QDesktopServices::openUrl(QUrl::fromLocalFile(m_csvFile.fileName()));
   else
      QMessageBox::critical(Q_NULLPTR, tr("CSV file not open"), tr("Cannot find CSV export file!"), QMessageBox::Ok);
}

void Export::closeFile()
{
   if (isOpen())
   {
      while (m_jsonList.count())
         writeValues();

      m_csvFile.close();
      emit openChanged();
   }
}

void Export::writeValues()
{
   for (int k = 0; k < qMin(m_jsonList.count(), 10); ++k)
   {
      // Get project title & cell values
      auto json = m_jsonList.first().second;
      auto dateTime = m_jsonList.first().first;
      auto projectTitle = json.value("t").toVariant().toString();

      // Validate JSON & title
      if (json.isEmpty() || projectTitle.isEmpty())
      {
         m_jsonList.removeFirst();
         break;
      }

      // Get cell titles & values
      QStringList titles;
      QStringList values;
      auto groups = json.value("g").toArray();
      for (int i = 0; i < groups.count(); ++i)
      {
         // Get group & dataset array
         auto group = groups.at(i).toObject();
         auto datasets = group.value("d").toArray();
         if (group.isEmpty() || datasets.isEmpty())
            continue;

         // Get group title
         auto groupTitle = group.value("t").toVariant().toString();

         // Get dataset titles & values
         for (int j = 0; j < datasets.count(); ++j)
         {
            auto dataset = datasets.at(j).toObject();
            auto datasetTitle = dataset.value("t").toVariant().toString();
            auto datasetUnits = dataset.value("u").toVariant().toString();
            auto datasetValue = dataset.value("v").toVariant().toString();

            if (datasetTitle.isEmpty())
               continue;

            // Construct dataset title from group, dataset title & units
            QString title;
            if (datasetUnits.isEmpty())
               title = QString("(%1) %2").arg(groupTitle).arg(datasetTitle);
            else
               title = QString("(%1) %2 [%3]").arg(groupTitle).arg(datasetTitle).arg(datasetUnits);

            // Add dataset title & value to lists
            titles.append(title);
            values.append(datasetValue);
         }
      }

      // Abort if cell titles are empty
      if (titles.isEmpty())
      {
         m_jsonList.removeFirst();
         break;
      }

      // Prepend current time
      titles.prepend("RX Time");
      values.prepend(dateTime.toString("yyyy/MMM/dd/ HH:mm:ss::zzz"));

      // File not open, create it & add cell titles
      if (!isOpen())
      {
         // Get file name and path
         QString format = dateTime.toString("yyyy/MMM/dd/");
         QString fileName = dateTime.toString("HH-mm-ss") + ".csv";
         QString path = QString("%1/%2/%3/%4").arg(QDir::homePath(), qApp->applicationName(), projectTitle, format);

         // Generate file path if required
         QDir dir(path);
         if (!dir.exists())
            dir.mkpath(".");

         // Open file
         m_csvFile.setFileName(dir.filePath(fileName));
         if (!m_csvFile.open(QFile::WriteOnly))
         {
            QMessageBox::critical(Q_NULLPTR, tr("CSV File Error"), tr("Cannot open CSV file for writing!"),
                                  QMessageBox::Ok);
            QTimer::singleShot(1000, this, SLOT(writeValues()));
            break;
         }

         // Add cell titles
         for (int i = 0; i < titles.count(); ++i)
         {
            m_csvFile.write(titles.at(i).toUtf8());
            if (i < titles.count() - 1)
               m_csvFile.write(",");
            else
               m_csvFile.write("\n");
         }

         // Update UI
         emit openChanged();
      }

      // Write cell values
      for (int i = 0; i < values.count(); ++i)
      {
         m_csvFile.write(values.at(i).toUtf8());
         if (i < values.count() - 1)
            m_csvFile.write(",");
         else
            m_csvFile.write("\n");
      }

      // Remove JSON from list
      m_jsonList.removeFirst();
   }

   // Call this function again in one second
   QTimer::singleShot(1000, this, SLOT(writeValues()));
}

void Export::updateValues()
{
   // Ignore if serial device is not connected
   if (!SerialManager::getInstance()->connected())
      return;

   // Get & validate JSON document
   auto json = JsonParser::getInstance()->document().object();
   if (json.isEmpty())
      return;

   // Update JSON list
   m_jsonList.append(qMakePair<QDateTime, QJsonObject>(QDateTime::currentDateTime(), json));
}
