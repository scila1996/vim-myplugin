"F9 key -> run script (if has shebang)

function! Run_script()
    cd expand('%:p:h')
    !echo -e "\033c"; ./%:p:t
endfunction

function! Set_hotkey()
    if getline(1) =~ "^#!"
        nnoremap <buffer> <F9> :update <bar> call Run_script() <cr>
    endif
endfunction

autocmd FileType * call Set_hotkey()

