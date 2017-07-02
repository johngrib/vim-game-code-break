let s:config = {}
let s:screen = {}
let s:bounce = {}
let s:life = {}
let s:ship = {}

function! VimGameCodeBreak#ball#new(screen, bounce, life, ship, config)

    let s:screen = a:screen
    let s:bounce = a:bounce
    let s:life = a:life
    let s:ship = a:ship
    let s:config = a:config

    let obj = VimGameCodeBreak#abstractBall#new(a:screen, a:bounce, a:life, a:ship, a:config)

    let obj.icon = 'O'
    let obj.itemRate = 50
    let obj.create = funcref('<SID>create')
    let obj.hitWallEvent = funcref('<SID>hitWallEvent')
    let obj.hitCharYEvent = funcref('<SID>hitCharYEvent')
    let obj.hitCharXEvent = funcref('<SID>hitCharXEvent')
    let obj.hitBottomWallEvent = funcref('<SID>hitBottomWallEvent')
    let obj.hitShipEvent = funcref('<SID>hitShipEvent')
    let obj.hitFloorEvent = funcref('<SID>hitFloorEvent')
    let obj.hitTopEvent = funcref('<SID>hitTopEvent')
    let obj.enableGod = funcref('<SID>enableGod')
    let obj.disableGod = funcref('<SID>disableGod')

    return obj

endfunction

function! s:create(x, y, dir) dict
    let l:ball = VimGameCodeBreak#ball#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let l:ball['x'] = a:x
    let l:ball['y'] = a:y
    let l:ball['active'] = 1

    if has_key(self.move, a:dir)
        let l:ball.direction = self.move[a:dir]
    endif

    return l:ball
endfunction

function! s:hitWallEvent() dict

    let l:before = line('$')
    call s:screen.lineJoin(self.y - 1)
    let l:after = line('$')

    call self.common.prepareLine(l:before - l:after, s:config['fullText'])

    call s:screen.scrollToLast()
    call self.reverseX()
endfunction

function! s:hitCharYEvent() dict
    call self.common.removeWord(self.futureX(), self.y)
    call s:screen.scrollToLast()
    call self.reverseX()
endfunction

function! s:hitCharXEvent() dict
    if self.futureY() < line('$')
        let l:word = self.common.removeWord(self.x, self.futureY())

        if self.common.rand(self.itemRate) < strlen(l:word)
            call VimGameCodeBreak#game#createNewItem(self.x, self.y, 'right-down')
        endif

        call s:screen.scrollToLast()
    endif
    call self.reverseY()
endfunction

function! s:hitBottomWallEvent() dict
    call self.reverseX()
endfunction

function! s:hitShipEvent() dict
    call self.reverseY()
endfunction

function! s:hitFloorEvent() dict
    call s:life.decrease()
    call self.kill()
    call s:ship.reset()
    call self.reverseY()
endfunction

function! s:hitTopEvent() dict
    let l:before = line('$')
    call s:screen.removeEmptyLinesLimit(VimGameCodeBreak#game#getBallMaxY())
    let l:after = line('$')
    call self.common.prepareLine(l:before - l:after, s:config['fullText'])
    call s:screen.scrollToLast()
    call self.reverseY()
endfunction

function! s:hitLimitEvent() dict
    call self.reverseY()
endfunction

function! s:enableGod() dict
    let self.hitFloorEvent = self.hitShipEvent
endfunction

function! s:disableGod() dict
    let self.hitFloorEvent = funcref('<SID>hitFloorEvent')
endfunction
