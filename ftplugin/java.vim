python << EOF
import os
import re
import vim

def Package(f):
    for line in f:
        r = re.search('(^\s*package\s+)(.+(?=;$))', line)
        if r:
            return r.group(2)
    return False

def Java_run(flag = 0):
    os.chdir(vim.eval('expand("%:p:h")'))
    bp = 'build/classes'
    currentfile = vim.eval('expand("%:p:t")')
    currentclass = vim.eval('expand("%:p:t:r")')
    listfile = [currentfile]
    package = Package(vim.current.buffer)
    compiler = ''
    run = 'java -cp {:s} {:s}'.format(bp, currentclass)
    ex_command = '!echo -e "\033c";'
    if flag:
        if package:
            run = 'java -cp {:s} {:s}.{:s}'.format(bp, package, currentclass)
            for f in os.listdir('.'):
                if os.path.isfile(f) and os.path.splitext(f)[1] == '.java' and not f == currentfile:
                    with open(f) as fj:
                        if Package(fj) == package:
                            listfile.append(f)
        compiler = 'javac -d {:s} {:s}'.format(bp, ' '.join(listfile))
        if not os.path.isdir(bp):
            os.makedirs(bp)
    if compiler:
        ex_command += '{:s};'.format(compiler)
        if flag == 2:
            ex_command += 'if [ $? -eq 0 ]; then {:s}; fi;'.format(run)
        else:
            ex_command += 'if [ $? -eq 0 ]; then echo -e "\033[1;92m BUILD SUCCESSFULLY \033[0m"; fi;'
    else:
        ex_command += '{:s};'.format(run)
    vim.command(ex_command)
EOF

nnoremap <buffer> <F5> :update <bar> python Java_run() <cr>
nnoremap <buffer> <F7> :update <bar> python Java_run(1) <cr>
nnoremap <buffer> <F9> :update <bar> python Java_run(2) <cr>

