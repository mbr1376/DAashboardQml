#pragma once
// LineChartItem - A QQuickPaintedItem for smooth area/line charts
//
// This C++ class is registered as a QML type so you can use it
// directly in QML:
//
//   // Available as a QML type in the Dashboard module:
//   LineChartItem {
//       dataPoints: [45, 52, 48, 68, 72, 65, 78, 85, 82, 91, 88, 95]
//       xLabels: ["Jan", "Feb", "Mar", ...]
//       lineColor: "#3498db"
//   }
//
// It uses QPainter to draw:
//   - Smooth Catmull-Rom spline curves
//   - Gradient area fill under the curve
//   - Grid lines and axis labels
//   - Data point dots with glow effect
//
// CUSTOMIZATION:
//   - Set dataPoints, xLabels, and lineColor from QML
//   - Change grid line count by modifying the paint method

#include <QQuickPaintedItem>
#include <QVariantList>
#include <QColor>
#include <QStringList>

class LineChartItem : public QQuickPaintedItem {
    Q_OBJECT
    QML_ELEMENT

    // Data points (list of numeric values)
    Q_PROPERTY(QVariantList dataPoints READ dataPoints WRITE setDataPoints NOTIFY dataPointsChanged)

    // Labels for the x-axis
    Q_PROPERTY(QStringList xLabels READ xLabels WRITE setXLabels NOTIFY xLabelsChanged)

    // Color of the line and data points
    Q_PROPERTY(QColor lineColor READ lineColor WRITE setLineColor NOTIFY lineColorChanged)

public:
    explicit LineChartItem(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    QVariantList dataPoints() const { return m_dataPoints; }
    void setDataPoints(const QVariantList &points);

    QStringList xLabels() const { return m_xLabels; }
    void setXLabels(const QStringList &labels);

    QColor lineColor() const { return m_lineColor; }
    void setLineColor(const QColor &color);

signals:
    void dataPointsChanged();
    void xLabelsChanged();
    void lineColorChanged();

private:
    QVariantList m_dataPoints;
    QStringList m_xLabels;
    QColor m_lineColor = QColor("#3498db");
};
