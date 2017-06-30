let s:life = 5
let s:game_over = 0

function! VimGameCodeBreak#life#new(life)

    let s:life = a:life
    let l:obj = {}
    let l:prefix = 'VimGameCodeBreak#life#'
    let l:obj['set'] = funcref(l:prefix . 'set')
    let l:obj['get'] = funcref(l:prefix . 'get')
    let l:obj['decrease'] = funcref(l:prefix . 'decrease')
    let l:obj['increase'] = funcref(l:prefix . 'increase')
    let l:obj['isGameOver'] = funcref(l:prefix . 'isGameOver')

    return l:obj
endfunction

function! VimGameCodeBreak#life#set(life)
    let s:life = a:life
    return s:life
endfunction

function! VimGameCodeBreak#life#get()
    return s:life
endfunction

function! VimGameCodeBreak#life#decrease()
    let s:life = s:life - 1
    return s:life
endfunction

function! VimGameCodeBreak#life#increase()
    let s:life = s:life + 1
    return s:life
endfunction

function! VimGameCodeBreak#life#isGameOver()
    return (s:life <= s:game_over)
endfunction
