let s:ship = {}
let s:config = {}
let s:body = ''
let s:left = ''
let s:size = 17

function! VimGameCodeBreak#ship#new(config)

    let s:config = a:config
    let s:size   = 17
    let s:body   = repeat('X', s:size)
    let s:left   = ''

    let s:ship = {}

    let s:ship['show']     = funcref('<SID>show')
    let s:ship['setLeft']  = funcref('<SID>setLeft')
    let s:ship['setRight'] = funcref('<SID>setRight')

    let s:ship['direction'] = 'left'
    let s:ship['move']      = funcref('<SID>moveShipLeft')
    let s:ship['moveLeft']  = funcref('<SID>moveShipLeft')
    let s:ship['moveRight'] = funcref('<SID>moveShipRight')

    let s:ship['getCenter'] = funcref('<SID>getCenter')
    let s:ship['isCatchSuccess'] = funcref('<SID>isCatchSuccess')
    let s:ship['getDirection'] = funcref('<SID>getDirection')

    let s:ship['interval']   = 50
    let s:ship['time_check'] = 0
    let s:ship['increase'] = funcref('VimGameCodeBreak#ship#increase')
    let s:ship['decrease'] = funcref('VimGameCodeBreak#ship#decrease')
    let s:ship['reset'] = funcref('VimGameCodeBreak#ship#reset')
    let s:ship['decrease_time_interval'] = 10000
    let s:ship['decrease_time_check'] = 10000

    return s:ship
endfunction

function! VimGameCodeBreak#ship#get()
    return s:left . s:body
endfunction

function! VimGameCodeBreak#ship#increase()
    if len(s:body) > 30
        return
    endif
    let s:body = s:body . 'XXX'
endfunction

function! VimGameCodeBreak#ship#reset()
    let s:body = repeat('X', s:size)
endfunction

function! VimGameCodeBreak#ship#decrease()
    if len(s:body) <= s:size
        return
    endif
    let s:body = s:body[1:]
endfunction

function! s:show()
    setlocal statusline=%!VimGameCodeBreak#ship#get()
endfunction

function! s:setLeft()
    let s:ship['direction'] = 'left'
    let s:ship['move'] = s:ship['moveLeft']
endfunction

function! s:setRight()
    let s:ship['direction'] = 'right'
    let s:ship['move'] = s:ship['moveRight']
endfunction

function! s:timeCheck(time)
    let s:ship['time_check'] = s:ship['time_check'] - a:time
    if s:ship['time_check'] > 0
        return 0
    endif

    if s:ship['time_check'] <= 0
        let s:ship['time_check'] = s:ship['interval']
    endif

    return 1
endfunction

function! s:moveShipLeft(time)

    if s:timeCheck(a:time) == 0
        return
    endif

    if s:left[0] == " "
        let s:left = s:left[1:]
        call s:show()
    endif
endfunction

function! s:moveShipRight(time)

    if s:timeCheck(a:time) == 0
        return
    endif

    if (s:bodySize() + s:leftSize()) < s:config['width']
        let s:left = " " . s:left
        call s:show()
    endif
endfunction

function! s:isCatchSuccess(x)
    let l:left_size = s:leftSize()
    return (a:x >= l:left_size) && (a:x <= (l:left_size + s:bodySize()))
endfunction

function! s:leftSize()
    return strlen(s:left)
endfunction

function! s:bodySize()
    return strlen(s:body)
endfunction

function! s:getCenter()
    return s:leftSize() + (s:bodySize() / 2)
endfunction

function! s:getDirection()
    return s:ship.direction
endfunction
