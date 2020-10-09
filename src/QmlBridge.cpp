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

#include "Group.h"
#include "Dataset.h"
#include "QmlBridge.h"
#include "JsonParser.h"

#include <QJsonArray>
#include <QJsonObject>

/*
 * Only instance of the class
 */
static QmlBridge *INSTANCE = nullptr;

QmlBridge::QmlBridge()
{
   auto jp = JsonParser::getInstance();
   connect(jp, SIGNAL(packetReceived()), this, SLOT(update()));
}

QmlBridge *QmlBridge::getInstance()
{
   if (!INSTANCE)
      INSTANCE = new QmlBridge();

   return INSTANCE;
}

QString QmlBridge::projectTitle() const
{
   return m_title;
}

int QmlBridge::groupCount() const
{
   return groups().count();
}

QList<Group *> QmlBridge::groups() const
{
   return m_groups;
}

Group *QmlBridge::getGroup(const int index)
{
   if (index < groupCount())
      return groups().at(index);

   return Q_NULLPTR;
}

Group *QmlBridge::gpsGroup() const
{
   foreach (Group *group, groups())
   {
      if (group->title().toLower() == "gps")
         return group;
   }

   return Q_NULLPTR;
}

bool QmlBridge::gpsSupported() const
{
   return gpsGroup() != Q_NULLPTR;
}

double QmlBridge::gpsAltitude() const
{
   if (gpsSupported())
   {
      foreach (Dataset *set, gpsGroup()->datasets())
      {
         if (set->title().toLower() == "altitude")
            return set->value().toDouble();
      }
   }

   return 0;
}

double QmlBridge::gpsLatitude() const
{
   if (gpsSupported())
   {
      foreach (Dataset *set, gpsGroup()->datasets())
      {
         if (set->title().toLower() == "latitude")
            return set->value().toDouble();
      }
   }

   return 0;
}

double QmlBridge::gpsLongitude() const
{
   if (gpsSupported())
   {
      foreach (Dataset *set, gpsGroup()->datasets())
      {
         if (set->title().toLower() == "longitude")
            return set->value().toDouble();
      }
   }

   return 0;
}

void QmlBridge::update()
{
   auto document = JsonParser::getInstance()->document();

   if (!document.isEmpty())
   {
      auto object = document.object();
      auto title = object.value("t").toString();
      auto groups = object.value("g").toArray();

      if (!title.isEmpty() && !groups.isEmpty())
      {
         m_title = title;
         m_groups.clear();

         for (auto i = 0; i < groups.count(); ++i)
         {
            auto group = new Group(this);
            if (group->read(groups.at(i).toObject()))
               m_groups.append(group);
            else
               group->deleteLater();
         }

         emit updated();
      }
   }
}
