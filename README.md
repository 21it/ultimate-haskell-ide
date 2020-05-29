# Ultimate Haskell IDE

<img src="logo.png" alt="logo" width="350"/>

If you have no idea what is Nix derivation, where and how you can use this package, or you just want to try it out somewhere very quickly - that's completely fine. Just check out [tkachuk-labs/stack-templates](https://github.com/tkachuk-labs/stack-templates) repo first.

# Features

- Syntax highlighting

- Auto-completion

- Auto-formatting

- Auto-refactoring

- Jump to definition

- Compiler and linter suggestions

- Hoogle docs

- Beginner friendly

# Installation

### With Nix

#### Note: to make installation process much faster, make sure you are using [cachix](https://all-hies.cachix.org/).

```nix
import (fetchTarball "https://github.com/tim2CF/ultimate-haskell-ide/tarball/master") {}
```

### Without Nix (not recommended)

#### Warning: to use this package without Nix, you have to install all binary dependencies manually. Look [default.nix](https://github.com/tim2CF/ultimate-haskell-ide/blob/master/default.nix) file for complete list of dependencies.

```bash
git clone --depth=1 https://github.com/tim2CF/ultimate-haskell-ide.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
```

# Usage

```bash
vi .
```

# Some commands

This IDE is based on normal Vim. It should support all the most standard Vim commands and shortcuts. Nevertheless, this bundle includes a lot of plugins and configs which might add new commands or override some standard bindings. If you already completed **vimtutor** and know basics, you almost ready to use Vim as your main text editor. Here I'll put some commands which probably have own equivalens in most of other IDEs. Most of the given commands should be executed in **normal** mode.

| Command | Description |
|:--------|:------------|
| **Esc** | Enter normal mode and remove highlighting of search matches. |
| **:BG** | Toggle dark/light color theme. |
| **:w** | Apply code formatter and save the file. |
| **Ctrl-f** | Fuzzy finder of files in current project. |
| **Ctrl-o** | Jump to previous opened buffer (similar to browser tab history movements). |
| **Ctrl-Shift-i** | Jump to next opened buffer (similar to browser tab history movements). |
| **Ctrl-p** | If current buffer is markdown document - render HTML and show it in Google Chrome. If browser already have opened markdown preview tab - refresh content.
| **:Ack HelloWorld** | Global search of text in files of current project. |
| **:e ./src/Foo.hs** | Edit file in current buffer. |
| **:sp ./src/Foo.hs** | Split screen horizontally and edit file in new buffer. |
| **:vsp ./src/Foo.hs** | Split screen vertically and edit file in new buffer. |
| **:term** | Split screen horizontally and open new terminal session. |
| **:vert term** | Split screen vertically and open new terminal session. |
| **Ctrl-w Shift-n** | Switch from **terminal** insert mode to normal (to scroll, copy text etc). To switch back to **terminal** insert mode just press **i**. |
| **Ctrl-ww** | Focus on next split window clockwise. |
| **Ctrl-wh** | Focus on next split window in given direction (left). |
| **Ctrl-wj** | Focus on next split window in given direction (down). |
| **Ctrl-wk** | Focus on next split window in given direction (up). |
| **Ctrl-wl** | Focus on next split window in given direction (right). |
| **gt** | Focus on next tab. |
| **:tabclose** | Close current tab. |
| **:tabonly** | Close all tabs except current. |
| **gd** | Jump to expression definition. |
| **Shift-k** | Show expression type and documentation. |
| **to** | Apply refactoring according one hint at cursor position. |
| **ta** | Apply all refactoring suggestions in current buffer. |

# Known issues

- I tested this derivation only on x86-64 Alpine Linux. Anyway, Nix derivation usually is very portable thing and theoretically should work everywhere.

- HIE (Haskell IDE engine) in some cases requires some time to start and warm-up. It depends on project size, but usually this startup delay appears in projects with **custom-setup** directive. Anyway, after HIE is started, all IDE features like linter suggestions, jump to definition, auto-completion, auto-refactoring and documentation should work instantly.

<br>
<p align="center">
  <tt>
    Made with ❤️ by
    <a href="https://itkach.uk" target="_blank">Ilja Tkachuk</a>
    aka
    <a href="https://github.com/timCF" target="_blank">timCF</a>
  </tt>
</p>
