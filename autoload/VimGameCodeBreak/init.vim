function! VimGameCodeBreak#init#getInitConfig()

    let l:config = {}

    let l:config['width']      = winwidth(0)
    let l:config['height']     = winheight(0)
    let l:config['empty_line'] = repeat(' ', l:config['width'])

    return l:config

endfunction

