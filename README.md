# claude-setup

Claude Code configuration that follows me across machines. `install.sh` symlinks each managed entry from this repo into `~/.claude`, so an edit in either place is an edit in the repo.

## Fresh machine

```sh
git clone https://github.com/WhiskyTangoFawks/claude-setup.git ~/claude-setup
~/claude-setup/install.sh
```

The script lists the managed entries. It refuses to overwrite anything already in `~/.claude`. If it fails, move the file in the way into this repo or delete it, then run it again. Running it twice is safe.

Set `CLAUDE_HOME` to install somewhere other than `~/.claude`.

## Tests

```sh
./test/install_test.sh
```
