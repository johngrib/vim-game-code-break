scriptencoding utf-8

function! VimGameCodeBreak#init#getInitConfig()

    let l:config = {}

    let l:config['width']      = 80
    let l:config['height']     = winheight(0)
    let l:config['empty_line'] = repeat(' ', l:config['width'] + 1)

    return l:config

endfunction

function! VimGameCodeBreak#init#createBuffer(config)

    vs
    let l:file_name   = expand('%:t')
    let l:file_ext    = l:file_name[(strridx(l:file_name, '.') + 1):]
    if has_key(g:, 'colors_name')
        let l:colors_name = g:colors_name
    endif

    let l:textList = getbufline('%', 1, '$')

    silent edit `='VIM-GAME-CODE-BREAK-' . l:file_name`
    vertical resize 80

    call setline(1, l:textList)

    %g/^\s*$/d

    let l:textList = getbufline('%', 1, '$')

    if has_key(l:, 'colors_name')
        execute "colorscheme " . l:colors_name
    endif

    call s:setLocalSetting(a:config)

endfunction

function! s:setLocalSetting(config)
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
    setlocal signcolumn=no
    setlocal regexpengine=1
    setlocal lazyredraw
    setlocal nofoldenable
    syntax on
    " execute "setlocal synmaxcol=" . (a:config['width'] - 1)
    highlight statusLine ctermfg=yellow ctermbg=NONE guifg=yellow guibg=NONE

    " Hides/restores cursor at the start/end of the game
    augroup vim_game_code_break
        execute "autocmd BufLeave <buffer> set t_ve=" . &t_ve
        execute "autocmd VimLeave <buffer> set t_ve=" . &t_ve
    augroup END
    setlocal t_ve=

    retab
endfunction

function! VimGameCodeBreak#init#drawScreen(config)

    silent! g/^\s*$/delete
    call setpos("'a", [0, 1, 0])

    let l:bottom_lines = repeat([repeat(' ', a:config['width'])], 10)
    call append(line('$'), l:bottom_lines)

    call s:appendChars(a:config['empty_line'])

    call append(0, repeat([''], a:config['height']))

    call setpos("'b", [0, line('$') - a:config['height'] * 2, 0])

    let l:fullText = getline(1, line('$'))
    execute "silent! 1,'b-1s/./ /g"

    return l:fullText
endfunction

function! s:appendChars(chars)
    silent! %s/$/\=a:chars/
endfunction

