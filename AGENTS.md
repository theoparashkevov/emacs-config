# AGENTS.md

Guidance for anyone (human or AI agent) changing this repository.

## What this repo is

A personal GNU Emacs configuration. The whole config lives in a single
`init.el` (lexical binding, `use-package` with `use-package-always-ensure t`,
packages from GNU ELPA and MELPA). Target: Emacs 30.

| Path        | Purpose                                  |
|-------------|------------------------------------------|
| `init.el`   | The entire configuration                 |
| `README.md` | User-facing description and install notes |
| `AGENTS.md` | This file: workflow and conventions      |
| `LICENSE`   | GPL-3.0                                  |

The remote is a Forgejo instance (`origin`). It is not GitHub, so `gh` does
not work against it. Open pull requests in the Forgejo web UI, or with the
Forgejo CLI (`tea`) if it is installed.

## Branching model

```
feature/<name>  ──PR──▶  development  ──PR──▶  main
```

- `main` is the stable branch. It must always load cleanly on a fresh
  machine. It changes only through a release PR from `development`.
- `development` is the integration branch. It receives feature PRs.
- `feature/<name>` holds one change, branched from the latest `development`.

### Rules

1. **Never push directly to `main` or `development`.** Every change, however
   small (typo, docs, a single setting), goes through a pull request.
2. **Every new branch starts from `development`**, never from `main` or from
   another feature branch:
   ```sh
   git switch development
   git pull --ff-only origin development
   git switch -c feature/<name>
   ```
3. **Branch names** are `feature/<short-kebab-case-description>`, for example
   `feature/yasnippet`, `feature/fix-openai-key`, `feature/gitignore`.
4. **One concern per branch and PR.** Adding a package, fixing a bug and
   reformatting are three PRs.
5. **Feature PRs target `development`.** Before opening or merging, rebase on
   the current `development`:
   ```sh
   git fetch origin
   git rebase origin/development
   git push --force-with-lease
   ```
6. **Release PRs go from `development` to `main`.** Open one once
   `development` has been used day to day and is known to work.
7. **Merge strategy:**
   - feature → `development`: **squash merge**, so each feature becomes one
     commit on `development`.
   - `development` → `main`: **merge commit**, not squash or rebase. This keeps
     `main` an ancestor of `development`, so the two branches never diverge.
8. Delete the feature branch after its PR is merged.
9. If a fix is urgent, it still goes `feature/<name>` → `development` → `main`,
   with two quick PRs. There is no path straight to `main`.

### Archived legacy config

The old per-machine branches (`codespace`, `home`, `ibm-server`,
`surface-pro-2`) used the Org-babel (`org/init.org`) layout that predates the
single-`init.el` refactor. They have been deleted. Their final state is kept
as the tags `archive/codespace`, `archive/home`, `archive/ibm-server` and
`archive/surface-pro-2`, viewable with for example
`git show archive/home:org/init.org`.

Their useful parts (YASnippet, Org-roam, multi-term) were ported into
`init.el`. Do not branch from or merge the archive tags. To bring something
else over, re-implement it in `init.el` on a new `feature/*` branch. Do not
create new per-machine branches. Handle machine differences inside `init.el`
instead.

## Commits and PRs

- Commit messages: imperative mood, short subject (≤ 72 characters), for
  example `Add yasnippet with C-<tab> expansion`. Explain the "why" in the
  body when it is not obvious.
- PR description: say what changed, why, and how you verified it (see below).
  Mention any new external dependency (language server, CLI tool, font).

## Verifying a change

Run these before opening a PR. They use a throwaway init directory, so your
real `~/.emacs.d` is not touched. The first run downloads every package and
needs network access.

```sh
# 1. The config loads from scratch without errors
T=$(mktemp -d) && cp init.el "$T/" \
  && emacs --batch --init-directory="$T" -l "$T/init.el" \
       --eval '(message "init OK")'

# 2. No new byte-compile warnings from init.el itself
emacs --batch --init-directory="$T" -l "$T/init.el" \
  --eval '(byte-compile-file "init.el")' 2>&1 | grep -E '^init\.el:'
```

The first command must print `init OK` and exit with status 0. For the second,
compare its output with the same check on `development` and do not add new
warnings. For UI-visible changes (theme, dashboard, keybindings), also start a
real `emacs` session and look.

## Coding conventions for `init.el`

- Keep the `lexical-binding: t` header and the
  `;;; Commentary:` / `;;; Code:` / `;;; init.el ends here` structure.
- Group config into sections with the existing banner style:
  ```elisp
  ;; ----------------------------
  ;; SECTION NAME
  ;; ----------------------------
  ```
- One `use-package` form per package. Use `:init` / `:config` / `:hook` /
  `:bind` / `:custom` rather than loose top-level `setq` and `add-hook` calls
  for that package's settings.
- Prefer lazy loading (`:commands`, `:hook`, `:bind`, `:defer`). Do not add
  eager `require` calls that slow down startup unless they are needed.
- Prefix personal functions and variables with `my/` (for example
  `my/use-project-venv-python`).
- Before you add a package, check that it is not already built in (Emacs 30
  ships `use-package`, `eglot`, `which-key`, tree-sitter modes, and more).
- **No secrets in the repo.** API keys and tokens come from the environment or
  `auth-source` (`~/.authinfo.gpg`), never from string literals in `init.el`.
- **No machine-specific values** (hostnames, `/home/<user>` paths, per-device
  font sizes) hard-coded into the shared config. Use `user-emacs-directory`,
  `~`, or a guarded conditional instead.
- Do not commit generated or runtime state: `elpa/`, `eln-cache/`,
  `auto-save-list/`, `recentf`, `history`, `bookmarks`, tramp history, and
  `custom-set-variables` noise.
- When you add or remove a package or a keybinding, update `README.md` if it
  documents it, and update this file if you change the workflow or layout.
