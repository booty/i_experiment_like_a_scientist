Since `guard` doesn't seem to work with Ruby 4 (yet) a suggested alternative is:

```bash
brew install entr
ls *.rb | entr -c ruby /_
```

Other possibilities might be `watchexec`, `watchman`, `fswatch`, or `inotifywait`.
