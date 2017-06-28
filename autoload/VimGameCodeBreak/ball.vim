let s:move = {
            \ 'left' : { 'x' : -1, 'y' : -1 },
            \ 'right': { 'x' : 1 , 'y' : -1 },
            \ }
let s:common = {}
let s:config = {}
let s:screen = {}
let s:bounce = {}
let s:life = {}
let s:ship = {}

function! VimGameCodeBreak#ball#new(screen, bounce, life, ship, config)

    let s:common = VimGameCodeBreak#common#new()
    let s:screen = a:screen
    let s:bounce = a:bounce
    let s:life = a:life
    let s:ship = a:ship
    let s:config = a:config

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

    let obj.update = funcref('<SID>update')
    let obj.pongX = funcref('<SID>pongX')
    let obj.pongY = funcref('<SID>pongY')
    let obj.doNothing = funcref('<SID>doNothing')

    return obj
endfunction

function! s:create(x, y, dir)
    let l:ball = VimGameCodeBreak#ball#new(s:screen, s:bounce, s:life, s:ship, s:config)
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

function! s:doNothing() dict
endfunction

function! s:update() dict
    call self.pongX()
    call self.pongY()
    return self
endfunction

" ball 의 X axis 충돌 처리를 한다
function! s:pongX() dict

    let l:last = line('$')
    let l:xx = self.futureX()
    let l:yy = self.futureY()

    if s:bounce.onFloor(self)
        if s:ship.isCatchFailed(self.x)
            " 바닥에 닿은 경우
            call s:life.decrease()
            call self.kill()
        endif
        return self.reverseY()
    endif

    if s:bounce.onTop(self)
        " 천장에 닿은 경우
        call s:screen.removeEmptyLines()
        call s:screen.scrollToLast()
        return self.reverseY()
    endif

    if s:bounce.onCharX(self)
        " 글자에 닿은 경우
        if l:yy < line('$')
            call s:common.removeWord(self.x, l:yy)
            call s:screen.scrollToLast()
        endif
        return self.reverseY()
    endif

    if s:bounce.onLimit(self)
        return self.reverseY()
    endif

    return self.doNothing()
endfunction

" ball 의 Y axis 충돌 처리를 한다
function! s:pongY() dict

    let l:xx = self.futureX()
    let l:yy = self.futureY()

    if s:bounce.onWall(self)
        if s:bounce.inHeight(self)
            let l:row = substitute(getline(self.y - 1), '\s*$', ' ', '')
            call setline(self.y - 1, l:row)
            execute "" . (self.y - 1) . "j"
            let l:botrow = substitute(getline(self.y - 1), '$', s:config['empty_line'], '')
            call setline(self.y - 1, l:botrow)
            call s:screen.scrollToLast()
        endif
        return self.reverseX()
    endif

    if s:bounce.onCharY(self)
        call s:common.removeWord(l:xx, self.y)
        call s:screen.scrollToLast()
        return self.reverseX()
    endif

    return self.doNothing()
endfunction

