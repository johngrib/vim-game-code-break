" .'
nnoremap <Leader>g :VimGameCodeBreak<CR>
command! VimGameCodeBreak :call s:main()

let s:config = {
            \ 'width': 0,
            \ 'empty_line': '',
            \}
let s:data = {
            \ 'text': '',
            \ 'temp': '',
            \}
let s:ship = {
            \'left' : { 'x': 0, 'y': 0 },
            \'right' : { 'x': 0, 'y': 0 },
            \'body' : '<12345654321>',
            \'direction' : 'left'
            \}
let s:ball = {}

function! s:main()

    let s:data['temp'] = getreg('z')
    execute "normal! ggVG\"zy"
    let s:data['text'] = getreg('z')

    call s:init()

    execute "normal! G"

    let l:loop = 1
    while l:loop == 1
        let l:input = nr2char(getchar(0))
        call s:updateDirection(l:input)
        call s:updateItems()
        sleep 30ms
        redraw
    endwhile

endfunction

function! s:updateDirection(input)
    if a:input == 'h'
        let s:ship['direction'] = 'left'
    elseif a:input == 'l'
        let s:ship['direction'] = 'right'
    endif
endfunction

function! s:updateItems()
    if (s:ship['direction'] == 'left') && (s:getCharValue(0, line('$')) != '<')
        call s:moveShipLeft()
    elseif (s:ship['direction'] == 'right') && (s:getCharValue(s:config['width'], line('$')) != '>')
        call s:moveShipRight()
    endif
endfunction

function! s:getCharValue(x, y)
    return getline(a:y)[a:x]
endfunction

function! s:moveShipLeft()
    execute "normal! G0x"
endfunction

function! s:moveShipRight()
    execute "normal! G0i "
endfunction

" game initialize
function! s:init()

    let l:file_name = expand('%:t')

    call s:createBuffer(l:file_name)
    call s:setLocalSetting()
    call s:setConfig()
    call s:setColor()
    call s:drawScreen()
    call s:drawShip()

endfunction

function! s:createBuffer(filename)
    silent edit `='VIM-GAME-CODE-BREAK-' . a:filename`
    execute "normal! \"zp"
    call setreg('z', s:data['temp'])
endfunction

function! s:setLocalSetting()
    setlocal bufhidden=wipe
    setlocal buftype=nofile
    setlocal buftype=nowrite
    setlocal nocursorcolumn
    setlocal nocursorline
    setlocal nolist
    setlocal nonumber
    setlocal noswapfile
    setlocal nowrap
    setlocal nohlsearch
    " setlocal nonumber
    setlocal norelativenumber
    setlocal listchars=
endfunction

"
function! s:setColor()
    syntax region gameship start="\v\<12" end="\v21\>"
    highlight gameship ctermfg=yellow ctermbg=yellow guifg=yellow guibg=yellow
endfunction

function! s:drawScreen()
    execute "normal! Go"
    let l:width = s:config['width']
    let l:last_line = line('$')

    let s:ship['left']['y'] = l:last_line
    let s:ship['right']['y'] = l:last_line

    let l:lines = repeat([repeat(' ', l:width)], 5)

    call setline(l:last_line, l:lines)

    call s:appendChars()
    call s:removeEmptyLines()
endfunction

function! s:removeEmptyLines()
    silent! 0,$-12g/^\s*$/d
endfunction

function! s:appendChars()
    let l:chars = s:config['empty_line']
    silent! %s/$/\=l:chars/
endfunction

function! s:drawShip()
    execute "normal! Go"
    execute "normal! Go"
    execute "normal! I" . s:ship['body']
endfunction

function! s:setConfig()
    let s:config['width'] = winwidth(0)

    let l:width = s:config['width']
    let l:chars = ''

    for cnt in range(1, l:width)
        let l:chars = l:chars . ' '
    endfor

    let s:config['empty_line'] = l:chars
endfunction

