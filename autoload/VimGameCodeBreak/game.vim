let s:config = {}
let s:ship = {}
let s:ball_proto = { 'x': 0, 'y': 0, 'active': 0 }
let s:life = {}

let s:move = {
            \ 'left-up'    : { 'x' : -1, 'y' : -1 },
            \ 'left-down'  : { 'x' : -1, 'y' :  1 },
            \ 'right-up'   : { 'x' : 1 , 'y' : -1 },
            \ 'right-down' : { 'x' : 1 , 'y' :  1 },
            \ 'up'         : { 'x' : 0 , 'y' : -1 },
            \ 'down'       : { 'x' : 0 , 'y' :  1 },
            \ }

let s:ball = {}
let s:common = {}
let s:interval = 5
let s:keyProc = {}
let s:godMode = 0

function! VimGameCodeBreak#game#main()

    let s:common = VimGameCodeBreak#common#new()
    let s:config = s:init()
    let s:screen = VimGameCodeBreak#screen#new(s:config)
    let s:life = VimGameCodeBreak#life#new()
    let s:ball = VimGameCodeBreak#ball#new()
    let s:keyProc = s:initKeys()
    let s:bounce = VimGameCodeBreak#bounce#new(s:config)

    call s:life.set(5)

    call s:removeEmptyLines()
    call s:screen.scrollToLast()

    let s:loop = 1
    while s:loop == 1
        let l:input = nr2char(getchar(0))

        call s:userInputProc(l:input)

        call s:updateItems(s:interval)

        call s:common.sleep(s:interval)

        redraw

        if s:life.isGameOver()
            echo 'GAME OVER'
            let s:loop = -1
        else
            echo "LIFE : " . s:life.get() . "    " . (s:godMode ? "GOD MODE" : "")
        endif
    endwhile

endfunction

function! s:initKeys()
    let key = {}
    let key['h'] = s:ship.setLeft
    let key['l'] = s:ship.setRight
    let key[' '] = funcref('<SID>createNewBall')
    let key['`'] = funcref(s:life.set, [99999])
    let key[']'] = funcref('<SID>enableGodMode')
    let key['['] = funcref('<SID>disableGodMode')

    function key.q()
        call s:quit()
        call VimGameCodeBreak#compatiblity#quit()
    endfunction

    return key

endfunction

function! s:userInputProc(input)
    if has_key(s:keyProc, a:input)
        call s:keyProc[a:input]()
    endif
endfunction

function! s:createNewBall()
    if s:ball.active
        return
    endif
    let l:y = line('$') - 1
    let l:x = s:ship.getCenter()
    let s:ball = s:ball.create(l:x, l:y, s:ship.getDirection())

endfunction

function! s:updateItems(time)
    call s:ship.move(a:time)
    call s:moveBall(a:time)
endfunction

function! s:moveBall(time)

    if ! s:ball.isReady(a:time)
        return
    endif

    call s:ball.hide()

    let l:x = s:ball['x']
    let l:y = s:ball['y']

    if s:pongX(l:x, l:y)
        call s:ball.reverseY()
    endif

    if s:pongY(l:x, l:y)
        call s:ball.reverseX()
    endif

    call s:ball.roll()
    call s:ball.show()

endfunction

" ball 의 X axis 충돌 처리를 한다
function! s:pongX(x, y)

    let l:last = line('$')
    let l:xx = s:ball.futureX()
    let l:yy = s:ball.futureY()

    if s:bounce.onFloor(s:ball)
        if s:ship.isCatchFailed(a:x) && !s:godMode
            " 바닥에 닿은 경우
            call s:life.decrease()
            call s:ball.kill()
            return 1
        endif
        return 1
    endif

    if s:bounce.onTop(s:ball)
        " 천장에 닿은 경우
        call s:removeEmptyLines()
        call s:screen.scrollToLast()
        return 1
    endif

    if s:bounce.onCharX(s:ball)
        " 글자에 닿은 경우
        if l:yy < line('$')
            call s:common.removeWord(a:x, l:yy)
            call s:screen.scrollToLast()
        endif
        return 1
    endif

    if s:bounce.onLimit(s:ball)
        return 1
    endif

    return 0
endfunction

" ball 의 Y axis 충돌 처리를 한다
function! s:pongY(x, y)

    let l:last = s:config['width']
    let l:xx = s:ball.futureX()
    let l:yy = s:ball.futureY()

    if s:bounce.onWall(s:ball)
        if s:bounce.inHeight(s:ball)
            let l:row = substitute(getline(a:y - 1), '\s*$', ' ', '')
            call setline(a:y - 1, l:row)
            execute "" . (a:y - 1) . "j"
            let l:botrow = substitute(getline(a:y - 1), '$', s:config['empty_line'], '')
            call setline(a:y - 1, l:botrow)
            call s:screen.scrollToLast()
        endif
        return 1
    endif

    if s:bounce.onCharY(s:ball)
        call s:common.removeWord(l:xx, a:y)
        call s:screen.scrollToLast()
        return 1
    endif

    " if a:x >= l:last
    "     return 1
    " endif
    return 0
endfunction

" game initialize
function! s:init()

    call VimGameCodeBreak#compatiblity#init(expand('%'))

    let l:config = VimGameCodeBreak#init#getInitConfig()
    call VimGameCodeBreak#init#createBuffer(l:config)
    call VimGameCodeBreak#init#drawScreen(l:config)

    let l:config['top'] = line("'a")

    let s:ship = VimGameCodeBreak#ship#new(l:config)

    call s:ship.show()

    return l:config
endfunction

function! s:removeEmptyLines()
    call s:screen.scrollToLast()
    if line('$') > s:config['height']
        execute "silent! " . line('w0') . "," . (line('w$') - 5) . "g/^\\s*$/d"
    endif
endfunction

function! s:quit()
    let s:loop = -1
endfunction

function! s:enableGodMode()
    let s:godMode = 1
endfunction

function! s:disableGodMode()
    let s:godMode = 0
endfunction
