-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
-- Usar j y k para moverse en softwrap lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set('i', 'jk', '<ESC>', { noremap = true })
vim.keymap.set('n', 'o', 'o<ESC>', { noremap = true })
vim.keymap.set('n', 'O', 'O<ESC>', { noremap = true })
-- Borrar todo sin yank
vim.keymap.set('n', 'DD', 'gg"_dG', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>rf', ":VimuxRunCommand('python ' . expand('%'))<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rr', ':VimuxRunLastCommand<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sl', ':VimuxSendText<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>sl', ':VimuxSendText<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ri', ':VimuxInterruptRunner<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>to', ':VimuxOpenRunner<CR>:VimuxRunCommand("source .venv/bin/activate")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tc', ':VimuxCloseRunner<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rc', ':VimuxPromptCommand<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rs', ':VimuxResizePane<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cl', ':VimuxClearTerminal<CR>', { noremap = true, silent = true })

return {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'shortcuts/no-neck-pain.nvim' },
  {
    'jpalardy/vim-slime',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = { socket_name = 'default', target_pane = ':.1' }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_cell_delimiter = '# %%'

      vim.g.slime_paste_file = vim.fn.tempname()

      -- Set up key mappings for sending cells
      vim.api.nvim_set_keymap('n', '<leader>sc', ':SlimeSendCell<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>sj', ':SlimeSendCellAndJump<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>sa', ':SlimeSendAllCells<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>sp', '<Plug>SlimeRegionSend', { silent = true })
      vim.api.nvim_set_keymap('x', '<leader>ss', '<Plug>SlimeRegionSend', { silent = true })
      -- Define custom functions for sending cells
      vim.cmd [[
      function! SlimeSendCell()
        if exists("b:slime_cell_delimiter")
          let delimiter = b:slime_cell_delimiter
        elseif exists("g:slime_cell_delimiter")
          let delimiter = g:slime_cell_delimiter
        else
          echoerr "slime_cell_delimiter is undefined"
          return
        endif
        let startpos = search(delimiter, "bcnW")
        let endpos = search(delimiter, "nW")
        if endpos == 0
          let endpos = line("$")
        else
          let endpos = endpos - 1
        endif
        if startpos > 0
          let startpos = startpos + 1
        endif
        call slime#send_range(startpos, endpos)
      endfunction

      function! SlimeSendCellAndJump()
        call SlimeSendCell()
        call search(g:slime_cell_delimiter, "W")
        normal! j
      endfunction

      function! SlimeSendAllCells()
        let current_pos = getpos(".")
        normal! gg
        while 1
          call SlimeSendCell()
          if search(g:slime_cell_delimiter, "W") == 0
            break
          endif
          normal! j
        endwhile
        call setpos(".", current_pos)
      endfunction

      command! -nargs=0 SlimeSendCell call SlimeSendCell()
      command! -nargs=0 SlimeSendCellAndJump call SlimeSendCellAndJump()
      command! -nargs=0 SlimeSendAllCells call SlimeSendAllCells()
    ]]
    end,
  },
  --  { 'hanschen/vim-ipython-cell' },
  {
    'preservim/vimux',
    config = function()
      -- Optional: Configure Vimux settings here
      vim.g.VimuxHeight = '14'
      vim.g.VimuxCloseOnExit = true
    end,
  },

  { 'tenxsoydev/karen-yank.nvim', config = true },
}
