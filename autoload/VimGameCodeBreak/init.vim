function! VimGameCodeBreak#init#getInitConfig()

    let l:config = {}

    let l:config['width']      = winwidth(0)
    let l:config['height']     = winheight(0)
    let l:config['empty_line'] = repeat(' ', l:config['width'])

    return l:config

endfunction

function! VimGameCodeBreak#init#createBuffer()

    let l:file_name   = expand('%:t')
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
    highlight statusLine ctermfg=yellow ctermbg=NONE guifg=yellow guibg=NONE
    retab
endfunction
