#pragma once
// DonutChartItem - A QQuickPaintedItem for donut/ring charts
//
// This C++ class is registered as a QML type:
//
//   // Available as a QML type in the Dashboard module:
//   DonutChartItem {
//       slices: [
//           { label: "Electronics", value: 35, color: "#3498db" },
//           { label: "Clothing",    value: 25, color: "#2ecc71" },
//       ]
//   }
//
// It uses QPainter to draw:
//   - Pie slices with small gaps between them
//   - An inner hole (donut shape)
//   - Center text showing "100%" and "Total"
//   - A legend with labels and percentages
//
// CUSTOMIZATION:
//   - Set slices from QML as a list of {label, value, color} objects
//   - Change holeRatio to adjust the donut thickness

#include <QQuickPaintedItem>
#include <QVariantList>
#include <QColor>

class DonutChartItem : public QQuickPaintedItem {
    Q_OBJECT
    QML_ELEMENT

    // List of slice objects: [ { label: str, value: real, color: str }, ... ]
    Q_PROPERTY(QVariantList slices READ slices WRITE setSlices NOTIFY slicesChanged)

    // Ratio of inner hole (0.0 = full pie, 1.0 = thin ring)
    Q_PROPERTY(qreal holeRatio READ holeRatio WRITE setHoleRatio NOTIFY holeRatioChanged)

public:
    explicit DonutChartItem(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    QVariantList slices() const { return m_slices; }
    void setSlices(const QVariantList &slices);

    qreal holeRatio() const { return m_holeRatio; }
    void setHoleRatio(qreal ratio);

signals:
    void slicesChanged();
    void holeRatioChanged();

private:
    QVariantList m_slices;
    qreal m_holeRatio = 0.6;
};
