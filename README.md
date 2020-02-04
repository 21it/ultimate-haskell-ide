# Ultimate Haskell IDE

<img src="logo.png" alt="logo" width="350"/>

# Features

- Syntax highlighting

- Auto-completion

- Auto-formatting

- Auto-refactoring

- Jump to definition

- Compiler suggestions

- Embedded Hoogle docs

# Installation

### With Nix

```nix
import (fetchTarball "https://github.com/tim2CF/vimrc/tarball/master") {}
```

### Without Nix (not recommended)

```bash
git clone --depth=1 https://github.com/tim2CF/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
```

# Usage

```bash
vi .
```

# Useful commands

This IDE is based on normal Vim. It should support all the most standard Vim commands and shortcuts. Nevertheless, this bundle includes a lot of plugins and configs which might add new commands or override some standard bindings. If you already completed **vimtutor** and know basics, you almost ready to use Vim as your main text editor. Here I'll put some commands which probably have own equivalens in most of other IDEs. Most of the given commands should be executed in **normal** mode.

| Command | Description |
|:--------|:------------|
| **Esc** | Enter normal mode and remove highlighting of search matches. |
| **Ctrl-f** | Fuzzy finder of files in current project. |
| **Ctrl-o** | Jump to previous opened buffer (similar to browser tab history). |
| **Ctrl-Shift-i** | Jump to next opened buffer (similar to browser tab history). |
| **Ctrl-p** | If current buffer is markdown document - render HTML and show it in Google Chrome. If browser already have opened markdown preview tab - refresh content. 
| **:Ack HelloWorld** | Global search of text in files of current project. |
| **:e ./src/Foo.hs** | Edit file in current buffer. |
| **:sp ./src/Foo.hs** | Split screen horizontally and edit file in new buffer. |
| **:vsp ./src/Foo.hs** | Split screen vertically and edit file in new buffer. |
| **:term** | Split screen horizontally and open new terminal session. |
| **:vert term** | Split screen vertically and open new terminal session. |
| **Ctrl-w Shift-n** | Switch from **terminal** insert mode to normal (to scroll, copy text etc). To switch back to **terminal** insert mode just press **i**. |
| **Ctrl-w Ctrl-w** | Switch to next split window clockwise. |
| **Ctrl-w h** | |
| **Ctrl-w j** | |
| **Ctrl-w k** | |
| **Ctrl-w l** | Switch to next split window in given direction. |

<br>
<p align="center">
  <tt>
    Made with ❤️ by
    <a href="https://itkach.uk" target="_blank">Ilja Tkachuk</a>
    aka
    <a href="https://github.com/timCF" target="_blank">timCF</a>
  </tt>
</p>
