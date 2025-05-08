import sys
from random import choice
from dataclasses import dataclass
from PySide6.QtWidgets import QApplication, QMainWindow, QPushButton

window_titles = [
    "My App",
    "My App",
    "Still My App",
    "Still My App",
    "What on earth",
    "What on earth",
    "This is surprising",
    "This is surprising",
    "Something went wrong",
]


@dataclass
class AppState:
    num_times_clicked: int = 0
    app_title: str = "Fuck You"


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.state = AppState()
        self.setWindowTitle(self.state.app_title)

        self.button = QPushButton("Press Me!")
        self.button.clicked.connect(self.the_button_was_clicked)
        self.windowTitleChanged.connect(self.the_window_title_changed)
        self.setCentralWidget(self.button)

    def the_button_was_clicked(self):
        self.state.num_times_clicked += 1
        new_window_title = choice(window_titles)
        self.setWindowTitle(new_window_title)

    def the_window_title_changed(self, window_title):
        print("Window title changed: %s" % window_title)

        if window_title == "Something went wrong":
            self.button.setDisabled(True)


app = QApplication(sys.argv)

window = MainWindow()
window.show()

app.exec()
