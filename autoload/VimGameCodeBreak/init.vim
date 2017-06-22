function! VimGameCodeBreak#init#getInitConfig()

    let l:config = {}

    let l:config['width']      = winwidth(0)
    let l:config['height']     = winheight(0)
    let l:config['empty_line'] = repeat(' ', l:config['width'] + 1)

    return l:config

endfunction

function! VimGameCodeBreak#init#createBuffer()

    let l:file_name   = expand('%:t')
    let l:file_ext    = l:file_name[(strridx(l:file_name, '.') + 1):]
    let l:colors_name = g:colors_name
    let l:temp        = getreg('z')

    execute "normal! ggVG\"zy"
    silent edit `='VIM-GAME-CODE-BREAK-' . l:file_name`
    execute "normal! \"zp"
    execute "colorscheme " . l:colors_name

    call setreg('z', l:temp)
    call s:setLocalSetting()

endfunction

function! s:setLocalSetting()
    " echo synIDattr(synIDtrans(hlID('StatusLine')), 'fg')
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
    setlocal norelativenumber
    setlocal listchars=
    setlocal laststatus=2
    setlocal fileencodings=utf-8
    syntax on
    highlight statusLine ctermfg=yellow ctermbg=NONE guifg=yellow guibg=NONE
    retab
endfunction

function! VimGameCodeBreak#init#drawScreen(config)
    execute "normal! Go"
    let l:width = a:config['width']
    let l:last_line = line('$')

    let l:bottom_lines = repeat([repeat(' ', l:width)], 5)
    call setline(l:last_line, l:bottom_lines)

    call s:appendChars(a:config['empty_line'])

    execute "normal! ggO"
    execute "normal! S"
    execute "normal! yy" . a:config['height'] . "pGzb"
endfunction

function! s:appendChars(chars)
    silent! %s/$/\=a:chars/
endfunction
