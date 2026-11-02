// StatCard.qml - Reusable dashboard statistics card
//
// Displays a stat card with:
//   - Colored icon circle with a Unicode symbol
//   - Large value text (e.g., "12,458")
//   - A descriptive label (e.g., "Total Users")
//   - A change indicator with arrow (e.g., "+12.5%")
//   - A mini sparkline trend in the bottom-right
//   - Hover lift animation
//
// CUSTOMIZATION:
//   - Set iconChar, title, value, change, positive, and accentColor
//   - The sparkline data is auto-generated based on the positive flag
//   - Change card height or radius below for different proportions

import QtQuick

Item {
    id: root

    // --- Public Properties ---
    property string iconChar: "\u2603"
    property string title: "Stat"
    property string value: "0"
    property string change: "+0%"
    property bool positive: true
    property color accentColor: Theme.accentBlue

    implicitWidth: 220
    implicitHeight: 180

    // Hover offset for lift animation
    property real hoverOffset: 0

    // Sparkline data (auto-generated)
    readonly property var sparkData: positive
        ? [0.3, 0.4, 0.35, 0.5, 0.45, 0.6, 0.55, 0.7, 0.8]
        : [0.7, 0.65, 0.7, 0.6, 0.55, 0.5, 0.45, 0.5, 0.4]

    // ============================================================
    // The entire card is rendered with Canvas for visual consistency
    // with the C++ and PySide versions (QPainter rendering).
    // ============================================================
    Canvas {
        id: cardCanvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var margin = 4;
            var radius = 15;
            var w = width - margin * 2;
            var h = height - margin * 2;

            // --- Drop Shadow ---
            ctx.fillStyle = "rgba(0, 0, 0, 0.2)";
            roundRect(ctx, margin + 2, margin + 4, w, h, radius);
            ctx.fill();

            // --- Card Background ---
            ctx.fillStyle = Theme.card;
            roundRect(ctx, margin, margin - hoverOffset, w, h, radius);
            ctx.fill();

            // --- Subtle Border ---
            ctx.strokeStyle = Theme.border;
            ctx.lineWidth = 1;
            roundRect(ctx, margin, margin - hoverOffset, w, h, radius);
            ctx.stroke();

            var cx = margin;
            var cy = margin - hoverOffset;

            // --- Icon Circle ---
            var iconSize = 46;
            var iconX = cx + 20 + iconSize / 2;
            var iconY = cy + 18 + iconSize / 2;
            ctx.beginPath();
            ctx.arc(iconX, iconY, iconSize / 2, 0, Math.PI * 2);
            ctx.fillStyle = root.accentColor;
            ctx.fill();

            // Icon character
            ctx.font = "17px '" + Theme.fontFamily + "'";
            ctx.fillStyle = "#ffffff";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(root.iconChar, iconX, iconY);

            // --- Value Text ---
            ctx.font = "bold 24px '" + Theme.fontFamily + "'";
            ctx.fillStyle = Theme.textPrimary;
            ctx.textAlign = "left";
            ctx.textBaseline = "top";
            ctx.fillText(root.value, cx + 20, cy + 78);

            // --- Title Label ---
            ctx.font = "11px '" + Theme.fontFamily + "'";
            ctx.fillStyle = Theme.textSecondary;
            ctx.fillText(root.title, cx + 20, cy + 112);

            // --- Change Indicator ---
            var arrow = root.positive ? "\u2191 " : "\u2193 ";
            ctx.font = "bold 11px '" + Theme.fontFamily + "'";
            ctx.fillStyle = root.positive ? Theme.accentGreen : Theme.accentRed;
            ctx.fillText(arrow + root.change, cx + 20, cy + 136);

            // --- Mini Sparkline ---
            if (root.sparkData.length > 0) {
                var sparkW = 70;
                var sparkH = 28;
                var sparkX = cx + w - sparkW - 20;
                var sparkY = cy + 125;

                ctx.beginPath();
                for (var i = 0; i < root.sparkData.length; i++) {
                    var sx = sparkX + (sparkW * i / (root.sparkData.length - 1));
                    var sy = sparkY + sparkH - (sparkH * root.sparkData[i]);
                    if (i === 0) ctx.moveTo(sx, sy);
                    else ctx.lineTo(sx, sy);
                }

                var sparkColor = root.accentColor;
                ctx.strokeStyle = Qt.rgba(sparkColor.r, sparkColor.g, sparkColor.b, 0.7);
                ctx.lineWidth = 2;
                ctx.lineJoin = "round";
                ctx.lineCap = "round";
                ctx.stroke();

                // Area fill under sparkline
                ctx.lineTo(sparkX + sparkW, sparkY + sparkH);
                ctx.lineTo(sparkX, sparkY + sparkH);
                ctx.closePath();

                var grad = ctx.createLinearGradient(0, sparkY, 0, sparkY + sparkH);
                grad.addColorStop(0, Qt.rgba(sparkColor.r, sparkColor.g, sparkColor.b, 0.15));
                grad.addColorStop(1, Qt.rgba(sparkColor.r, sparkColor.g, sparkColor.b, 0.02));
                ctx.fillStyle = grad;
                ctx.fill();
            }
        }

        // Helper: draw a rounded rectangle path
        function roundRect(ctx, x, y, w, h, r) {
            ctx.beginPath();
            ctx.moveTo(x + r, y);
            ctx.lineTo(x + w - r, y);
            ctx.arcTo(x + w, y, x + w, y + r, r);
            ctx.lineTo(x + w, y + h - r);
            ctx.arcTo(x + w, y + h, x + w - r, y + h, r);
            ctx.lineTo(x + r, y + h);
            ctx.arcTo(x, y + h, x, y + h - r, r);
            ctx.lineTo(x, y + r);
            ctx.arcTo(x, y, x + r, y, r);
            ctx.closePath();
        }
    }

    // ============================================================
    // Hover Animation
    // ============================================================
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: hoverAnim.to = 5
        onExited: hoverAnim.to = 0
    }

    NumberAnimation {
        id: hoverAnim
        target: root
        property: "hoverOffset"
        duration: 200
        easing.type: Easing.OutCubic
        onToChanged: {
            from = root.hoverOffset;
            restart();
        }
    }

    // Repaint when any visual property changes
    onHoverOffsetChanged: cardCanvas.requestPaint()
    onValueChanged: cardCanvas.requestPaint()
    onTitleChanged: cardCanvas.requestPaint()
    onAccentColorChanged: cardCanvas.requestPaint()
}
