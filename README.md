# jordan-nvim

Started off with nvim kickstart (would highly recommend)

Most important plugins:
- Native LSP (`vim.lsp.config`/`enable`) + mason, blink.cmp for completion
- nvim-treesitter (main branch) with native highlight/fold/indent, textobjects, context
- Snacks for pickers, lazygit, notifier; mini.files explorer; harpoon
- conform (format on save) + nvim-lint
- Gitsigns, diffview, fugitive, octo for git/GitHub
- nvim-dap (+ ui, virtual text) for debugging
- sidekick + claudecode + codecompanion for AI agents (see below)

Things to install first outside of neovim
- fortune (dashboard)
- cowsay (dashboard)
- ripgrep (grugfar, and a couple others)
- Neovim 0.12+, tree-sitter-cli, node, lazygit

## AI agents (Claude Code, Codex, Gemini)

All agents run on **subscription logins**. Neovim strips `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`,
`GEMINI_API_KEY` and `GOOGLE_API_KEY` from its environment so the CLIs use their logins.

One-time setup:

```sh
npm i -g typescript @anthropic-ai/claude-code @openai/codex @google/gemini-cli \
  @zed-industries/claude-agent-acp @zed-industries/codex-acp
claude            # /login with your Claude subscription
codex login       # Sign in with ChatGPT
gemini            # choose "Sign in with Google"
# Chat buffer (<leader>ao) for Claude needs a subscription token in the Keychain:
claude setup-token   # copy the token it prints, then:
security add-generic-password -a "$USER" -s claude-code-oauth-token -w '<token>'
```

Notifications come from `~/.local/bin/agent-notify` (in the dotfiles repo), wired up as a
Claude `Stop`/`Notification` hook, a Codex `notify` entry and a Gemini `AfterAgent`/`Notification` hook.

| Keys | Action |
| --- | --- |
| `<C-.>` / `<leader>aa` | Toggle agent terminal |
| `<leader>as` | Pick agent (Claude / Codex / Gemini) |
| `<leader>ac` `ax` `ag` | Claude / Codex / Gemini |
| `<leader>at` `af` `av` | Send this / file / selection |
| `<leader>ad` `aQ` | Fix diagnostics / quickfix list |
| `<leader>ap` | Prompt picker |
| `<leader>ak` | One-shot question (default agent, `<leader>a.` to change) |
| `<leader>ar` | Cross-agent review of uncommitted changes → quickfix |
| `<leader>aw` / `aW` | New worktree + agent / manage worktrees |
| `<leader>aD` | Review uncommitted changes in diffview |
| `<leader>ay` / `an` | Accept / deny Claude diff |
| `<leader>am` | Claude model |
| `<leader>ao` | Chat with any agent over ACP (codecompanion) |
| `<leader>aC` | (in a commit buffer) write the commit message |
| `ga` | (in mini.files) send file to agent |
