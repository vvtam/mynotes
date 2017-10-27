##新增shell##
比如新增fish
add /usr/local/bin/fish to /etc/shells
切换默认shell
chsh -s /usr/local/bin/fish
ssh通过代理
```
brew corkscrew

vim ~/.ssh/config
Host yourhost
ProxyCommand corkscrew 127.0.0.1 1087 %h %p
```

iTerm2 color
https://github.com/mbadolato/iTerm2-Color-Schemes

vim/neovim plugin manager
https://github.com/junegunn/vim-plug
https://github.com/Shougo/dein.vim
