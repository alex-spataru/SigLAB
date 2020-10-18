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

#ifndef EXPORT_H
#define EXPORT_H

#include <QFile>
#include <QList>
#include <QObject>
#include <QVariant>
#include <QJsonObject>

class Export : public QObject
{
   Q_OBJECT
   Q_PROPERTY(bool isOpen READ isOpen NOTIFY openChanged)

signals:
   void openChanged();

public:
   static Export *getInstance();
   bool isOpen() const;

private:
   Export();
   ~Export();

public slots:
   void openCsv();

private slots:
   void closeFile();
   void writeValues();
   void updateValues();

private:
   QFile m_csvFile;
   QList<QPair<QDateTime, QJsonObject>> m_jsonList;
};

#endif
