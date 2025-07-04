return {
  -- lets you do things like :Git fetch, etc
  'tpope/vim-fugitive', -- Git flow tool
  config = function()
    -- Git branch and publish workflow
    vim.api.nvim_create_user_command('PublishWork', function(opts)
      local branch_name = opts.args
      if branch_name == '' then
        vim.notify('Please provide a branch name: :PublishWork <branch-name>', vim.log.levels.ERROR)
        return
      end
      
      -- Check if there are changes to commit
      local status_output = vim.fn.system('git status --porcelain')
      if status_output == '' then
        vim.notify('No changes to publish', vim.log.levels.WARN)
        return
      end
      
      -- Create and switch to new branch
      local create_branch = vim.fn.system('git checkout -b ' .. vim.fn.shellescape(branch_name))
      if vim.v.shell_error ~= 0 then
        vim.notify('Failed to create branch: ' .. create_branch, vim.log.levels.ERROR)
        return
      end
      
      -- Add all changes
      vim.fn.system('git add .')
      
      -- Commit changes
      local commit_msg = 'Work in progress: ' .. branch_name
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
    end, { nargs = 1 })

    vim.keymap.set('n', '<leader>gp', ':PublishWork ', { desc = '[G]it [P]ublish work to new branch' })
  end
}
