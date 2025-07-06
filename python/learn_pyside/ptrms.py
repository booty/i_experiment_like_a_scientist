from __future__ import annotations
import sys
import random
from typing import Optional, Callable

import numpy as np
from PySide6.QtCore import Qt
from PySide6.QtGui import QAction, QDragEnterEvent, QDropEvent, QFont, QFontMetrics
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QWidget,
    QVBoxLayout,
    QLabel,
    QFrame,
    QFileDialog,
    QDialog,
    QSizePolicy,
)
from PySide6.QtCharts import QChart, QChartView, QLineSeries


class AutoResizeLabel(QLabel):
    """QLabel that auto-adjusts font size to fill its content area."""

    def resizeEvent(self, event) -> None:
        super().resizeEvent(event)
        self._adjust_font_size()

    def setText(self, text: str) -> None:
        super().setText(text)
        self._adjust_font_size()

    def _adjust_font_size(self) -> None:
        text = self.text()
        if not text:
            return
        # Binary search best point size
        lo, hi = 1, 500
        best = lo
        while lo <= hi:
            mid = (lo + hi) // 2
            font = QFont(self.font())
            font.setPointSize(mid)
            fm = QFontMetrics(font)
            if (
                fm.height() <= self.height()
                and fm.horizontalAdvance(text) <= self.width()
            ):
                best = mid
                lo = mid + 1
            else:
                hi = mid - 1
        font = QFont(self.font())
        font.setPointSize(best)
        super().setFont(font)


class FileDropWidget(QLabel):
    def __init__(
        self, on_file: Callable[[str], None], parent: Optional[QWidget] = None
    ) -> None:
        super().__init__(parent)
        self.on_file = on_file
        self.setText("Drag a file here, or click to browse…")
        self.setAlignment(Qt.AlignCenter)
        self.setFixedHeight(100)
        self.setFrameShape(QFrame.StyledPanel)
        self.setAcceptDrops(True)

    def dragEnterEvent(self, event: QDragEnterEvent) -> None:
        if event.mimeData().hasUrls():
            event.acceptProposedAction()

    def dropEvent(self, event: QDropEvent) -> None:
        for url in event.mimeData().urls():
            path = url.toLocalFile()
            if path:
                self.on_file(path)
                break

    def mousePressEvent(self, event) -> None:
        path, _ = QFileDialog.getOpenFileName(self, "Select File")
        if path:
            self.on_file(path)


class SettingsDialog(QDialog):
    def __init__(self, parent: Optional[QWidget] = None) -> None:
        super().__init__(parent)
        self.setWindowTitle("Settings")
        self.resize(400, 300)
        # Empty for now; add widgets/layout when needed


class MainWindow(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("PTRMS - MassMatrix™")
        self.resize(1280, 720)

        # Menu
        mb = self.menuBar()
        mb.setNativeMenuBar(False)
        file_menu = mb.addMenu("&File")
        settings_act = QAction("Settings", self)
        settings_act.triggered.connect(self.open_settings)
        file_menu.addAction(settings_act)

        # Central layout
        central = QWidget()
        layout = QVBoxLayout(central)
        self.setCentralWidget(central)

        # File drop / click area (always at top)
        self.drop_widget = FileDropWidget(self.process_file)
        layout.addWidget(self.drop_widget)

        # Status color area (hidden until processing)
        self.status_frame = QFrame()
        self.status_frame.setFixedHeight(30)
        layout.addWidget(self.status_frame)
        self.status_frame.hide()

        # Detailed results label (hidden until processing)
        self.result_label = AutoResizeLabel("")
        self.result_label.setWordWrap(True)
        self.result_label.setAlignment(Qt.AlignCenter)
        self.result_label.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        layout.addWidget(self.result_label)
        # self.result_label.hide()

        # Random-data graph (hidden until processing)
        self.chart = QChart()
        self.chart.legend().hide()
        self.chart_view = QChartView(self.chart)
        self.chart_view.setMinimumHeight(300)
        layout.addWidget(self.chart_view)
        # self.chart_view.hide()

        # Initial empty plot
        self._plot_random_data()

    def open_settings(self) -> None:
        dlg = SettingsDialog(self)
        dlg.exec()

    def process_file(self, path: str) -> None:
        success = random.choice([True, False])
        # Status bar
        self.status_frame.setStyleSheet(
            f"background-color: {'green' if success else 'red'};"
        )
        self.status_frame.show()

        # PASS/FAIL label
        if success:
            self.result_label.setStyleSheet(
                "background-color: green; color: lightgreen;"
            )
            self.result_label.setText("PASS")
        else:
            self.result_label.setStyleSheet("background-color: red; color: lightcoral;")
            self.result_label.setText("FAIL")

        self.result_label.show()
        self.chart_view.show()

        # Update plot with random data
        self._plot_random_data()

    def _plot_random_data(self) -> None:
        """Generate random data and plot it in the chart."""
        x = np.arange(100)
        y = np.random.random(100)

        series = QLineSeries()
        for xi, yi in zip(x, y):
            series.append(float(xi), float(yi))

        self.chart.removeAllSeries()
        self.chart.addSeries(series)
        self.chart.createDefaultAxes()
        self.chart.axisX().setTitleText("X")
        self.chart.axisY().setTitleText("Y")
        self.chart.setTitle("Random Data Plot")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    win = MainWindow()
    win.show()
    sys.exit(app.exec())
