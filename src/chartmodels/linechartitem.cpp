// LineChartItem - Implementation
//
// Draws a smooth area/line chart using QPainter.
// Uses Catmull-Rom to Cubic Bezier conversion for flowing curves.

#include "linechartitem.h"

#include <QPainter>
#include <QPainterPath>
#include <QLinearGradient>
#include <QtMath>

// Theme color constants (matching the QML Theme.qml)
static const QColor kBorder("#2a2a3e");
static const QColor kTextSecondary("#b8b8c8");

LineChartItem::LineChartItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

void LineChartItem::setDataPoints(const QVariantList &points)
{
    if (m_dataPoints == points) return;
    m_dataPoints = points;
    emit dataPointsChanged();
    update();
}

void LineChartItem::setXLabels(const QStringList &labels)
{
    if (m_xLabels == labels) return;
    m_xLabels = labels;
    emit xLabelsChanged();
    update();
}

void LineChartItem::setLineColor(const QColor &color)
{
    if (m_lineColor == color) return;
    m_lineColor = color;
    emit lineColorChanged();
    update();
}

void LineChartItem::paint(QPainter *painter)
{
    if (m_dataPoints.isEmpty()) return;

    painter->setRenderHint(QPainter::Antialiasing);
    painter->setRenderHint(QPainter::TextAntialiasing);

    // Chart area with margins for labels
    QRectF chartArea(55, 10, width() - 70, height() - 50);

    // Find the data range
    qreal maxVal = 0;
    QVector<qreal> values;
    for (const auto &v : m_dataPoints) {
        qreal val = v.toReal();
        values.append(val);
        maxVal = qMax(maxVal, val);
    }
    maxVal = qCeil(maxVal / 20.0) * 20;

    // --- Grid Lines ---
    int gridLines = 5;
    QFont labelFont("Segoe UI", 10);
    painter->setFont(labelFont);

    for (int i = 0; i <= gridLines; ++i) {
        qreal y = chartArea.top() + (chartArea.height() * i / gridLines);

        painter->setPen(QPen(kBorder, 1));
        painter->drawLine(QPointF(chartArea.left(), y),
                          QPointF(chartArea.right(), y));

        int value = static_cast<int>(maxVal - (maxVal * i / gridLines));
        painter->setPen(kTextSecondary);
        painter->drawText(QRectF(0, y - 10, 48, 20),
                          Qt::AlignRight | Qt::AlignVCenter,
                          QString::number(value));
    }

    // --- X-axis Labels ---
    for (int i = 0; i < m_xLabels.size(); ++i) {
        qreal x = chartArea.left() + (chartArea.width() * i / (m_xLabels.size() - 1));
        painter->setPen(kTextSecondary);
        painter->drawText(QRectF(x - 20, chartArea.bottom() + 8, 40, 20),
                          Qt::AlignCenter, m_xLabels[i]);
    }

    // --- Convert to pixel coordinates ---
    int n = values.size();
    QVector<QPointF> pixelPoints;
    for (int i = 0; i < n; ++i) {
        qreal x = chartArea.left() + (chartArea.width() * i / (n - 1));
        qreal y = chartArea.bottom() - (chartArea.height() * values[i] / maxVal);
        pixelPoints.append(QPointF(x, y));
    }

    // --- Smooth Curve (Catmull-Rom to Cubic Bezier) ---
    QPainterPath curvePath;
    curvePath.moveTo(pixelPoints.first());

    for (int i = 0; i < pixelPoints.size() - 1; ++i) {
        QPointF p0 = (i > 0) ? pixelPoints[i - 1] : pixelPoints[i];
        QPointF p1 = pixelPoints[i];
        QPointF p2 = pixelPoints[i + 1];
        QPointF p3 = (i + 2 < pixelPoints.size())
                      ? pixelPoints[i + 2] : pixelPoints[i + 1];

        QPointF cp1(p1.x() + (p2.x() - p0.x()) / 6.0,
                    p1.y() + (p2.y() - p0.y()) / 6.0);
        QPointF cp2(p2.x() - (p3.x() - p1.x()) / 6.0,
                    p2.y() - (p3.y() - p1.y()) / 6.0);

        curvePath.cubicTo(cp1, cp2, p2);
    }

    // --- Gradient Fill Under the Curve ---
    QPainterPath areaPath = curvePath;
    areaPath.lineTo(pixelPoints.last().x(), chartArea.bottom());
    areaPath.lineTo(pixelPoints.first().x(), chartArea.bottom());
    areaPath.closeSubpath();

    QLinearGradient areaGradient(0, chartArea.top(), 0, chartArea.bottom());
    areaGradient.setColorAt(0, QColor(m_lineColor.red(), m_lineColor.green(), m_lineColor.blue(), 80));
    areaGradient.setColorAt(0.5, QColor(46, 204, 113, 30));
    areaGradient.setColorAt(1, QColor(m_lineColor.red(), m_lineColor.green(), m_lineColor.blue(), 5));
    painter->fillPath(areaPath, areaGradient);

    // --- Curve Line ---
    painter->setPen(QPen(m_lineColor, 3, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    painter->setBrush(Qt::NoBrush);
    painter->drawPath(curvePath);

    // --- Data Point Dots ---
    painter->setPen(Qt::NoPen);
    for (const auto &pt : pixelPoints) {
        painter->setBrush(m_lineColor);
        painter->drawEllipse(pt, 4, 4);
    }

    // Glow on last point
    if (!pixelPoints.isEmpty()) {
        const QPointF &last = pixelPoints.last();
        QColor glow = m_lineColor;
        glow.setAlpha(40);
        painter->setBrush(glow);
        painter->drawEllipse(last, 12, 12);
        painter->setBrush(m_lineColor);
        painter->drawEllipse(last, 5, 5);
    }
}
