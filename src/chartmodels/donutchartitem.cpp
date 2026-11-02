// DonutChartItem - Implementation
//
// Draws a donut chart with legend using QPainter.
// Slice data comes from QML as a list of QVariantMap objects.

#include "donuttchartitem.h"

#include <QPainter>
#include <QPainterPath>
#include <QVariantMap>
#include <QtMath>

// Theme color constants
static const QColor kCard("#242437");
static const QColor kTextPrimary("#ffffff");
static const QColor kTextSecondary("#b8b8c8");

DonutChartItem::DonutChartItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

void DonutChartItem::setSlices(const QVariantList &slices)
{
    if (m_slices == slices) return;
    m_slices = slices;
    emit slicesChanged();
    update();
}

void DonutChartItem::setHoleRatio(qreal ratio)
{
    if (qFuzzyCompare(m_holeRatio, ratio)) return;
    m_holeRatio = ratio;
    emit holeRatioChanged();
    update();
}

void DonutChartItem::paint(QPainter *painter)
{
    if (m_slices.isEmpty()) return;

    painter->setRenderHint(QPainter::Antialiasing);
    painter->setRenderHint(QPainter::TextAntialiasing);

    // Parse slices and calculate total
    struct SliceInfo {
        QString label;
        double value;
        QColor color;
    };
    QVector<SliceInfo> slices;
    double total = 0;

    for (const auto &v : m_slices) {
        QVariantMap map = v.toMap();
        SliceInfo s;
        s.label = map["label"].toString();
        s.value = map["value"].toDouble();
        s.color = QColor(map["color"].toString());
        slices.append(s);
        total += s.value;
    }

    if (total <= 0) return;

    // Donut geometry - leave space on right for legend
    QRectF chartArea(0, 0, width(), height());
    qreal donutSize = qMin(chartArea.width() * 0.52, chartArea.height() * 0.88);
    QRectF donutRect(chartArea.left() + 10,
                     chartArea.center().y() - donutSize / 2,
                     donutSize, donutSize);

    qreal inset = donutSize * (1.0 - m_holeRatio) / 2.0;
    QRectF innerRect = donutRect.adjusted(inset, inset, -inset, -inset);

    // --- Draw Slices ---
    int startAngle = 90 * 16;
    int gapAngle = 2 * 16;

    for (const auto &slice : slices) {
        int spanAngle = static_cast<int>(-360.0 * 16 * slice.value / total);
        int drawSpan = spanAngle + gapAngle;
        if (qAbs(drawSpan) < gapAngle) drawSpan = spanAngle;

        painter->setPen(Qt::NoPen);
        painter->setBrush(slice.color);
        painter->drawPie(donutRect, startAngle, drawSpan);
        startAngle += spanAngle;
    }

    // --- Inner Circle (donut hole) ---
    painter->setBrush(kCard);
    painter->setPen(Qt::NoPen);
    painter->drawEllipse(innerRect);

    // --- Center Text ---
    painter->setPen(kTextPrimary);
    QFont centerFont("Segoe UI", 18, QFont::Bold);
    painter->setFont(centerFont);
    painter->drawText(innerRect, Qt::AlignCenter, "100%");

    QFont subFont("Segoe UI", 9);
    painter->setFont(subFont);
    painter->setPen(kTextSecondary);
    QRectF subRect = innerRect.adjusted(0, 22, 0, 22);
    painter->drawText(subRect, Qt::AlignCenter, "Total");

    // --- Legend (right side) ---
    qreal legendX = donutRect.right() + 35;
    qreal legendY = chartArea.top() + 20;
    QFont legendFont("Segoe UI", 11);

    for (const auto &slice : slices) {
        double pct = slice.value / total * 100.0;

        // Color dot
        painter->setPen(Qt::NoPen);
        painter->setBrush(slice.color);
        painter->drawRoundedRect(QRectF(legendX, legendY + 3, 14, 14), 4, 4);

        // Label
        painter->setFont(legendFont);
        painter->setPen(kTextSecondary);
        painter->drawText(QRectF(legendX + 22, legendY, 120, 20),
                          Qt::AlignLeft | Qt::AlignVCenter, slice.label);

        // Percentage
        painter->setPen(kTextPrimary);
        QFont pctFont("Segoe UI", 11, QFont::Bold);
        painter->setFont(pctFont);
        painter->drawText(QRectF(legendX + 22, legendY + 20, 80, 18),
                          Qt::AlignLeft | Qt::AlignVCenter,
                          QString::number(pct, 'f', 1) + "%");

        legendY += 50;
    }
}
