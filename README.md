# My personal Vim configuration

## Installation

Clone this repo and init/update bundles:

	git clone https://github.com/daniel-dpk/vimfiles.git ~/vimfiles
	cd ~/vimfiles
	git submodule update --init


On Unix/Linux (and probably Mac):

	ln -s ~/vimfiles ~/.vim


## Customization

To customize settings without modifying the repo, create the file `~/.vimrc`
(or `~/_vimrc` on Windows) with content:

	runtime vimrc
  	" Your customizations go here...


Similarly for GVim, create `~/.gvimrc` (or `~/_gvimrc`) containing:

	runtime gvimrc
	" Your customizations go here...


## License

The files are licensed under the MIT License, see LICENSE.txt.
