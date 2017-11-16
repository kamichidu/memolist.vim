let s:save_cpo= &cpo
set cpo&vim

let s:define= {
\   'name': 'memolist',
\}

function! s:define.init(context) abort
    let files= split(globpath(a:context.path, '*'), '\r\?\n')
    return filter(files, "!isdirectory(v:val)")
endfunction

function! s:define.accept(context, str) abort
    call milqi#exit()

    execute 'edit' a:str
endfunction

function! s:define.get_abbr(context, str) abort
    let filename= fnamemodify(a:str, ':t')
    let abbr= get(a:context, filename, '')
    if abbr !=# ''
        return abbr
    endif
    let lines= readfile(a:str, 0, 1)
    if !empty(lines)
        let a:context[filename]= filename . ' | ' . lines[0]
    else
        let a:context[filename]= filename . ' | '
    endif
    return a:context[filename]
endfunction

function! memolist#milqi#list(directory) abort
    call milqi#candidate_first(s:define, {
    \   'path': a:directory,
    \})
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
