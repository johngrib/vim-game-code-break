let s:ship = {}
let s:config = {}

function! VimGameCodeBreak#ship#init(config)

    let s:config = a:config
    let s:ship = {}

    let s:ship['size']      = 17
    let s:ship['body']      = repeat('X', s:ship['size'])
    let s:ship['center']    = float2nr(ceil(s:ship['size'] / 2))
    let s:ship['left']      = ''
    let s:ship['direction'] = 'left'

    return s:ship
endfunction

function! VimGameCodeBreak#ship#show()
    setlocal statusline=%!VimGameCodeBreak#ship#get()
endfunction

function! VimGameCodeBreak#ship#get()
    return s:ship['left'] . s:ship['body']
endfunction

function! VimGameCodeBreak#ship#setLeft()
    let s:ship['direction'] = 'left'
endfunction

function! VimGameCodeBreak#ship#setRight()
    let s:ship['direction'] = 'right'
endfunction

function! VimGameCodeBreak#ship#move()

    if (s:ship['direction'] == 'left')
        call s:moveShipLeft()
    elseif (s:ship['direction'] == 'right')
        call s:moveShipRight()
    endif

endfunction

function! s:moveShipLeft()
    if s:ship['left'][0] == " "
        let s:ship['left'] = s:ship['left'][1:]
        call VimGameCodeBreak#ship#show()
    endif
endfunction

function! s:moveShipRight()
    if (s:bodySize() + s:leftSize()) < s:config['width']
        let s:ship['left'] = " " . s:ship['left']
        call VimGameCodeBreak#ship#show()
    endif
endfunction

function! VimGameCodeBreak#ship#isCatchFailed(x)

    let l:left_size = s:leftSize()

    return (a:x < l:left_size) || (a:x > (l:left_size + s:bodySize()))
endfunction

function! s:leftSize()
    return strlen(s:ship['left'])
endfunction

function! s:bodySize()
    return strlen(s:ship['body'])
endfunction
