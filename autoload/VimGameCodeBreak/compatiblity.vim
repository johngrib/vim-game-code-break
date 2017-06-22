
let s:data = {}

function! VimGameCodeBreak#compatiblity#init(file_name)

    let s:data['file_name'] = a:file_name
    let s:data['file_ext'] = a:file_name[(strridx(a:file_name, '.') + 1):]

    " youcompleteme
    if exists('g:ycm_auto_trigger')
        let s:data['ycm_auto_trigger'] = get(g:, 'ycm_auto_trigger', 0)
        let g:ycm_auto_trigger = 0

        let s:data['ycm_filetype_blacklist'] = get(g:, 'ycm_filetype_blacklist', {})
        let g:ycm_filetype_blacklist = get(g:, 'ycm_filetype_blacklist', {})
        let g:ycm_filetype_blacklist[s:data['file_ext']] = 1
    endif

    return s:data
endfunction

function! VimGameCodeBreak#compatiblity#quit()

    if exists('g:ycm_auto_trigger')
        let g:ycm_auto_trigger = s:data['ycm_auto_trigger']
        let g:ycm_filetype_blacklist[s:data['file_ext']] = s:data['ycm_filetype_blacklist'][s:data['file_ext']]
    endif

endfunction

