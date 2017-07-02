let s:config = {}
let s:screen = {}
let s:bounce = {}
let s:life = {}
let s:ship = {}

function! VimGameCodeBreak#item_manager#new(screen, bounce, life, ship, config)
    let s:screen = a:screen
    let s:bounce = a:bounce
    let s:life = a:life
    let s:ship = a:ship
    let s:config = a:config

    let l:obj = {}
    let l:obj.common = VimGameCodeBreak#common#new()
    let l:obj.getRandomItem = funcref('<SID>getRandomItem')


    let l:life_item = VimGameCodeBreak#item_life#new(s:screen, s:bounce, s:life, s:ship, s:config)
    let l:ship_item = VimGameCodeBreak#item_large_ship#new(s:screen, s:bounce, s:life, s:ship, s:config)

    let l:obj.item = []
    call add(l:obj.item, l:life_item)
    call add(l:obj.item, l:ship_item)

    return l:obj

endfunction

function! s:getRandomItem(x, y, dir) dict
    let l:size = len(self.item)
    let l:item = self.item[self.common.rand(l:size)]
    return l:item.create(a:x, a:y, a:dir)
endfunction
