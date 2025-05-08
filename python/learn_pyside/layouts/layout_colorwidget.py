from PySide6.QtGui import QPalette, QColor
from PySide6.QtWidgets import QWidget


class ColoredBox(QWidget):
    def __init__(self, color):
        super().__init__()
        self.setAutoFillBackground(True)

        palette = self.palette()
        palette.setColor(QPalette.ColorRole.Window, QColor(color))
        self.setPalette(palette)
