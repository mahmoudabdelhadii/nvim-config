return {
  'DanWlker/toolbox.nvim',
  keys = {
    {
      '<leader>st',
      function()
        require('toolbox').show_picker()
      end,
      desc = '[S]earch [T]oolbox',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gp',
      function()
        -- Quick access to git publish workflow
        require('toolbox').run_command 'Git: Publish Current Work'
      end,
      desc = '[G]it [P]ublish work to new branch',
    },
  },
  -- If you want to use your custom vim.ui.select overrides, remember to add it into dependencies
  -- to ensure it loads first
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    commands = {
      -- Enhanced Git Workflows
      {
        name = 'Git: Publish Current Work',
        execute = function()
          -- Check if there are changes to commit
          local status_output = vim.fn.system 'git status --porcelain'
          if status_output == '' then
            vim.notify('No changes to publish', vim.log.levels.WARN)
            return
          end

          -- Get branch name via input popup
          vim.ui.input({
            prompt = 'Branch name: ',
            default = 'feature/',
          }, function(branch_name)
            if not branch_name or branch_name == '' then
              vim.notify('Branch name required', vim.log.levels.ERROR)
              return
            end

            -- Show progress notification
            local progress = vim.notify('Publishing work...', vim.log.levels.INFO, { timeout = false })

            -- Create and switch to new branch
            local create_branch = vim.fn.system('git checkout -b ' .. vim.fn.shellescape(branch_name))
            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to create branch: ' .. create_branch, vim.log.levels.ERROR)
              return
            end

            -- Add all changes
            vim.fn.system 'git add .'

            -- Get commit message via input popup
            vim.ui.input({
              prompt = 'Commit message: ',
              default = 'Work in progress: ' .. branch_name,
            }, function(commit_msg)
              if not commit_msg or commit_msg == '' then
                commit_msg = 'Work in progress: ' .. branch_name
              end

              -- Commit changes
              local commit_result = vim.fn.system('git commit -m ' .. vim.fn.shellescape(commit_msg))
              if vim.v.shell_error ~= 0 then
                vim.notify('Failed to commit: ' .. commit_result, vim.log.levels.ERROR)
                return
              end

              -- Push to remote
              local push_result = vim.fn.system('git push -u origin ' .. vim.fn.shellescape(branch_name))
              if vim.v.shell_error ~= 0 then
                vim.notify('Failed to push: ' .. push_result, vim.log.levels.ERROR)
                return
              end

              vim.notify('Successfully published work to branch: ' .. branch_name, vim.log.levels.INFO)
            end)
          end)
        end,
        weight = 10,
      },
      {
        name = 'Git: Quick Commit & Push',
        execute = function()
          -- Check if there are changes to commit
          local status_output = vim.fn.system 'git status --porcelain'
          if status_output == '' then
            vim.notify('No changes to commit', vim.log.levels.WARN)
            return
          end

          -- Get commit message via input popup
          vim.ui.input({
            prompt = 'Commit message: ',
          }, function(commit_msg)
            if not commit_msg or commit_msg == '' then
              vim.notify('Commit message required', vim.log.levels.ERROR)
              return
            end

            -- Add all changes
            vim.fn.system 'git add .'

            -- Commit changes
            local commit_result = vim.fn.system('git commit -m ' .. vim.fn.shellescape(commit_msg))
            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to commit: ' .. commit_result, vim.log.levels.ERROR)
              return
            end

            -- Push to current branch
            local push_result = vim.fn.system 'git push'
            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to push: ' .. push_result, vim.log.levels.ERROR)
              return
            end

            vim.notify('Successfully committed and pushed changes', vim.log.levels.INFO)
          end)
        end,
        weight = 9,
      },
      {
        name = 'Git: Create Branch & Publish',
        execute = function()
          vim.ui.input({
            prompt = 'New branch name: ',
            default = 'feature/',
          }, function(branch_name)
            if not branch_name or branch_name == '' then
              vim.notify('Branch name required', vim.log.levels.ERROR)
              return
            end

            -- Create and switch to new branch
            local result = vim.fn.system('git checkout -b ' .. vim.fn.shellescape(branch_name))
            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to create branch: ' .. result, vim.log.levels.ERROR)
              return
            end

            -- Push new branch to remote
            local push_result = vim.fn.system('git push -u origin ' .. vim.fn.shellescape(branch_name))
            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to push branch: ' .. push_result, vim.log.levels.ERROR)
              return
            end

            vim.notify('Created and published branch: ' .. branch_name, vim.log.levels.INFO)
          end)
        end,
        weight = 8,
      },
      {
        name = 'Git: Publish Current Branch',
        execute = function()
          -- Get current branch name
          local current_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
          if vim.v.shell_error ~= 0 or current_branch == '' then
            vim.notify('Failed to get current branch', vim.log.levels.ERROR)
            return
          end

          -- Check if branch already exists on remote
          local remote_check = vim.fn.system('git ls-remote --heads origin ' .. vim.fn.shellescape(current_branch))
          local is_new_branch = remote_check == ''

          -- Push current branch to remote
          local push_cmd = is_new_branch and 'git push -u origin ' .. vim.fn.shellescape(current_branch) or 'git push'
          local push_result = vim.fn.system(push_cmd)

          if vim.v.shell_error ~= 0 then
            vim.notify('Failed to push: ' .. push_result, vim.log.levels.ERROR)
            return
          end

          local action = is_new_branch and 'Published new branch' or 'Updated branch'
          vim.notify(action .. ': ' .. current_branch, vim.log.levels.INFO)
        end,
        weight = 7,
      },
      {
        name = 'Git: Quick Stash',
        execute = function()
          vim.ui.input({
            prompt = 'Stash message (optional): ',
            default = 'WIP: ' .. os.date '%H:%M',
          }, function(msg)
            local cmd = msg and msg ~= '' and 'git stash push -m ' .. vim.fn.shellescape(msg) or 'git stash'
            local result = vim.fn.system(cmd)

            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to stash: ' .. result, vim.log.levels.ERROR)
              return
            end

            vim.notify('Stashed changes: ' .. (msg or 'no message'), vim.log.levels.INFO)
          end)
        end,
        weight = 6,
      },
      {
        name = 'Git: Restore Stash',
        execute = function()
          -- Get list of stashes
          local stashes = vim.fn.systemlist 'git stash list --pretty=format:"%gd: %s"'
          if vim.v.shell_error ~= 0 or #stashes == 0 then
            vim.notify('No stashes found', vim.log.levels.WARN)
            return
          end

          -- Show stash selection menu
          vim.ui.select(stashes, {
            prompt = 'Select stash to restore:',
            format_item = function(item)
              return item
            end,
          }, function(choice)
            if not choice then
              return
            end

            -- Extract stash reference (e.g., "stash@{0}")
            local stash_ref = choice:match '^([^:]+)'
            if not stash_ref then
              vim.notify('Invalid stash selection', vim.log.levels.ERROR)
              return
            end

            -- Ask for restore method
            local restore_options = {
              'Apply (keep stash)',
              'Pop (remove stash)',
            }

            vim.ui.select(restore_options, {
              prompt = 'Restore method:',
            }, function(method)
              if not method then
                return
              end

              local cmd = method:match '^Apply' and 'git stash apply ' or 'git stash pop '
              local result = vim.fn.system(cmd .. vim.fn.shellescape(stash_ref))

              if vim.v.shell_error ~= 0 then
                vim.notify('Failed to restore stash: ' .. result, vim.log.levels.ERROR)
                return
              end

              local action = method:match '^Apply' and 'Applied' or 'Popped'
              vim.notify(action .. ' stash: ' .. choice, vim.log.levels.INFO)
            end)
          end)
        end,
        weight = 5,
      },
      {
        name = 'Git: Create Pull Request',
        execute = function()
          -- Get current branch name
          local current_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
          if vim.v.shell_error ~= 0 or current_branch == '' then
            vim.notify('Failed to get current branch', vim.log.levels.ERROR)
            return
          end

          -- Check if we're on main/master
          if current_branch == 'main' or current_branch == 'master' then
            vim.notify('Cannot create PR from main/master branch', vim.log.levels.ERROR)
            return
          end

          -- Check if PR already exists
          local pr_check = vim.fn.system('gh pr view ' .. vim.fn.shellescape(current_branch) .. ' --json url 2>/dev/null')
          if vim.v.shell_error == 0 then
            -- PR exists, ask if user wants to view it
            vim.ui.select({ 'View existing PR', 'Cancel' }, {
              prompt = 'PR already exists for branch: ' .. current_branch,
            }, function(choice)
              if choice == 'View existing PR' then
                vim.fn.system('gh pr view ' .. vim.fn.shellescape(current_branch) .. ' --web')
              end
            end)
            return
          end

          -- No PR exists, create one
          vim.ui.input({
            prompt = 'PR Title: ',
            default = current_branch:gsub('^[^/]+/', ''):gsub('[_-]', ' '),
          }, function(title)
            if not title or title == '' then
              vim.notify('PR title required', vim.log.levels.ERROR)
              return
            end

            vim.ui.input({
              prompt = 'PR Description (optional): ',
            }, function(description)
              -- Ask for base branch
              vim.ui.input({
                prompt = 'Base branch (default: main): ',
                default = 'main',
              }, function(base)
                -- Build PR creation command with required flags
                local cmd = 'gh pr create --title ' .. vim.fn.shellescape(title)
                cmd = cmd .. ' --body ' .. vim.fn.shellescape(description or '')

                if base and base ~= '' and base ~= 'main' then
                  cmd = cmd .. ' --base ' .. vim.fn.shellescape(base)
                end

                -- Create PR
                local result = vim.fn.system(cmd)
                if vim.v.shell_error ~= 0 then
                  vim.notify('Failed to create PR: ' .. result, vim.log.levels.ERROR)
                  return
                end

                vim.notify('PR created successfully!', vim.log.levels.INFO)

                -- Ask if user wants to view PR
                vim.ui.select({ 'View PR in browser', 'Continue working' }, {
                  prompt = 'PR created:',
                }, function(choice)
                  if choice == 'View PR in browser' then
                    vim.fn.system 'gh pr view --web'
                  end
                end)
              end)
            end)
          end)
        end,
        weight = 3,
      },
      {
        name = 'Git: View/Manage PR',
        execute = function()
          -- Get current branch name
          local current_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')

          -- Check if PR exists for current branch
          local pr_check = vim.fn.system('gh pr view ' .. vim.fn.shellescape(current_branch) .. ' --json url 2>/dev/null')
          if vim.v.shell_error ~= 0 then
            vim.notify('No PR found for current branch: ' .. current_branch, vim.log.levels.WARN)
            return
          end

          local pr_actions = {
            'View PR in browser',
            'View PR details',
            'Check PR status',
            'Merge PR',
            'Close PR',
          }

          vim.ui.select(pr_actions, {
            prompt = 'PR actions for branch: ' .. current_branch,
          }, function(choice)
            if choice == 'View PR in browser' then
              vim.fn.system 'gh pr view --web'
            elseif choice == 'View PR details' then
              local details = vim.fn.system 'gh pr view'
              vim.notify(details, vim.log.levels.INFO)
            elseif choice == 'Check PR status' then
              local status = vim.fn.system 'gh pr checks'
              vim.notify(status, vim.log.levels.INFO)
            elseif choice == 'Merge PR' then
              vim.ui.select({ 'Create merge commit', 'Squash and merge', 'Rebase and merge' }, {
                prompt = 'Merge strategy:',
              }, function(strategy)
                if not strategy then
                  return
                end

                local merge_flag = strategy:match 'Squash' and '--squash' or strategy:match 'Rebase' and '--rebase' or '--merge'

                local result = vim.fn.system('gh pr merge ' .. merge_flag)
                if vim.v.shell_error ~= 0 then
                  vim.notify('Failed to merge PR: ' .. result, vim.log.levels.ERROR)
                else
                  vim.notify('PR merged successfully!', vim.log.levels.INFO)
                end
              end)
            elseif choice == 'Close PR' then
              vim.ui.input({
                prompt = 'Close reason (optional): ',
              }, function(reason)
                local cmd = 'gh pr close'
                if reason and reason ~= '' then
                  cmd = cmd .. ' --comment ' .. vim.fn.shellescape(reason)
                end

                local result = vim.fn.system(cmd)
                if vim.v.shell_error ~= 0 then
                  vim.notify('Failed to close PR: ' .. result, vim.log.levels.ERROR)
                else
                  vim.notify('PR closed successfully!', vim.log.levels.INFO)
                end
              end)
            end
          end)
        end,
        weight = 2,
      },
      {
        name = 'Git: Switch User Profile',
        execute = function()
          -- Your 2 GitHub accounts
          local profiles = {
            'Account 1 (mahmoudabdelhadii)',
            'Account 2 (your-second-account)',
          }

          -- Show current user
          local current_user = vim.fn.system('git config user.name'):gsub('\n', '')
          local current_email = vim.fn.system('git config user.email'):gsub('\n', '')

          vim.ui.select(profiles, {
            prompt = 'Current: ' .. current_user .. ' <' .. current_email .. '>\n\nSwitch to:',
          }, function(choice)
            if not choice then
              return
            end

            local username, email
            if choice:match 'Account 1' then
              username = 'mahmoudabdelhadii'
              email = 'mahmoudashraf960@yahoo.com' -- Update with your actual email
            else
              username = 'mahmoudnft' -- Update with your second account username
              email = 'mahmoud@parallelnft.com' -- Update with your actual email
            end

            -- Ask for scope
            vim.ui.select({ 'This repository only', 'Globally (all repositories)' }, {
              prompt = 'Set scope for ' .. username .. ':',
            }, function(scope_choice)
              if not scope_choice then
                return
              end

              local scope = scope_choice:match 'Globally' and '--global' or ''
              vim.fn.system('git config ' .. scope .. ' user.name ' .. vim.fn.shellescape(username))
              vim.fn.system('git config ' .. scope .. ' user.email ' .. vim.fn.shellescape(email))

              local scope_text = scope_choice:match 'Globally' and 'globally' or 'for this repository'
              vim.notify(string.format('Switched %s to:\n%s <%s>', scope_text, username, email), vim.log.levels.INFO)
            end)
          end)
        end,
        weight = 0,
      },
      {
        name = 'Git: Create Feature Branch',
        execute = function()
          vim.ui.input({
            prompt = 'Feature branch name: ',
            default = 'mahmoud/',
          }, function(branch_name)
            if not branch_name or branch_name == '' then
              vim.notify('Branch name required', vim.log.levels.ERROR)
              return
            end

            -- Create and switch to new branch
            local result = vim.fn.system('git checkout -b ' .. vim.fn.shellescape(branch_name))
            if vim.v.shell_error ~= 0 then
              vim.notify('Failed to create branch: ' .. result, vim.log.levels.ERROR)
              return
            end

            vim.notify('Created and switched to branch: ' .. branch_name, vim.log.levels.INFO)
          end)
        end,
        weight = 1,
      },
      {
        name = 'Git: Switch Branch',
        execute = function()
          -- Get list of branches
          local branches = vim.fn.systemlist 'git branch --format="%(refname:short)"'
          if vim.v.shell_error ~= 0 then
            vim.notify('Failed to get branches', vim.log.levels.ERROR)
            return
          end

          vim.ui.select(branches, {
            prompt = 'Select branch:',
          }, function(choice)
            if choice then
              local result = vim.fn.system('git checkout ' .. vim.fn.shellescape(choice))
              if vim.v.shell_error ~= 0 then
                vim.notify('Failed to switch to branch: ' .. result, vim.log.levels.ERROR)
                return
              end
              vim.notify('Switched to branch: ' .. choice, vim.log.levels.INFO)
            end
          end)
        end,
        weight = 7,
      },
      {
        name = 'Git: Stash Management',
        execute = function()
          local stash_actions = {
            'Stash current changes',
            'List stashes',
            'Apply latest stash',
            'Pop latest stash',
            'Drop latest stash',
          }

          vim.ui.select(stash_actions, {
            prompt = 'Stash action:',
          }, function(choice)
            if choice == 'Stash current changes' then
              vim.ui.input({
                prompt = 'Stash message (optional): ',
              }, function(msg)
                local cmd = msg and msg ~= '' and 'git stash push -m ' .. vim.fn.shellescape(msg) or 'git stash'
                local result = vim.fn.system(cmd)
                vim.notify(result, vim.log.levels.INFO)
              end)
            elseif choice == 'List stashes' then
              local stashes = vim.fn.system 'git stash list'
              vim.notify(stashes, vim.log.levels.INFO)
            elseif choice == 'Apply latest stash' then
              local result = vim.fn.system 'git stash apply'
              vim.notify(result, vim.log.levels.INFO)
            elseif choice == 'Pop latest stash' then
              local result = vim.fn.system 'git stash pop'
              vim.notify(result, vim.log.levels.INFO)
            elseif choice == 'Drop latest stash' then
              local result = vim.fn.system 'git stash drop'
              vim.notify(result, vim.log.levels.INFO)
            end
          end)
        end,
        weight = 6,
      },
      {
        name = 'Git push origin',
        execute = 'Git push origin HEAD',
      },
      {
        name = 'Git commit -m',
        execute = 'Git commit',
      },
      {
        name = 'Git blame',
        execute = 'Gitsigns blame',
      },
      {
        name = 'Git revert/reset hunk',
        execute = 'Gitsigns reset_hunk',
      },
      {
        name = 'Git revert/reset buffer',
        execute = 'Gitsigns reset_buffer',
      },
      {
        name = 'Git stage hunk',
        execute = 'Gitsigns stage_hunk',
      },
      {
        name = 'AI: set provider',
        execute = 'PrtProvider',
      },
      {
        name = 'AI: set model',
        execute = 'PrtModel',
      },
      {
        name = 'AI: new chat',
        execute = 'PrtChatNew',
      },
      {
        name = 'AI: current status',
        execute = 'PrtStatus',
      },
      {
        name = 'Scratch buffer',
        execute = 'lua Snacks.scratch()',
      },
      {
        name = 'Search Commands',
        execute = 'lua Snacks.picker.commands()',
      },
      {
        name = 'Search text no regex',
        execute = 'lua Snacks.picker.grep({regex = false})',
      },
      {
        name = 'Git main (stashout)',
        execute = '!gitStashout main',
      },
      {
        name = 'PR list',
        execute = 'Octo pr list',
      },
      {
        name = 'PR for current branch',
        execute = 'Octo pr show',
      },
      {
        name = 'Format Json',
        execute = "%!jq '.'",
      },
      {
        name = 'New tab',
        execute = 'tabnew',
      },
      -- {
      --   name = 'Print Vim table',
      --   execute = function(v)
      --     print(vim.inspect(v))
      --   end,
      -- },
      -- -- Note variadic arguments need require_input
      -- {
      --   name = 'Print Variadic arguments',
      --   execute = function(...)
      --     local args = { ... }
      --     print(vim.inspect(args))
      --   end,
      --   require_input = true,
      -- },
      {
        name = 'Copy relative path to clipboard',
        execute = function()
          local path = vim.fn.expand '%'
          vim.fn.setreg('+', path)
        end,
        weight = 2,
      },
      {
        name = 'Copy absolute path to clipboard',
        execute = function()
          local path = vim.fn.expand '%:p'
          vim.fn.setreg('+', path)
        end,
      },
      -- {
      --   name = 'Copy Vim table to clipboard',
      --   execute = function(v)
      --     vim.fn.setreg('+', vim.inspect(v))
      --   end,
      --   tags = { 'first' },
      -- },
      -- {
      --   name = 'Reload plugin',
      --   execute = function(name)
      --     package.loaded[name] = nil
      --     require(name).setup()
      --   end,
      --   tags = { 'first', 'second' },
      -- },
    },
  },
  config = true,
}
