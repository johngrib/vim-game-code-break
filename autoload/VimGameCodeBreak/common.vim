function! VimGameCodeBreak#common#new()

    let obj = {}

    let obj.rand = funcref('<SID>rand')
    let obj.drawChar = funcref('<SID>drawChar')
    let obj.getCharValue = funcref('<SID>getCharValue')
    let obj.removeWord = funcref('<SID>removeWord')
    let obj.sleep = funcref('<SID>sleep')
    let obj.prepareLine = funcref('<SID>prepareLine')

    return obj
endfunction

" https://vi.stackexchange.com/questions/3832/why-doesnt-vimscript-provide-a-random-number-generator
function! s:rand(max)
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

function! s:drawChar(x, y, char)

    let l:row = getline(a:y)
    let l:str = l:row[:(a:x - 1)]

    if len(l:str) == strdisplaywidth(l:str)
        let l:newRow = l:str . a:char . l:row[(a:x + 1):]
        call setline(a:y, l:newRow)
        return
    endif

    if a:y < 1 || a:y > line('$') || a:x > winwidth(0) - 1
        return
    endif
    call cursor(a:y, 0)
    execute "normal! " . a:x . "|"
    execute "normal! gr" . a:char
    normal! 0
endfunction

function! s:getCharValue(x, y)
    let l:row = getline(a:y)
    let l:str = l:row[:(a:x - 1)]
    if len(l:str) == strdisplaywidth(l:str)
        return l:row[a:x]
    endif

    if a:y < 1 || a:y > line('$') || a:x > winwidth(0) - 1
        return
    endif
    call cursor(a:y, 0)
    execute "normal! " . a:x . "|"
    let l:char = matchstr(getline('.'), '\%' . col('.') . 'c.')
    normal! 0
    return l:char
endfunction

function! s:removeWord(x, y)
    if a:y < 1 || a:y > line('$') || a:x > winwidth(0) - 1
        return
    endif
    if len(getline(a:y)) < 1
        return
    endif
    call cursor(a:y, 0)
    execute "normal! " . a:x . "|"

    let l:word = expand('<cWORD>')
    execute "normal! vaWgr "
    return l:word
endfunction

function! s:sleep(time)
    execute "sleep " . a:time . "ms"
endfunction

function! s:prepareLine(count, fullText)

    let l:line = line("'b") - a:count
    if l:line <= 0
        return
    endif

    let l:start = l:line - 1
    let l:end = l:start + a:count

    call setline(l:line, a:fullText[(l:start):(l:end)])

    call setpos("'b", [0, l:line, 0])

endfunction
