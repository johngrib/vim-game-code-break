let s:config = {}
let s:screen = {}
let s:bounce = {}
let s:life = {}
let s:ship = {}

function! VimGameCodeBreak#abstractBall#new(screen, bounce, life, ship, config)

    let s:screen = a:screen
    let s:bounce = a:bounce
    let s:life = a:life
    let s:ship = a:ship
    let s:config = a:config

    let l:move = {
            \ 'left' : { 'x' : -1, 'y' : -1 },
            \ 'right': { 'x' : 1 , 'y' : -1 },
            \ 'left-down' : { 'x' : -1, 'y' : 1 },
            \ 'right-down': { 'x' : 1 , 'y' : 1 },
            \ }

    let obj = {
                \'x': -1,
                \'y': -1,
                \'old_x': -1,
                \'old_y': -1,
                \'direction': l:move['left'],
                \'interval': 50,
                \'time_check': 0,
                \'active': 0,
                \'icon': 'O'
                \}

    let obj.common = VimGameCodeBreak#common#new()
    let obj.move = l:move
    let obj.create = funcref('<SID>create')
    let obj.tick = funcref('<SID>tick')
    let obj.tock = funcref('<SID>tock')
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
    let obj.enableGod = funcref('<SID>enableGod')
    let obj.disableGod = funcref('<SID>disableGod')

    return obj
endfunction

function! s:create(x, y, dir) dict
    let l:ball = VimGameCodeBreak#abstractBall#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let l:ball['x'] = a:x
    let l:ball['y'] = a:y
    let l:ball['active'] = 1

    if has_key(self.move, a:dir)
        let l:ball.direction = self.move[a:dir]
    endif

    return l:ball
endfunction

function! s:tick(time) dict
    let self.time_check = self.time_check - a:time
endfunction

function! s:tock() dict
    if self.time_check <= 0
        let self.time_check = self.interval
    endif
endfunction

function! s:isReady() dict
    if ! self.isInitialized()
        return 0
    endif
    return self.time_check <= 0
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
    call self.common.drawChar(self.x, self.y, ' ')
endfunction

function! s:show() dict
    if ! self.active
        return
    endif
    call self.common.drawChar(self.x, self.y, self.icon)
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

let s:pongXcheckList = []

" ball 의 X axis 충돌 처리를 한다
function! s:pongX() dict

    call s:bounce.onBugLine(self)

    if s:bounce.onFloor(self) && s:ship.isCatchSuccess(self.x)
        return self.hitShipEvent()
    endif

    if s:bounce.onFloor(self) && ! s:ship.isCatchSuccess(self.x)
        return self.hitFloorEvent()
    endif

    if s:bounce.onTop(self)
        " 천장에 닿은 경우
        return self.hitTopEvent()
    endif

    if s:bounce.onLimit(self)
        return self.hitLimitEvent()
    endif

    if s:bounce.onCharX(self)
        " 글자에 닿은 경우
        return self.hitCharXEvent()
    endif

    return self.doNothing()
endfunction

" ball 의 Y axis 충돌 처리를 한다
function! s:pongY() dict

    if s:bounce.onWall(self) && s:bounce.inHeight(self)
        return self.hitWallEvent()
    endif

    if s:bounce.onWall(self)
        return self.hitBottomWallEvent()
    endif

    if s:bounce.onCharY(self)
        return self.hitCharYEvent()
    endif

    return self.doNothing()
endfunction

function! s:enableGod() dict
endfunction

function! s:disableGod() dict
endfunction
