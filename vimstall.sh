#!/bin/bash
echo 'Welcome to the installation process of my vimConfig!'
sleep .8
echo 'Checking os...'
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
if [ $machine = 'Linux' ]
  then
    echo Starting process for Linux
  sleep .8
   echo Installing Neovim
   echo $( sudo apt-get install software-properties-common -y )
   echo $( sudo apt-add-repository ppa:neovim-ppa/stable  -y )
   echo $( apt upgrade -y )
   echo $( apt install neovim -y )
   echo Installing ripgrep for fast searching...
   echo $( apt install ripgrep -y )
   echo Installing ctags for code indexing...
   echo $( apt install ctags -y)
   echo Installing vim plugin manager
   if [ -a ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim ]
    then echo Dein plugin manager already installed
   else
    echo $( sudo curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && sh ./installer.sh ~/.cache/vimfiles )
   fi
   echo Done!
   echo Now open nvim and run ':call dein#install()' to install plugins and then restart nvim to start coding
   echo Happy hacking!

elif [ $machine = 'Mac' ]
  then
   echo Starting process for Mac
   sleep .8
   echo Updating vim...
    if $( brew upgrade vim )
    then
      echo Vim upgraded
    else
      echo Installing vim
      echo $( brew install vim )
      echo $( brew install macvim )
    fi
   echo Installing ripgrep for fast searching...
   echo $( brew install ripgrep )
   echo Installing ctags for code indexing...
   echo $( brew install --HEAD universal-ctags/universal-ctags/universal-ctags )
    if [ -a ~/jstags ]
      then echo JS enhanced tags found
    else
     echo Installing JS enhanced tags...
     echo $( git clone https://github.com/romainl/ctags-patterns-for-javascript.git ~/jstags && cp ~/jstags/.ctags ~/.ctags)
   fi
   echo Installing vim plugin manager...
   if [ -a ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim ]
    then echo Dein plugin manager already installed
   else
    echo $( curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && sh ./installer.sh ~/.cache/vimfiles )
   fi
  echo Installing fonts...
  echo $( brew tap caskroom/fonts )
  echo $( brew cask install font-iosevka )
 echo Done!
else
  echo Sorry, pal, I don\'t do Windows
fi
