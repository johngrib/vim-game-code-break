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

let s:ball = {'x': -1, 'y':-1, 'direction': s:move['left-up'], 'interval': 40, 'time_check': 0}

let s:interval = 5

function! VimGameCodeBreak#game#main()

    let s:life = VimGameCodeBreak#life#new()

    call s:init()

    call s:life.set(5)

    call s:removeEmptyLines()
    execute "normal! G0zb"

    let s:loop = 1
    while s:loop == 1
        let l:input = nr2char(getchar(0))

        call s:userInputProc(l:input)

        call s:updateItems(s:interval)

        call s:sleep(s:interval)

        redraw

        if s:life.isGameOver()
            echo 'GAME OVER'
            let s:loop = -1
        else
            echo "LIFE : " . s:life.get()
        endif
    endwhile

endfunction

function s:sleep(time)
    execute "sleep " . a:time . "ms"
endfunction

function! s:userInputProc(input)
    if a:input == 'h'
        call s:ship.setLeft()
    elseif a:input == 'l'
        call s:ship.setRight()
    elseif a:input == ' '
        call s:createNewBall()
    elseif a:input == 'q'
        call s:quit()
        call VimGameCodeBreak#compatiblity#quit()
    elseif a:input =='`'
        call s:life.set(99999)
    endif
endfunction

function! s:createNewBall()
    let l:y = line('$') - 1
    let l:x = s:ship.getCenter()
    let s:ball['x'] = l:x
    let s:ball['y'] = l:y
endfunction

function! s:updateItems(time)
    call s:ship.move(a:time)
    call s:moveBall(a:time)
endfunction

function! s:moveBall(time)

    let s:ball['time_check'] = s:ball['time_check'] - a:time
    if s:ball['time_check'] > 0
        return
    endif

    if s:ball['time_check'] <= 0
        let s:ball['time_check'] = s:ball['interval']
    endif

    if s:ball['x'] == -1 || s:ball['y'] == -1
        return
    endif

    let l:x = s:ball['x']
    let l:y = s:ball['y']
    call s:drawChar(l:x, l:y, ' ')

    if s:pongX(l:x, l:y) == 1
        let s:ball['direction']['y'] = -1 * (s:ball['direction']['y'])
    endif

    if s:pongY(l:x, l:y) == 1
        let s:ball['direction']['x'] = -1 * (s:ball['direction']['x'])
    endif

    let s:ball['x'] = l:x + s:ball['direction']['x']
    let s:ball['y'] = l:y + s:ball['direction']['y']

    call s:drawChar(s:ball['x'], s:ball['y'], 'O')

endfunction

" ball 의 X axis 충돌 처리를 한다
function! s:pongX(x, y)

    let l:last = line('$')
    let l:xx = a:x + s:ball['direction']['x']
    let l:yy = a:y + s:ball['direction']['y']

    if a:y >= l:last
        if s:ship.isCatchFailed(a:x)
            " 바닥에 닿은 경우
            call s:life.decrease()
        endif
        return 1
    endif

    if a:y <= (l:last - s:config['height'])
        " 천장에 닿은 경우
        call s:removeEmptyLines()
        execute "normal! G0zb"
        return 1
    endif

    if s:getCharValue(a:x, l:yy) !~ '\s'
        " 글자에 닿은 경우
        if l:yy < line('$')
            call s:removeWord(a:x, l:yy)
        endif
        return 1
    endif

    return 0
endfunction

" ball 의 Y axis 충돌 처리를 한다
function! s:pongY(x, y)

    let l:last = s:config['width']
    let l:xx = a:x + s:ball['direction']['x']
    let l:yy = a:y + s:ball['direction']['y']

    if ((l:xx <= 0) || (l:xx >= l:last)) && (l:yy - 1 >= 1) && (a:y < line('$-5'))
        " 좌우 벽에 닿은 경우: line join
        let l:row = substitute(getline(a:y - 1), '\s*$', ' ', '')
        call setline(a:y - 1, l:row)
        execute "" . (a:y - 1) . "j"
        let l:botrow = substitute(getline(a:y - 1), '$', s:config['empty_line'], '')
        call setline(a:y - 1, l:botrow)
        execute "normal! G0zb"
        return 1
    endif

    if s:getCharValue(l:xx, a:y) !~ '\s'
        " 글자에 닿은 경우
        call s:removeWord(l:xx, a:y)
        return 1
    endif

    if a:x >= l:last
        return 1
    endif
    return 0
endfunction

function! s:removeWord(x, y)
    call cursor(a:y, a:x)
    execute "normal! vaWr "
    execute "normal! G0zb"
endfunction


function! s:getCharValue(x, y)
    return getline(a:y)[a:x]
endfunction


" game initialize
function! s:init()

    call VimGameCodeBreak#compatiblity#init(expand('%'))

    call VimGameCodeBreak#init#createBuffer()

    let s:config = VimGameCodeBreak#init#getInitConfig()

    call VimGameCodeBreak#init#drawScreen(s:config)

    let s:ship = VimGameCodeBreak#ship#new(s:config)

    call s:ship.show()

endfunction

function! s:removeEmptyLines()
    execute "silent! $-" . s:config['height'] . ",$-5g/^\\s*$/d"
endfunction


function! s:drawChar(x, y, char)
    let l:row = getline(a:y)
    let l:newRow = l:row[0:(a:x - 1)] . a:char . l:row[(a:x + 1):]
    call setline(a:y, l:newRow)
endfunction

function! s:quit()
    let s:loop = -1
endfunction
