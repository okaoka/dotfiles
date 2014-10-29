#install emacs
export DOTFILES=$HOME/dotfiles

if [ -d $HOME/.emacs.d ] ; then
    rm -r $HOME/.emacs.d
fi

ln -s $DOTFILES/.emacs.d $HOME
ln -s -i $DOTFILES/.gitconfig $HOME

mkdir -p $DOTFILES/.emacs.d/elisp
mkdir -p $DOTFILES/.emacs.d/conf
mkdir -p $DOTFILES/.emacs.d/public_repos
mkdir -p $DOTFILES/.emacs.d/url
mkdir -p $DOTFILES/.emacs.d/elpa
mkdir -p $DOTFILES/.emacs.d/inits

# for emacs23
# wget http://bit.ly/pkg-el23 -O package.el
# mv $DOTFILES/package.el $DOTFILES/.emacs.d/inits
