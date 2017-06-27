let s:config = {}

function! VimGameCodeBreak#screen#new(config)

    let s:config = a:config

    let obj = {}
    let obj.scrollToLast = funcref('VimGameCodeBreak#screen#scrollToLast')

    return obj

endfunction

function! VimGameCodeBreak#screen#scrollToLast()
    execute "normal! G0zb"
endfunction

