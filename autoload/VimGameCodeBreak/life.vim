let s:life = 5
let s:game_over = 0

function! VimGameCodeBreak#life#new()

    let l:obj = {}
    let l:obj['set'] = funcref('<SID>set')
    let l:obj['get'] = funcref('<SID>get')
    let l:obj['decrease'] = funcref('<SID>decrease')
    let l:obj['increase'] = funcref('<SID>increase')
    let l:obj['isGameOver'] = funcref('<SID>isGameOver')

    return l:obj
endfunction

function! s:set(life)
    let s:life = a:life
    return s:life
endfunction

function! s:get()
    return s:life
endfunction

function! s:decrease()
    let s:life = s:life - 1
    return s:life
endfunction

function! s:increase()
    let s:life = s:life + 1
    return s:life
endfunction

function! s:isGameOver()
    return (s:life <= s:game_over)
endfunction
