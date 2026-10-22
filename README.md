# My Emacs Configuration

A personal GNU Emacs setup in a single `init.el`. It is built around
`use-package`, which installs every package automatically from GNU ELPA and
MELPA the first time Emacs starts.

## Features

- **Dashboard** start page with recent files, projects, bookmarks and agenda.
- **Notes** with Org-roam in `~/org-roam` (created on first use), with the
  database kept in sync automatically and `M-x org-roam-ui-open` for a graph
  view in the browser. In Org buffers, Shift+arrow keys select text.
- **Projects** via Projectile, searching `~/projects`.
- **Remote editing** over TRAMP (SSH by default). Each SSH host you open in
  Dired is bookmarked automatically as `ssh:<host>`.
- **Git** via Magit.
- **IDE features** via `lsp-mode` + `lsp-ui` (peek, sideline, docs at point)
  for Python, JavaScript, TypeScript, C and C++.
- **Python**: Pyright language server. A project-local `.venv/bin/python` is
  picked up automatically.
- **Completion and checking**: Company everywhere, Flycheck everywhere,
  `which-key` popups for key prefixes.
- **Snippets** via YASnippet with the `yasnippet-snippets` collection, plus
  your own snippets from `~/projects/yasnippet-snippets/snippets` if that
  folder exists. `TAB` is left alone; use `M-<tab>` to insert a snippet.
- **AI pair programming** via [aidermacs](https://github.com/MatthewZMD/aidermacs)
  (Aider, architect mode, default model `gpt-5-mini`, auto-commits on).
- **Look**: `leuven-dark` theme, no tool bar, recent files and minibuffer
  history saved between sessions.

## Requirements

- GNU Emacs 29 or newer (tested on 30.1).
- Network access on first start, to download packages.
- External tools, for the features you use:

| Feature              | Install                                                        |
|----------------------|----------------------------------------------------------------|
| Python LSP           | `pyright` (`npm install -g pyright` or `pip install pyright`)  |
| JavaScript/TypeScript LSP | `npm install -g typescript-language-server typescript`    |
| C/C++ LSP            | `clangd` (from your distro's LLVM/clang package)               |
| Aider                | `aider` on `PATH` (`python -m pip install aider-install && aider-install`) and `OPENAI_API_KEY` exported in your shell |
| Dashboard icons (GUI)| Run `M-x all-the-icons-install-fonts` once                     |

## Installation

Back up any existing config first, then clone into your Emacs directory:

```sh
mv ~/.emacs.d ~/.emacs.d.bak 2>/dev/null
git clone http://forgejo.internal.binary-rise/teo.parashkevov/emacs-config.git ~/.emacs.d
emacs
```

You can also clone into `~/.config/emacs`. Note that Emacs uses `~/.emacs.d`
instead whenever that directory exists.

The first start takes a minute while packages are downloaded and compiled.

## Key bindings

| Key        | Command                                      |
|------------|----------------------------------------------|
| `C-c h`    | Open the dashboard                           |
| `C-c n f`  | Find or create an Org-roam note              |
| `C-c n i`  | Insert a link to an Org-roam note            |
| `C-c n l`  | Toggle the Org-roam backlinks buffer         |
| `C-x g`    | Magit status                                 |
| `C-c a`    | Aidermacs menu                               |
| `C-c l`    | LSP command prefix (in LSP buffers)          |
| `M-.`      | Peek definitions (in LSP buffers)            |
| `M-?`      | Peek references (in LSP buffers)             |
| `M-<tab>`  | Insert a snippet (YASnippet)                 |

Press any prefix and wait to see the available keys in the `which-key` popup.

## Contributing

Every change goes `feature/<name>` → `development` → `main`, each step through
a pull request. See [AGENTS.md](AGENTS.md) for the full workflow, how to
verify a change, and the coding conventions.

## License

GPL-3.0. See [LICENSE](LICENSE).
