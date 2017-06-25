let s:config = {}

function! VimGameCodeBreak#screen#new(config)

    let s:config = a:config

    let obj = {}
    let obj.scrollToLast = function('<SID>scrollToLast')

    return obj

endfunction

function! s:scrollToLast() dict
    execute "normal! G0zb"
endfunction

