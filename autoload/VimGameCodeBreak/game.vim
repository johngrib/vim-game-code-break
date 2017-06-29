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
let s:screen = {}
let s:item = []

function! VimGameCodeBreak#game#main()

    let s:common = VimGameCodeBreak#common#new()
    let s:config = s:init()

    let s:screen = VimGameCodeBreak#screen#new(s:config)
    let s:bounce = VimGameCodeBreak#bounce#new(s:config)

    let s:life = VimGameCodeBreak#life#new(5)
    let s:ship = VimGameCodeBreak#ship#new(s:config)
    let s:ball = VimGameCodeBreak#abstractBall#new(s:screen, s:bounce, s:life, s:ship, s:config)

    let s:keyProc = s:initKeys()

    call s:ship.show()
    call s:screen.removeEmptyLines()
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
            break
        endif

        call s:showStatus()

    endwhile

endfunction

function! VimGameCodeBreak#game#addItem(item)
    let s:item += [a:item]
endfunction

function! VimGameCodeBreak#game#getItemList()
    return s:item
endfunction

function! s:showStatus()
    echo "LIFE : " . s:life.get() . "    " . (s:godMode ? "GOD MODE" : "")
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
    let s:ball = VimGameCodeBreak#ball#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let s:ball = s:ball.create(l:x, l:y, s:ship.getDirection())

    call VimGameCodeBreak#game#addItem(s:ball)

endfunction

function! s:updateItems(time)
    call s:ship.move(a:time)
    call s:moveBall(a:time)
endfunction

function! s:moveBall(time)

    for l:item in s:item
        if ! l:item.isReady(a:time)
            continue
        endif

        call l:item.hide()
        call l:item.update()
        call l:item.roll()
        call l:item.show()
    endfor

endfunction


" game initialize
function! s:init()

    call VimGameCodeBreak#compatiblity#init(expand('%'))

    let l:config = VimGameCodeBreak#init#getInitConfig()
    call VimGameCodeBreak#init#createBuffer(l:config)
    call VimGameCodeBreak#init#drawScreen(l:config)

    let l:config['top'] = line("'a") + 1

    return l:config
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
