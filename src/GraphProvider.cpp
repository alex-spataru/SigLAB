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
   // Start with 10 points
   m_displayedPoints = 10;

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

int GraphProvider::displayedPoints() const
{
   return m_displayedPoints;
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

double GraphProvider::minimumValue(const int index) const
{
   double min = INT_MAX;

   if (index < m_minimumValues.count() && index >= 0)
      min = m_minimumValues.at(index);

   if (min != INT_MAX)
      return min;

   return 0;
}

double GraphProvider::maximumValue(const int index) const
{
   double max = INT_MIN;

   if (index < m_maximumValues.count() && index >= 0)
      max = m_maximumValues.at(index);

   if (max != INT_MIN)
      return max;

   return 1;
}

Dataset *GraphProvider::getDataset(const int index) const
{
   if (index < graphCount() && index >= 0)
      return datasets().at(index);

   return Q_NULLPTR;
}

void GraphProvider::setDisplayedPoints(const int points)
{
   if (points != displayedPoints() && points > 0)
   {
      m_displayedPoints = points;
      m_pointVectors.clear();

      emit displayedPointsUpdated();
      emit dataUpdated();
   }
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
      // Register dataset for this graph
      if (m_pointVectors.count() < (i + 1))
      {
         auto vector = new QVector<double>;
         m_pointVectors.append(vector);
      }

      // Register min. values list
      if (m_minimumValues.count() < (i + 1))
         m_minimumValues.append(getValue(i));

      // Register max. values list
      if (m_maximumValues.count() < (i + 1))
         m_maximumValues.append(getValue(i));

      // Update minimum value
      if (minimumValue(i) > getValue(i))
         m_minimumValues.replace(i, getValue(i));

      // Update minimum value
      if (maximumValue(i) < getValue(i))
         m_maximumValues.replace(i, getValue(i));

      // Remove older items
      if (m_pointVectors.at(i)->count() >= displayedPoints())
         m_pointVectors.at(i)->remove(0, m_pointVectors.at(i)->count() - displayedPoints());

      // Add values
      m_pointVectors.at(i)->append(getValue(i));
   }

   // Update graphs
   QTimer::singleShot(10, this, SIGNAL(dataUpdated()));
}

void GraphProvider::updateGraph(QAbstractSeries *series, const int index)
{
   // Validation
   assert(series != Q_NULLPTR);

   // Update data
   if (series->isVisible())
   {
      if (m_pointVectors.count() > index && index >= 0)
      {
         QVector<QPointF> data;
         for (int i = 0; i < m_pointVectors.at(index)->count(); ++i)
            data.append(QPointF(i, m_pointVectors.at(index)->at(i)));

         static_cast<QXYSeries *>(series)->replace(data);
      }
   }
}
