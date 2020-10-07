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

Group::Group(QObject* parent) : QObject(parent) {
    m_title = tr("Invalid");
}

int Group::count() const {
    return datasets().count();
}

QString Group::title() const {
    return m_title;
}

QList<Dataset*> Group::datasets() const {
    return m_datasets;
}

Dataset* Group::getDataset(const int index) {
    if (index < count())
        return m_datasets.at(index);

    return Q_NULLPTR;
}

bool Group::read(const QJsonObject& object) {
    if (!object.isEmpty()) {
        auto title = object.value("title").toString();
        auto array = object.value("data").toArray();

        if (!title.isEmpty() && !array.isEmpty()) {
            m_title = title;
            m_datasets.clear();

            for (auto i = 0; i < array.count(); ++i) {
                auto object = array.at(i).toObject();
                if (!object.isEmpty()) {
                    auto dataset = new Dataset(this);
                    if (dataset->read(object))
                        m_datasets.append(dataset);
                    else
                        dataset->deleteLater();
                }
            }

            return count() > 0;
        }
    }

    return false;
}

