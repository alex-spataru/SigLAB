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

/**
 * Implementacion de una funcion que elimina los elementos mas viejos de una lista
 * mientras que el numero de lecturas de la lista es mayor al numero maximo de lecturas.
 */
template<typename T>
static void RemoveOldValues(QVector<T> *vector, const int maxElements)
{
   while (vector->count() > maxElements)
      vector->removeFirst();
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

int GraphProvider::graphCount()
{
   return datasets().count();
}

quint64 GraphProvider::numPoints()
{
   return m_numPoints;
}

QList<Dataset *> GraphProvider::datasets()
{
   return m_datasets;
}

Dataset *GraphProvider::getDataset(const int index)
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
      if (m_readings.count() < (i + 1))
      {
         auto vector = new QVector<QPointF>();
         m_readings.append(vector);
      }

      RemoveOldValues<QPointF>(m_readings.at(i), 100);
      auto value = getDataset(i)->value().toDouble();
      QPointF point(m_numPoints, value);
      m_readings.at(i)->append(point);
   }

   // Increment counter
   ++m_numPoints;

   // Update graphs
   void dataUpdated();
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
