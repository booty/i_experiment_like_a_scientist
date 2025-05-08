import sys
import random
from typing import Optional, List
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
)
from PySide6.QtGui import QPalette, QColor
from layout_colorwidget import ColoredBox


class SickPalette:
    soft_blue = QColor("#4A90E2")
    warm_orange = QColor("#F5A623")
    fresh_green = QColor("#7ED321")
    cool_teal = QColor("#50E3C2")
    gentle_violet = QColor("#9013FE")
    calm_gray = QColor("#9B9B9B")
    elegant_navy = QColor("#34495E")
    soft_rose = QColor("#FF6F61")
    sky_blue = QColor("#7BAAF7")
    dusty_beige = QColor("#D8C3A5")

    _colors = [
        soft_blue,
        warm_orange,
        fresh_green,
        cool_teal,
        gentle_violet,
        calm_gray,
        elegant_navy,
        soft_rose,
        sky_blue,
        dusty_beige,
    ]

    @classmethod
    def random(cls, exclude: Optional[List[Optional[QColor]]] = None) -> QColor:
        exclude_hexes = (
            {color.name() for color in exclude if isinstance(color, QColor)}
            if exclude
            else set()
        )
        choices = [color for color in cls._colors if color.name() not in exclude_hexes]
        if not choices:
            raise ValueError("No colors available to choose from after exclusions.")
        return random.choice(choices)


class MainWindow(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("My App")

        outer_layout = QVBoxLayout()

        outer_color_prev = None
        for x in range(1, 5):
            outer_color: QColor = SickPalette.random(exclude=[outer_color_prev])
            # outer_layout.addWidget(ColoredBox(outer_color))

            inner_layout = QHBoxLayout()
            inner_color_prev = None
            for x in range(1, 4):
                inner_color: QColor = SickPalette.random(
                    exclude=[outer_color_prev, inner_color_prev]
                )
                inner_layout.addWidget(ColoredBox(inner_color))
                inner_color_prev = inner_color
            outer_layout.addLayout(inner_layout)
            outer_color_prev = outer_color
        widget = QWidget()
        widget.setLayout(outer_layout)
        self.setCentralWidget(widget)


app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()
