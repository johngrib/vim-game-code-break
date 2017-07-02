let s:config = {}
let s:screen = {}
let s:bounce = {}
let s:life = {}
let s:ship = {}

function! VimGameCodeBreak#item_bomb#new(screen, bounce, life, ship, config)

    let s:screen = a:screen
    let s:bounce = a:bounce
    let s:life = a:life
    let s:ship = a:ship
    let s:config = a:config

    let l:obj = VimGameCodeBreak#abstractBall#new(a:screen, a:bounce, a:life, a:ship, a:config)
    let l:obj = deepcopy(obj)

    let l:obj.icon = 'O'
    let l:obj.interval = 40
    let l:obj.hitCount = 10
    let l:obj.create = funcref('<SID>create')
    let l:obj.hitWallEvent = funcref('<SID>hitWallEvent')
    let l:obj.hitCharYEvent = funcref('<SID>hitCharYEvent')
    let l:obj.hitCharXEvent = funcref('<SID>hitCharXEvent')
    let l:obj.hitBottomWallEvent = funcref('<SID>hitBottomWallEvent')
    let l:obj.hitShipEvent = funcref('<SID>hitShipEvent')
    let l:obj.hitFloorEvent = funcref('<SID>hitFloorEvent')
    let l:obj.hitTopEvent = funcref('<SID>hitTopEvent')

    return l:obj

endfunction

function! s:create(x, y, dir) dict
    let l:item = VimGameCodeBreak#item_bomb#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let l:item['x'] = a:x
    let l:item['y'] = a:y
    let l:item['active'] = 1
    let l:item.direction = { 'x': 0, 'y': 1 }

    return l:item
endfunction

function! s:hitWallEvent() dict
endfunction

function! s:hitCharYEvent() dict
endfunction

function! s:hitCharXEvent() dict
    if self.hitCount < 1
        call self.kill()
    endif

    let self.hitCount -= 1

    if self.futureY() < line('$')
        let l:word = self.common.removeWord(self.x, self.futureY())
        call s:screen.scrollToLast()
    endif
    call self.reverseY()
endfunction

function! s:hitBottomWallEvent() dict
endfunction

function! s:hitShipEvent() dict
    call self.reverseY()
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

