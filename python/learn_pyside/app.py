from PySide6.QtWidgets import QApplication, QWidget, QPushButton, QMainWindow


import sys


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Hello World, We're Back")

        self.setFixedSize(400, 300)
        self.setCentralWidget(QPushButton("Click Me"))


app = QApplication(sys.argv)

window = MainWindow()
window.show()  # windows are hidden by default

app.exec()  # start the event loop

print("OK, we're exiting...")
