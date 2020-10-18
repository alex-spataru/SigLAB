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

#ifndef QML_BRIDGE_H
#define QML_BRIDGE_H

#include <QObject>
#include <QVariant>

class Group;
class QmlBridge : public QObject
{
   Q_OBJECT

   Q_PROPERTY(QString projectTitle READ projectTitle NOTIFY updated)
   Q_PROPERTY(int groupCount READ groupCount NOTIFY updated)
   Q_PROPERTY(QList<Group *> groups READ groups NOTIFY updated)
   Q_PROPERTY(bool gpsSupported READ gpsSupported NOTIFY updated)
   Q_PROPERTY(double gpsAltitude READ gpsAltitude NOTIFY updated)
   Q_PROPERTY(double gpsLatitude READ gpsLatitude NOTIFY updated)
   Q_PROPERTY(double gpsLongitude READ gpsLongitude NOTIFY updated)

signals:
   void updated();

public:
   static QmlBridge *getInstance();

   QString projectTitle() const;

   int groupCount() const;
   QList<Group *> groups() const;
   Q_INVOKABLE Group *getGroup(const int index);

   Group *gpsGroup() const;
   bool gpsSupported() const;
   double gpsAltitude() const;
   double gpsLatitude() const;
   double gpsLongitude() const;

private:
   QmlBridge();

private slots:
   void update();

private:
   QString m_title;
   QList<Group *> m_groups;
};

#endif
