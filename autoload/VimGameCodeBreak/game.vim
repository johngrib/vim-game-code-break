let s:config = {}
let s:ship = {}
let s:ball_proto = { 'x': 0, 'y': 0, 'active': 0 }
let s:life = {}
let s:fullText = []

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
let s:interval = 50
let s:keyProc = {}
let s:godMode = 0
let s:screen = {}
let s:item = []
let s:itemTemp = []

function! VimGameCodeBreak#game#main()

    let s:common = VimGameCodeBreak#common#new()
    let s:config = s:init()

    let s:screen = VimGameCodeBreak#screen#new(s:config)
    let s:bounce = VimGameCodeBreak#bounce#new(s:config)

    let s:life = VimGameCodeBreak#life#new(5)
    let s:ship = VimGameCodeBreak#ship#new(s:config)
    let s:ball = VimGameCodeBreak#abstractBall#new(s:screen, s:bounce, s:life, s:ship, s:config)

    let s:itemMan = VimGameCodeBreak#item_manager#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let s:life_item = VimGameCodeBreak#item_life#new(s:screen, s:bounce, s:life, s:ship, s:config)

    let s:keyProc = s:initKeys()

    call s:ship.show()
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

function! VimGameCodeBreak#game#createNewItem(x, y, dir)
    let l:item = s:itemMan.getRandomItem(a:x, a:y, a:dir)
    call VimGameCodeBreak#game#addItem(l:item)
endfunction

function! VimGameCodeBreak#game#addItem(item)
    let s:itemTemp += [a:item]
endfunction

function! VimGameCodeBreak#game#getItemList()
    return s:item
endfunction

function! VimGameCodeBreak#game#getBallCount()
    let l:count = 0
    for l:item in s:item
        if l:item.icon == 'O' && l:item.active
            let l:count += 1
        endif
    endfor
    return l:count
endfunction

function! VimGameCodeBreak#game#getBallMaxY()
    let l:y = -1
    for l:item in s:item
        if l:item.icon == 'O' && l:item.active && l:item.y > l:y
            let l:y = l:item.y
        endif
    endfor
    return l:y
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
    for l:item in s:item
        if l:item.active
            return
        endif
    endfor
    let l:y = line('$') - 1
    let l:x = s:ship.getCenter()
    let s:ball = VimGameCodeBreak#ball#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let s:ball = s:ball.create(l:x, l:y, s:ship.getDirection())

    call VimGameCodeBreak#game#addItem(s:ball)

endfunction

function! s:updateItems(time)

    if len(s:itemTemp) > 0
        call filter(s:item, {ids, val -> val.active })
        if len(s:item) < 2
            let s:item += s:itemTemp
        endif
        let s:itemTemp = []
    endif

    call s:ship.move(a:time)
    call s:moveBall(a:time)
endfunction

function! s:moveBall(time)

    for l:item in s:item
        call l:item.tick(a:time)
        call l:item.hide()
    endfor

    for l:item in s:item
        if l:item.isReady()
            call l:item.update()
            call l:item.roll()
        endif
    endfor

    for l:item in s:item
        call l:item.show()
        call l:item.tock()
    endfor

endfunction


" game initialize
function! s:init()

    call VimGameCodeBreak#compatiblity#init(expand('%'))

    let l:config = VimGameCodeBreak#init#getInitConfig()
    call VimGameCodeBreak#init#createBuffer(l:config)
    let l:fullText = VimGameCodeBreak#init#drawScreen(l:config)

    let l:config['top'] = line("'a") - 1
    let l:config['fullText'] = l:fullText

    return l:config
endfunction

function! s:quit()
    let s:loop = -1
endfunction

function! s:enableGodMode()
    let s:godMode = 1
    for l:item in s:item
        call l:item.enableGod()
    endfor
endfunction

function! s:disableGodMode()
    let s:godMode = 0
    for l:item in s:item
        call l:item.disableGod()
    endfor
endfunction
