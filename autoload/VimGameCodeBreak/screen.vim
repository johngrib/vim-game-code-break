let s:config = {}
let s:height = 0

function! VimGameCodeBreak#screen#new(config)

    let s:config = a:config
    let s:height = a:config['height']

    let obj = {}
    let obj.scrollToLast = funcref('VimGameCodeBreak#screen#scrollToLast')
    let obj.removeEmptyLines = funcref('VimGameCodeBreak#screen#removeEmptyLines')

    return obj

endfunction

function! VimGameCodeBreak#screen#scrollToLast()
    execute "normal! G0zb"
endfunction

function! VimGameCodeBreak#screen#removeEmptyLines() dict
    call self.scrollToLast()
    if line('$') > s:height
        execute "silent! " . line('w0') . "," . (line('w$') - 5) . "g/^\\s*$/d"
    endif
endfunction
