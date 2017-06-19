let s:life = 5
let s:game_over = 0

function! VimGameCodeBreak#life#decrease()
    let s:life = s:life - 1
    return s:life
endfunction

function! VimGameCodeBreak#life#increase()
    let s:life = s:life + 1
endfunction

function! VimGameCodeBreak#life#get()
    return s:life
endfunction

function! VimGameCodeBreak#life#set(life)
    let s:life = a:life
endfunction

function! VimGameCodeBreak#life#isGameOver()
    return (s:life <= s:game_over)
endfunction
