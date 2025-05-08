# Learn Pyside 6

Based on: [https://www.pythonguis.com/pyside6-tutorial/](https://www.pythonguis.com/pyside6-tutorial/)

## Setup

MacOS

```bash
brew install qt. # this takes a while =)

# MacOS - Apple Silicon
open /opt/homebrew/opt/qt/bin/Designer

# MacOS - Intel
open -a /usr/local/opt/qt/bin/Designer.app

# Or, optionally
echo 'export PATH="/opt/homebrew/opt/qt/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Notes

- In Qt _all_ top level widgets are windows. (Technically, you can create a window using any widget you like...
- Every app needs one (and only one) `QApplication` object
  - It holds the event loop
- "Signals" == "Events"
  - Usually result of user action, but not always
- "Slots" == receivers of signals
- Qt Designer (.ui) files
  - XML descriptions of widget hierarchies
  - At runtime
    - Dynamically load them via QUiLoader (e.g. PySide6.QtUiTools.QUiLoader), or
    - Statically convert them to code with uic (pyside6-uic / python -m PySide6.scripts.uic) which spits out a Python (or C++) module.
- Widgets have "slots" and "receivers"

### Layouts

- Determine how widgets are positioned
