"F9 key -> run script (if has shebang)

python << EOF

import os
import vim

def Run_script():
    cur_dir = vim.eval('expand("%:p:h")')
    cur_file = vim.eval('expand("%:p:t")')
    os.chdir(cur_dir)
    vim.command('!echo -e "\033c"; ./{:s}'.format(cur_file))
EOF

function! Set_hotkey()
    if getline(1) =~ "^#!"
        nnoremap <buffer> <F9> :update <bar> python Run_script() <cr>
    endif
endfunction

autocmd FileType * call Set_hotkey()

