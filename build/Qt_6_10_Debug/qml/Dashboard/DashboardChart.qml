import QtQuick

Item {
    id: root

    property var rows: []
    property var widget: ({})
    property var fieldNames: []
    property color chartColor: Theme.accentBlue

    readonly property var palette: [
        Theme.accentBlue, Theme.accentGreen, Theme.accentOrange,
        Theme.accentRed, Theme.accentPurple, "#1abc9c", "#e67e22"
    ]

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.clearRect(0, 0, width, height);

            var values = [];
            var labels = [];
            for (var i = 0; i < root.rows.length; ++i) {
                var row = root.rows[i];
                var value = Number(row[root.widget.yField]);
                if (isFinite(value)) {
                    values.push(value);
                    labels.push(String(row[root.widget.xField] === undefined
                                       ? i + 1 : row[root.widget.xField]));
                }
            }

            var type = root.widget.type || "line";
            if (type === "pie" || type === "donut") {
                if (values.length === 0)
                    return;

                var total = 0;
                for (var p = 0; p < values.length; ++p)
                    total += Math.max(0, values[p]);
                if (total <= 0)
                    return;

                var radius = Math.max(10, Math.min(height - 20, width * 0.48) / 2);
                var cx = Math.min(width * 0.38, radius + 8);
                var cy = height / 2;
                var start = -Math.PI / 2;
                for (var s = 0; s < values.length; ++s) {
                    var span = Math.max(0, values[s]) / total * Math.PI * 2;
                    ctx.beginPath();
                    ctx.moveTo(cx, cy);
                    ctx.arc(cx, cy, radius, start, start + span);
                    ctx.closePath();
                    ctx.fillStyle = root.palette[s % root.palette.length];
                    ctx.fill();
                    start += span;
                }
                if (type === "donut") {
                    ctx.beginPath();
                    ctx.arc(cx, cy, radius * 0.57, 0, Math.PI * 2);
                    ctx.fillStyle = Theme.card;
                    ctx.fill();
                }
                ctx.font = "11px sans-serif";
                ctx.textAlign = "left";
                ctx.textBaseline = "middle";
                for (var l = 0; l < Math.min(labels.length, 7); ++l) {
                    var legendY = 18 + l * 22;
                    ctx.fillStyle = root.palette[l % root.palette.length];
                    ctx.fillRect(width * 0.65, legendY - 5, 9, 9);
                    ctx.fillStyle = Theme.textSecondary;
                    ctx.fillText(labels[l].slice(0, 14), width * 0.65 + 15, legendY);
                }
                return;
            }

            if (values.length === 0) {
                ctx.fillStyle = Theme.textSecondary;
                ctx.font = "13px sans-serif";
                ctx.textAlign = "center";
                ctx.fillText("No numeric data for this field", width / 2, height / 2);
                return;
            }

            var left = 38;
            var top = 12;
            var right = width - 12;
            var bottom = height - 26;
            var chartWidth = Math.max(1, right - left);
            var chartHeight = Math.max(1, bottom - top);
            var minValue = Math.min(0, Math.min.apply(null, values));
            var maxValue = Math.max(1, Math.max.apply(null, values));
            if (maxValue === minValue)
                maxValue = minValue + 1;
            var zeroY = bottom - (0 - minValue) / (maxValue - minValue) * chartHeight;

            ctx.strokeStyle = Theme.border;
            ctx.lineWidth = 1;
            for (var g = 0; g <= 3; ++g) {
                var gridY = top + chartHeight * g / 3;
                ctx.beginPath();
                ctx.moveTo(left, gridY);
                ctx.lineTo(right, gridY);
                ctx.stroke();
            }

            var points = [];
            for (var n = 0; n < values.length; ++n) {
                var px = values.length === 1
                    ? left + chartWidth / 2
                    : left + chartWidth * n / (values.length - 1);
                var py = bottom - (values[n] - minValue) / (maxValue - minValue) * chartHeight;
                points.push({ x: px, y: py });
            }

            if (type === "bar") {
                var slot = chartWidth / values.length;
                for (var b = 0; b < points.length; ++b) {
                    ctx.fillStyle = root.palette[b % root.palette.length];
                    var barTop = Math.min(points[b].y, zeroY);
                    var barHeight = Math.max(2, Math.abs(zeroY - points[b].y));
                    ctx.fillRect(points[b].x - slot * 0.32, barTop,
                                 Math.max(2, slot * 0.64), barHeight);
                }
            } else if (type === "scatter") {
                for (var d = 0; d < points.length; ++d) {
                    ctx.beginPath();
                    ctx.arc(points[d].x, points[d].y, 4, 0, Math.PI * 2);
                    ctx.fillStyle = root.chartColor;
                    ctx.fill();
                }
            } else {
                ctx.beginPath();
                ctx.moveTo(points[0].x, points[0].y);
                for (var q = 1; q < points.length; ++q)
                    ctx.lineTo(points[q].x, points[q].y);
                if (type === "area") {
                    ctx.lineTo(points[points.length - 1].x, zeroY);
                    ctx.lineTo(points[0].x, zeroY);
                    ctx.closePath();
                    ctx.globalAlpha = 0.25;
                    ctx.fillStyle = root.chartColor;
                    ctx.fill();
                    ctx.globalAlpha = 1;
                    ctx.beginPath();
                    ctx.moveTo(points[0].x, points[0].y);
                    for (var a = 1; a < points.length; ++a)
                        ctx.lineTo(points[a].x, points[a].y);
                }
                ctx.strokeStyle = root.chartColor;
                ctx.lineWidth = 2;
                ctx.stroke();
                for (var c = 0; c < points.length; ++c) {
                    ctx.beginPath();
                    ctx.arc(points[c].x, points[c].y, 3, 0, Math.PI * 2);
                    ctx.fillStyle = root.chartColor;
                    ctx.fill();
                }
            }

            ctx.fillStyle = Theme.textSecondary;
            ctx.font = "10px sans-serif";
            ctx.textAlign = "center";
            if (labels.length > 0) {
                ctx.fillText(labels[0].slice(0, 12), left, height - 7);
                if (labels.length > 1)
                    ctx.fillText(labels[labels.length - 1].slice(0, 12), right, height - 7);
            }
        }
    }

    onRowsChanged: canvas.requestPaint()
    onWidgetChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
}
