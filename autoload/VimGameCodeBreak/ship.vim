let s:ship = {}
let s:config = {}
let s:body = ''
let s:left = ''

function! VimGameCodeBreak#ship#new(config)

    let s:config = a:config
    let l:size   = 17
    let s:body   = repeat('X', l:size)
    let s:left   = ''

    let s:ship = {}

    let s:ship['show']     = funcref('<SID>show')
    let s:ship['setLeft']  = funcref('<SID>setLeft')
    let s:ship['setRight'] = funcref('<SID>setRight')

    let s:ship['move']      = funcref('<SID>moveShipLeft')
    let s:ship['moveLeft']  = funcref('<SID>moveShipLeft')
    let s:ship['moveRight'] = funcref('<SID>moveShipRight')

    let s:ship['getCenter'] = funcref('<SID>getCenter')
    let s:ship['isCatchFailed'] = funcref('<SID>isCatchFailed')

    let s:ship['interval']   = 30
    let s:ship['time_check'] = 0

    return s:ship
endfunction

function! VimGameCodeBreak#ship#get()
    return s:left . s:body
endfunction

function! s:show()
    setlocal statusline=%!VimGameCodeBreak#ship#get()
endfunction

function! s:setLeft()
    let s:ship['move'] = s:ship['moveLeft']
endfunction

function! s:setRight()
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

function! s:isCatchFailed(x)
    let l:left_size = s:leftSize()
    return (a:x < l:left_size) || (a:x > (l:left_size + s:bodySize()))
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
