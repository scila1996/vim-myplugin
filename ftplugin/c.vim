python << EOF

import vim
import os

def C_run(flag = 0):
    build_path = "build"
    current_file = vim.eval('expand("%:p:t")')
    current_file_split = os.path.splitext(current_file)
    current_path = vim.eval('expand("%:p:h")')
    os.chdir(current_path)
    compiler = ''
    run = 'cd {:s}; ./{:s}'.format(build_path, current_file_split[0])
    ex_command = '!echo -e "\033c";'
    if flag:
        if not os.path.isdir(build_path):
            os.mkdir(build_path)
        compiler = 'gcc -o {:s}/{:s} {:s}'.format(build_path, current_file_split[0], current_file)
        ex_command += '{:s};'.format(compiler)
    if flag == 2 or not flag:
        ex_command += 'if [ $? -eq 0 ]; then {:s}; fi;'.format(run)
    else:
        ex_command += 'if [ $? -eq 0 ]; then echo -e "{:s}"; fi;'.format('\033[1;92m BUILD SUCCESSFULLY \033[0m')
    vim.command(ex_command)
EOF

nnoremap <buffer> <F5> :update <bar> python C_run() <cr>
nnoremap <buffer> <F7> :update <bar> python C_run(1) <cr>
nnoremap <buffer> <F9> :update <bar> python C_run(2) <cr>

