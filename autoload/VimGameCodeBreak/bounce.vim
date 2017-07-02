
let s:config = {}
let s:topLine = 0
let s:common = {}

function! VimGameCodeBreak#bounce#new(config)

    let s:common = VimGameCodeBreak#common#new()
    let s:config = a:config

    let obj = {}
    let obj.onFloor = funcref('<SID>onFloor')
    let obj.onTop = funcref('<SID>onTop')
    let obj.onCharX = funcref('<SID>onCharX')
    let obj.onCharY = funcref('<SID>onCharY')
    let obj.onWall = funcref('<SID>onWall')
    let obj.inHeight = funcref('<SID>inHeight')
    let obj.onLimit = funcref('<SID>onLimit')
    let obj.onBugLine = funcref('<SID>onBugLine')

    return obj
endfunction

function! s:onFloor(ball)
    return a:ball.y >= line('$')
endfunction

function! s:onTop(ball)
    return a:ball.y <= (line('$') - s:config['height'] + 1)
endfunction

function! s:onCharX(ball)
    return s:common.getCharValue(a:ball.x, a:ball.futureY()) !~ '\s'
endfunction

function! s:onCharY(ball)
    return s:common.getCharValue(a:ball.futureX(), a:ball.y) !~ '\s'
endfunction

function! s:onWall(ball)
    let l:xx = a:ball.futureX()
    return ((l:xx <= 0) || (l:xx >= s:config['width']))
endfunction

function! s:inHeight(ball)
    return (a:ball.futureY() - 1 >= 1) && (a:ball.y < line('$') - 5)
endfunction

function! s:onLimit(ball)
    return a:ball.y < line('w0')
endfunction

function! s:onBugLine(ball)
    let l:y = a:ball.futureY()
    let l:len = len(getline(l:y))
    if l:y > line("'a") && l:y <= line('$') && l:len < s:config['width'] - 10
        execute "" . l:y . "delete"
    endif
    return 0
endfunction
