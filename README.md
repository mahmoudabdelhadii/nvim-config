# jordan-nvim

Started off with nvim kickstart (would highly recommend)

Plugins (33):
- Native LSP (`vim.lsp.config`/`enable`) + mason, blink.cmp, conform, nvim-lint
- nvim-treesitter (main branch) with native highlight/fold/indent, textobjects, context
- Snacks: pickers, lazygit, terminal, notifier; mini.files, harpoon, flash, grug-far
- gitsigns + diffview + lazygit for git
- sidekick for AI agents

Install first: Neovim 0.12+, tree-sitter-cli, node, ripgrep, fd, lazygit, `npm i -g typescript`

## AI agents

`<C-.>` / `<leader>aa` toggles the agent panel, `<leader>as` picks Claude Code / Codex / Gemini,
`<leader>at` sends the code under the cursor (or selection), `<leader>af` the file, `<leader>ap` opens prompts.

Agents use subscription logins (`claude` → /login, `codex login`, `gemini` → Sign in with Google);
Neovim drops `*_API_KEY` env vars so they can't take precedence.
