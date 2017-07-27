
# VimGameCodeBreak

![animated demonstration](https://user-images.githubusercontent.com/1855714/27774457-7e001646-5fcd-11e7-9e90-c37eafefad9c.gif)

## How to play

1. open your code or text file in Vim
1. `:VimGameCodeBreak` to Start

h   | l   | space    | `         | ]        | [          | q    | Q
--- | --- | ---      | ---       | ---      | ---        | ---  | ---
←   | →   | new ball | cheat key | GOD mode | human mode | end game | quit & close game

## Setting

If you want to play with more than three balls, you can modify the following:

```viml
" .vimrc
let g:vim_game_code_break_item_limit = 4    " default value is 2
```

> WARNING: Too many balls can slow down the game or cause bugs.
> I recommend the default value : 2
> If the game speed is too slow, try `:syntax off` before starting the game.

## Installation

### VimPlug

Place this in your .vimrc:

> Plug 'johngrib/vim-game-code-break'

Then run the following in Vim:

> :source %

> :PlugInstall


