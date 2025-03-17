vim.cmd [[
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
]]

-- Install parrot
require('parrot').setup({
  toggle_target = 'tabnew',
  providers = {
    anthropic = {
      api_key = os.getenv 'ANTHROPIC_API_KEY'
    }
  }
})

vim.cmd [[
  " In visual mode, <leader>pp should :PrtChatPaste
  " In normal mode, <leader>pp should :PrtChatToggle
  vnoremap <leader>pp :PrtChatPaste<CR>
  nnoremap <leader>pp :PrtChatToggle<CR>
  nnoremap <leader>po :PrtChatFinder<CR>
  nnoremap <leader>p<CR> :PrtChatRespond<CR>
  nnoremap <leader>pt :PrtThinking<CR>
  nnoremap <leader>pn :PrtChatNew<CR>
  nnoremap <leader>pd :PrtChatDelete<CR>
]]
