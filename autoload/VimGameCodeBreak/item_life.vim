let s:config = {}
let s:screen = {}
let s:bounce = {}
let s:life = {}
let s:ship = {}

function! VimGameCodeBreak#item_life#new(screen, bounce, life, ship, config)

    let s:screen = a:screen
    let s:bounce = a:bounce
    let s:life = a:life
    let s:ship = a:ship
    let s:config = a:config

    let obj = VimGameCodeBreak#abstractBall#new(a:screen, a:bounce, a:life, a:ship, a:config)

    let obj.icon = 'L'
    let obj.interval = 10
    let obj.create = funcref('<SID>create')
    let obj.hitWallEvent = funcref('<SID>hitWallEvent')
    let obj.hitCharYEvent = funcref('<SID>hitCharYEvent')
    let obj.hitCharXEvent = funcref('<SID>hitCharXEvent')
    let obj.hitBottomWallEvent = funcref('<SID>hitBottomWallEvent')
    let obj.hitShipEvent = funcref('<SID>hitShipEvent')
    let obj.hitFloorEvent = funcref('<SID>hitFloorEvent')
    let obj.hitTopEvent = funcref('<SID>hitTopEvent')

    return obj

endfunction

function! s:create(x, y, dir) dict
    let l:item = VimGameCodeBreak#item_life#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let l:item['x'] = a:x
    let l:item['y'] = a:y
    let l:item['active'] = 1

    if has_key(self.move, a:dir)
        let l:item.direction = self.move[a:dir]
    endif

    return l:item
endfunction

function! s:hitWallEvent() dict
    call s:screen.lineJoin(self.y - 1)
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
        call self.common.removeWord(self.x, self.futureY())
        call s:screen.scrollToLast()
    endif
    call self.reverseY()
endfunction

function! s:hitBottomWallEvent() dict
    call self.reverseX()
endfunction

function! s:hitShipEvent() dict
    call s:life.increase()
    call self.kill()
endfunction

function! s:hitFloorEvent() dict
    call self.kill()
endfunction

function! s:hitTopEvent() dict
    call self.reverseY()
endfunction

function! s:hitLimitEvent() dict
    call self.reverseY()
endfunction
