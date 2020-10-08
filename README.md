# My personal Vim configuration

## Prerequisites

Automatic tag generation is handled by
[Gutentags](https://github.com/ludovicchabant/vim-gutentags).
It is recommended to use
[universal-ctags](https://github.com/universal-ctags/ctags)
instead of `exuberant-ctags` for wildcard support and better performance.


## Installation

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
