"F9 key -> run script (if has shebang)

function! Run_Script()
    cd %:p:h
    exec '!echo -e "\033c"; ./%:p:t'
endfunction

function! Set_Hotkey()
    if getline(1) =~ "^#!"
        nnoremap <buffer> <F9> :update <bar> call Run_Script() <cr>
    endif
endfunction

autocmd FileType * call Set_Hotkey()
