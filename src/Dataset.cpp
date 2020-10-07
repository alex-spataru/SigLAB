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

#include "Dataset.h"

Dataset::Dataset(QObject *parent)
   : QObject(parent)
{
}

bool Dataset::graph() const
{
   return m_graph;
}

QString Dataset::title() const
{
   return m_title;
}

QString Dataset::value() const
{
   return m_value;
}

QString Dataset::units() const
{
   return m_units;
}

bool Dataset::read(const QJsonObject &object)
{
   if (!object.isEmpty())
   {
      auto graph = object.value("graph").toBool();
      auto title = object.value("title").toString();
      auto value = object.value("value").toString();
      auto units = object.value("units").toString();

      if (!title.isEmpty() && !value.isEmpty())
      {
         m_graph = graph;
         m_title = title;
         m_value = value;
         m_units = units;
         return true;
      }
   }

   return false;
}
