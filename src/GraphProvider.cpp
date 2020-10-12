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

quint64 GraphProvider::maxPoints() const
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

   // Reset counter
   if (numPoints() > maxPoints())
   {
      m_numPoints = 0;
      m_readings.clear();
   }

   // Create list with dataset values (converted to double)
   for (int i = 0; i < graphCount(); ++i)
   {
      if (m_readings.count() < (i + 1))
      {
         auto vector = new QVector<QPointF>();
         m_readings.append(vector);
      }

      QPointF point(m_numPoints, getValue(i));
      m_readings.at(i)->append(point);
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

   // No hacer nada si la grafica no es visible
   if (!series->isVisible())
      return;

   // Obtener puntos para la señal especificada
   QVector<QPointF> *data = m_readings.at(index);

   // Convertir la gráfica a XY y remplazar puntos
   if (data != Q_NULLPTR)
      static_cast<QXYSeries *>(series)->replace(*data);
}
