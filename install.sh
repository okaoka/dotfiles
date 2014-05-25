#install emacs
export DOTFILES=$HOME/dotfiles

ln -s -i $DOTFILES/.emacs.d $HOME/.emacs.d
ln -s -i $DOTFILES/.gitconfig $HOME/.gitconfig

mkdir -p $DOTFILES/.emacs.d/elisp
mkdir -p $DOTFILES/.emacs.d/conf
mkdir -p $DOTFILES/.emacs.d/public_repos
mkdir -p $DOTFILES/.emacs.d/url
mkdir -p $DOTFILES/.emacs.d/elpa
mkdir -p $DOTFILES/.emacs.d/inits

wget http://bit.ly/pkg-el23 -O package.el
mv $DOTFILES/package.el $DOTFILES/.emacs.d/inits
