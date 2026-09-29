---@brief
---
--- https://github.com/astral-sh/ty
---
--- Astral's Python type checker and language server (the ruff people). It
--- provides what ruff does not: types, hover, go-to-definition, references and
--- completions. ruff keeps linting and formatting.
---
--- ```sh
--- sudo pacman -S ty
--- ```
---
--- Until it is installed, vim.lsp.enable() skips it silently.
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
}
