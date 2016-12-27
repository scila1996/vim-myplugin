"F9 key -> run script (if has shebang)

set autochdir

function! Set_hotkey()
    if getline(1) =~ "^#!"
        nnoremap <buffer> <F9> :update <bar> !echo -e "\033c"; ./%:p:t <cr>
    endif
endfunction

autocmd FileType * call Set_hotkey()

