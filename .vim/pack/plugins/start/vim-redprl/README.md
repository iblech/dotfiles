# redprl.vim

This vim plugin requires Vim 8 (released September 2016).

## Use

While editing a .prl file, run `:RedPRL` or `<LocalLeader>l` (`l` for `load`)
in the command (normal) mode to check the current buffer and display the output
in a separate buffer.

If there are any syntax errors, the cursor will jump to the first one.

## Setup

Move this directory to `~/.vim/pack/foo/start/vim-redprl`. (The names `foo` and
`vim-redprl` don't matter.)

If `redprl` is not in your `PATH`, add the following line to your `.vimrc`:

    let g:redprl_path = '/path/to/redprl'

If you want to enable printing traces, add the following line to your `.vimrc`:

    let g:redprl_trace = 1

If you want to recheck the current buffer with another key combination, add the
following line to your `.vimrc`, replacing `<F5>` as appropriate:

    au FileType redprl nnoremap <F5> :RedPRL<CR>
