# Learn Pyside 6

Based on: [https://www.pythonguis.com/pyside6-tutorial/](https://www.pythonguis.com/pyside6-tutorial/)

## Notes

- In Qt _all_ top level widgets are windows. (Technically, you can create a window using any widget you like...
- Every app needs one (and only one) `QApplication` object
  - It holds the event loop
- "Signals" == "Events"
  - Usually result of user action, but not always
- "Slots" == receivers of signals
