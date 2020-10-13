#include <QTimer>
#include <QXYSeries>
#include <QMetaType>

#include "GraphProvider.h"
#include "QmlBridge.h"
#include "Group.h"
#include "Dataset.h"

static GraphProvider *INSTANCE = nullptr;

//
// Magic
//
QT_CHARTS_USE_NAMESPACE
Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

template<typename T>
static void RemoveOldData(QVector<T> *vector, const int max)
{
    if (vector->count() > max)
        vector->remove(0, vector->count() - max + 1);
}

GraphProvider::GraphProvider()
{
    // Register data types
    qRegisterMetaType<QAbstractSeries *>();
    qRegisterMetaType<QAbstractAxis *>();

    // Update graph values as soon as QML Bridge interprets data
    connect(QmlBridge::getInstance(), SIGNAL(updated()), this, SLOT(updateValues()));
}

GraphProvider *GraphProvider::getInstance()
{
    if (!INSTANCE)
        INSTANCE = new GraphProvider();

    return INSTANCE;
}

int GraphProvider::graphCount() const
{
    return datasets().count();
}

quint64 GraphProvider::numPoints() const
{
    return m_numPoints;
}

quint64 GraphProvider::displayedPoints() const
{
    return 10;
}

QList<Dataset *> GraphProvider::datasets() const
{
    return m_datasets;
}

double GraphProvider::getValue(const int index) const
{
    if (index < graphCount() && index >= 0)
        return getDataset(index)->value().toDouble();

    return 0;
}

quint64 GraphProvider::firstPoint(const int index) const
{
    if (index < graphCount() && index >= 0)
        return m_pointVectors.at(index)->first().x();

    return 0;
}

Dataset *GraphProvider::getDataset(const int index) const
{
    if (index < graphCount() && index >= 0)
        return datasets().at(index);

    return Q_NULLPTR;
}

void GraphProvider::updateValues()
{
    // Clear dataset & latest values list
    m_datasets.clear();

    // Create list with datasets that need to be graphed
    for (int i = 0; i < QmlBridge::getInstance()->groupCount(); ++i)
    {
        auto group = QmlBridge::getInstance()->getGroup(i);
        for (int j = 0; j < group->count(); ++j)
        {
            auto dataset = group->getDataset(j);
            if (dataset->graph())
                m_datasets.append(dataset);
        }
    }

    // Create list with dataset values (converted to double)
    for (int i = 0; i < graphCount(); ++i)
    {
        if (m_pointVectors.count() < (i + 1))
        {
            auto vector = new QVector<QPointF>();
            m_pointVectors.append(vector);
        }

        QPointF point(m_numPoints, getValue(i));
        m_pointVectors.at(i)->append(point);
        RemoveOldData<QPointF>(m_pointVectors.at(i), displayedPoints() + 2);
    }

    // Increment counter
    ++m_numPoints;

    // Update graphs
    QTimer::singleShot(10, this, SIGNAL(dataUpdated()));
}

void GraphProvider::updateGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);

    // Update data
    if (m_pointVectors.count() > index && index >= 0) {
        QVector<QPointF> *data = m_pointVectors.at(index);
        static_cast<QXYSeries *>(series)->replace(*data);
    }
}
