let s:config = {}
let s:ship = {
            \'center' : { 'x': 0, 'y': 0 },
            \'left' : '',
            \'body' : 'XXXXXXXXXXXXXXXXX',
            \'direction' : 'left',
            \'location': 0,
            \}
let s:ball_proto = { 'x': 0, 'y': 0, 'active': 0 }

let s:move = {
            \ 'left-up'    : { 'x' : -1, 'y' : -1 },
            \ 'left-down'  : { 'x' : -1, 'y' :  1 },
            \ 'right-up'   : { 'x' : 1 , 'y' : -1 },
            \ 'right-down' : { 'x' : 1 , 'y' :  1 },
            \ 'up'         : { 'x' : 0 , 'y' : -1 },
            \ 'down'       : { 'x' : 0 , 'y' :  1 },
            \ }

let s:ball = {'x': -1, 'y':-1, 'direction': s:move['left-up']}

function! VimGameCodeBreak#game#main()


    call s:init()

    execute "normal! G0zb"

    let s:loop = 1
    while s:loop == 1
        let l:input = nr2char(getchar(0))
        call s:userInputProc(l:input)
        call s:updateItems()

        if VimGameCodeBreak#life#isGameOver()
            echo 'GAME OVER'
            let s:loop = -1
        endif

        echo "LIFE : " . VimGameCodeBreak#life#get()

        sleep 30ms
        redraw
    endwhile

endfunction

function! s:userInputProc(input)
    if a:input == 'h'
        let s:ship['direction'] = 'left'
    elseif a:input == 'l'
        let s:ship['direction'] = 'right'
    elseif a:input == ' '
        call s:createNewBall()
    endif
endfunction

function! s:createNewBall()
    let l:y = line('$') - 1
    let l:x = s:ship['center']['x']
    let s:ball['x'] = l:x
    let s:ball['y'] = l:y
endfunction

function! s:updateItems()
    if (s:ship['direction'] == 'left')
        call s:moveShipLeft()
    elseif (s:ship['direction'] == 'right')
        call s:moveShipRight()
    endif
    call s:moveBall()
endfunction

function! s:moveBall()

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
    let l:yy = a:y + s:ball['direction']['y']

    if l:yy >= l:last + 1
        let l:left_size = strlen(s:ship['left'])
        if a:x < l:left_size || a:x > (l:left_size + strlen(s:ship['body']))
            " 바닥에 닿은 경우
            call VimGameCodeBreak#life#decrease()
        endif
        return 1
    endif

    if a:y <= (l:last - s:config['height'])
        " 천장에 닿은 경우
        return 1
    endif

    if s:getCharValue(a:x, l:yy) != ' '
        " 글자에 닿은 경우
        if l:yy < line('$')
            execute "normal! " . l:yy . "gg0" . a:x . "lviWr G0"
        endif
        return 1
    endif

    return 0
endfunction

" ball 의 Y axis 충돌 처리를 한다
function! s:pongY(x, y)

    let l:xx = a:x + s:ball['direction']['x']
    let l:last = s:config['width']

    if ((l:xx <= 0) || (a:x >= l:last)) && (a:y - 1 >= 1)
        " 좌우 벽에 닿은 경우: line join
        let l:row = substitute(getline(a:y - 1), '\s*$', ' ', '')
        call setline(a:y - 1, l:row)
        execute "" . (a:y - 1) . "j"
        let l:botrow = substitute(getline(a:y - 1), '$', s:config['empty_line'], '')
        call setline(a:y - 1, l:botrow)
        execute "normal! G0zb"
        return 1
    endif

    if s:getCharValue(l:xx, a:y) != ' '
        " 글자에 닿은 경우
        execute "normal! " . a:y . "gg0" . l:xx . "lviWr G0zb"
        return 1
    endif

    if a:x >= l:last
        return 1
    endif
    return 0
endfunction

function! s:getCharValue(x, y)
    return getline(a:y)[a:x]
endfunction

function! s:moveShipLeft()
    if s:ship['left'][0] == " "
        let s:ship['left'] = s:ship['left'][1:]
        setlocal statusline=%!VimGameCodeBreak#game#showShip()
    endif
endfunction

function! s:moveShipRight()
    if (strlen(s:ship['body']) + strlen(s:ship['left'])) < s:config['width']
        let s:ship['left'] = " " . s:ship['left']
        setlocal statusline=%!VimGameCodeBreak#game#showShip()
    endif
endfunction

" game initialize
function! s:init()

    call VimGameCodeBreak#init#createBuffer()

    let s:config = VimGameCodeBreak#init#getInitConfig()

    call VimGameCodeBreak#init#drawScreen(s:config)

    call VimGameCodeBreak#life#set(5)

    setlocal statusline=%!VimGameCodeBreak#game#showShip()

endfunction


function! VimGameCodeBreak#game#showShip()
    return s:ship['left'] . s:ship['body']
endfunction

function! s:removeEmptyLines()
    silent! 0,$-10g/^\s*$/d
endfunction


function! s:drawChar(x, y, char)
    let l:row = getline(a:y)
    let l:newRow = l:row[0:(a:x - 1)] . a:char . l:row[(a:x + 1):]
    call setline(a:y, l:newRow)
endfunction
