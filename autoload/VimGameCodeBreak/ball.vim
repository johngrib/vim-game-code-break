let s:move = {
            \ 'left-up'    : { 'x' : -1, 'y' : -1 },
            \ 'left-down'  : { 'x' : -1, 'y' :  1 },
            \ 'right-up'   : { 'x' : 1 , 'y' : -1 },
            \ 'right-down' : { 'x' : 1 , 'y' :  1 },
            \ 'up'         : { 'x' : 0 , 'y' : -1 },
            \ 'down'       : { 'x' : 0 , 'y' :  1 },
            \ }

function! VimGameCodeBreak#ball#new()

    let obj = {
                \'x': -1,
                \'y': -1,
                \'old_x': -1,
                \'old_y': -1,
                \'direction': s:move['left-up'],
                \'interval': 40,
                \'time_check': 0
                \}

    function! obj.create(x, y)
        let l:ball = VimGameCodeBreak#ball#new()
        let l:ball['x'] = a:x
        let l:ball['y'] = a:y
        return l:ball
    endfunction

    function! obj.tick(time)
        let self.time_check = self.time_check - a:time
    endfunction

    function! obj.isReady(time)

        if ! self.isInitialized()
            return 0
        endif

        call self.tick(a:time)

        if self.time_check <= 0
            let self.time_check = self.interval
            return 1
        endif

        return 0
    endfunction

    function! obj.isInitialized()
        return self.x != -1 && self.y != -1
    endfunction

    function! obj.roll()
        let self.old_x = self.x
        let self.old_y = self.y
        let self.x = self.x + self.direction.x
        let self.y = self.y + self.direction.y
    endfunction

    function! obj.hide()
        call s:drawChar(self.x, self.y, ' ')
    endfunction

    function! obj.show()
        call s:drawChar(self.x, self.y, 'O')
    endfunction

    function! obj.reverseX()
        let self.direction.x = -1 * self.direction.x
    endfunction

    function! obj.reverseY()
        let self.direction.y = -1 * self.direction.y
    endfunction

    function! obj.futureX()
        return self.x + self.direction.x
    endfunction

    function! obj.futureY()
        return self.y + self.direction.y
    endfunction

    return obj
endfunction

function! s:drawChar(x, y, char)
    let l:row = getline(a:y)
    let l:newRow = l:row[0:(a:x - 1)] . a:char . l:row[(a:x + 1):]
    call setline(a:y, l:newRow)
endfunction
