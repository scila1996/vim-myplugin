function! Cpp_compiler(option)
    cd %:p:h
    let file_name = expand('%:p:t')
    let obj_file = expand('%:p:t:r') . '.o'
    let org_file = expand('%:p:t:r')
    let msg_success = 'BUILD SUCCESSFULLY'
    let build_tool = &filetype == 'c' ? 'gcc' : 'g++'
    let run = ''
    let f = 1
    if a:option != 1
        if !isdirectory('build')
            call mkdir('build', 'p')
        endif
        silent exec '!rm -rf build/' . org_file . '*'
        redraw!
        let run = build_tool . ' -c "' . file_name . '" -o "build/' . obj_file . '" && ' . build_tool . ' "' . 'build/' . obj_file . '" -o "build/' . org_file . '";'
        if a:option == 0
            let run .= 'if [ $? -eq 0 ]; then echo -e "\033[1;92m ' . msg_success . ' \033[0m"; fi;'
        endif
    endif
    if a:option == 1
        if isdirectory('build')
            cd build
            if filereadable(org_file)
                let run = 'echo -e "\033c"; ./' . org_file
            else
                let f = 0
                call Cpp_error_not_exe()
            endif
        else
            let f = 0
            call Cpp_error_not_exe()
        endif
    elseif a:option == 2
        let run .= 'if [ $? -eq 0 ]; then cd build; "./' . org_file . '"; fi;'
    endif
    if f
        exec '!echo -e "\033c";' . run
    endif
endfunction

function! Cpp_error_not_exe()
    echo 'Not exist file to execute'
endfunction

nnoremap <buffer> <F7> :update <bar> call Cpp_compiler(0) <cr>
nnoremap <buffer> <F5> :update <bar> call Cpp_compiler(1) <cr>
nnoremap <buffer> <F9> :update <bar> call Cpp_compiler(2) <cr>
