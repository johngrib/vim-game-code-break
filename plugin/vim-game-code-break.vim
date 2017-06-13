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
            \}

function! s:main()

    let s:data['temp'] = getreg('z')
    execute "normal! ggVG\"zy"
    let s:data['text'] = getreg('z')

    call s:init()

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
    " setlocal nonumber
    setlocal norelativenumber
    setlocal listchars=
endfunction

"
function! s:setColor()
    syntax match gameship '\v\<12345654321\>'
    highlight gameship ctermfg=blue ctermbg=blue guifg=blue guibg=blue
endfunction

function! s:drawScreen()
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
    0,$-12g/^\s*$/d
endfunction

function! s:appendChars()
    let l:chars = s:config['empty_line']
    %s/$/\=l:chars/
endfunction

function! s:drawShip()
    execute "normal! Go" . s:ship['body']
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
