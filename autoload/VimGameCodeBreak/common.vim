function! VimGameCodeBreak#common#new()

    let obj = {}

    let obj.rand = funcref('<SID>rand')
    let obj.drawChar = funcref('<SID>drawChar')
    let obj.getCharValue = funcref('<SID>getCharValue')
    let obj.removeWord = funcref('<SID>removeWord')
    let obj.sleep = funcref('<SID>sleep')

    return obj
endfunction

" https://vi.stackexchange.com/questions/3832/why-doesnt-vimscript-provide-a-random-number-generator
function! s:rand(max)
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

function! s:drawChar(x, y, char)
    let l:row = getline(a:y)
    let l:newRow = l:row[0:(a:x - 1)] . a:char . l:row[(a:x + 1):]
    call setline(a:y, l:newRow)
endfunction

function! s:getCharValue(x, y)
    return getline(a:y)[a:x]
endfunction

function! s:removeWord(x, y)
    call cursor(a:y, a:x)
    let l:word = expand('<cWORD>')
    execute "normal! vaWr "
    return l:word
endfunction

function s:sleep(time)
    execute "sleep " . a:time . "ms"
endfunction

