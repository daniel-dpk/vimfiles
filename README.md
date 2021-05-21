# My Vim configuration

> **NOTE 1:**
> A Vim configuration highly depends on individual preferences. This
> configuration will most likely *not* suit anyone but me. However, it may
> help in some cases and/or serve as inspiration for your own configuration.

> **NOTE 2:**
> This configuration is tested and used on Linux. Some effort is done to make
> it work on OS X and Windows. However this is quite limited, so YMMV.


## Overview

The customizations introduced here roughly do three things:

1. Set up a different default behavior (e.g. for backups, color scheme, hidden
   buffers, Python PEP8 style, ...).
2. Add mappings for convenience (e.g. opening/closing and navigating tabs).
3. Add several plug-ins (e.g. for quickly navigating directories, syntax
   checking, code/document snippets, Git integration, session and local
   settings handling).

Not all changes are equally relevant in practice. Compared with the default
Vim behavior, the main changes in everyday work turned out to be the following
for me:

* Using NERDTree (`F12`) and ctrlp (`Ctrl-p`) to quickly navigate large numbers
  of files.
* Relying on automatic `tags` updating so that `Alt-Shift-i` in combination
  with `Ctrl-o` and `Ctrl-i` can be used to quickly jump to different places
  in the code.
* Using `\v` (a backslash followed by `v`) to quickly grep for any expression
  throughout the whole source. This opens a small window with a quickfix list
  showing all matches. The matches can quickly be jumped through using `,n`
  and `,p`.
* For all of the above to work seamlessly, the `hidden` option is extremely
  helpful to not interrupt the jumping when files have been changed.
  Frequently use `:wa` to make sure everything is saved, though.


## Installation

### Prerequisites

Automatic tag generation is handled by
[Gutentags](https://github.com/ludovicchabant/vim-gutentags).
It is recommended to use
[universal-ctags](https://github.com/universal-ctags/ctags)
instead of `exuberant-ctags` for wildcard support and better performance.

### Installing from GitHub

Clone this repo and init/update bundles:

	git clone https://github.com/daniel-dpk/vimfiles.git ~/vimfiles
	cd ~/vimfiles
	git submodule update --init


**IMPORTANT:** If you currently have a `~/.vim` directory, first back it up
and rename it e.g. to `~/.vim-backup`. Likewise, backup and rename/remove any
existing `~/.vimrc` and `~/.gvimrc` (or `~/_vimrc` and `~/_gvimrc` on
Windows).


On Unix/Linux (and probably Mac):

	ln -s ~/vimfiles ~/.vim


To generate documentation for all installed plugins, run the following:

    vim "+set wildignore=" +Helptags +q!


## Installing new plug-ins

Plug-ins are handled by Pathogen, so the usual steps are (e.g.):

    cd ~/vimfiles/bundle
    git submodule add https://github.com/ctrlpvim/ctrlp.vim.git

To generate the help, as above, execute:

    vim "+set wildignore=" +Helptags +q!


## Customization

To customize settings without modifying the repo, create the file `~/.vimrc`
(or `~/_vimrc` on Windows) with content:

	runtime vimrc
  	" Your customizations go here...


Similarly for GVim, create `~/.gvimrc` (or `~/_gvimrc`) containing:

	runtime gvimrc
	" Your customizations go here...


An alternative is to put customizations into the file
`~/vimfiles/custom_settings.vim`, which you will have to create. It will be
loaded at the end of processing the `vimrc` and will be ignored by this repo.


## License

The files are licensed under the MIT License, see LICENSE.txt.
