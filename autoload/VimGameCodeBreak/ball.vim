let s:move = {
            \ 'left' : { 'x' : -1, 'y' : -1 },
            \ 'right': { 'x' : 1 , 'y' : -1 },
            \ }
let s:common = {}

function! VimGameCodeBreak#ball#new()

    let s:common = VimGameCodeBreak#common#new()
    let obj = {
                \'x': -1,
                \'y': -1,
                \'old_x': -1,
                \'old_y': -1,
                \'direction': s:move['left'],
                \'interval': 40,
                \'time_check': 0,
                \'active': 0
                \}

    let obj.create = funcref('<SID>create')
    let obj.tick = funcref('<SID>tick')
    let obj.isReady = funcref('<SID>isReady')
    let obj.isInitialized = funcref('<SID>isInitialized')
    let obj.roll = funcref('<SID>roll')
    let obj.hide = funcref('<SID>hide')
    let obj.show = funcref('<SID>show')
    let obj.kill = funcref('<SID>kill')
    let obj.reverseX = funcref('<SID>reverseX')
    let obj.reverseY = funcref('<SID>reverseY')
    let obj.futureX = funcref('<SID>futureX')
    let obj.futureY = funcref('<SID>futureY')

    return obj
endfunction

function! s:create(x, y, dir)
    let l:ball = VimGameCodeBreak#ball#new()
    let l:ball['x'] = a:x
    let l:ball['y'] = a:y
    let l:ball['active'] = 1

    if has_key(s:move, a:dir)
        let l:ball.direction = s:move[a:dir]
    endif

    return l:ball
endfunction

function! s:tick(time) dict
    let self.time_check = self.time_check - a:time
endfunction

function! s:isReady(time) dict
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

function! s:isInitialized() dict
    return self.x != -1 && self.y != -1
endfunction

function! s:roll() dict
    if ! self.active
        return
    endif
    let self.old_x = self.x
    let self.old_y = self.y
    let self.x = self.x + self.direction.x
    let self.y = self.y + self.direction.y
endfunction

function! s:hide() dict
    call s:common.drawChar(self.x, self.y, ' ')
endfunction

function! s:show() dict
    if ! self.active
        return
    endif
    call s:common.drawChar(self.x, self.y, 'O')
endfunction

function! s:reverseX() dict
    let self.direction.x = -1 * self.direction.x
endfunction

function! s:reverseY() dict
    let self.direction.y = -1 * self.direction.y
endfunction

function! s:futureX() dict
    return self.x + self.direction.x
endfunction

function! s:futureY() dict
    return self.y + self.direction.y
endfunction

function! s:kill() dict
    let self.active = 0
    let self.x = -1
    let self.y = -1
endfunction

