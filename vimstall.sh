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
   echo Updating vim...
   echo $( add-apt-repository ppa:jonathonf/vim -y )
   echo $( apt upgrade -y )
   echo $( apt install vim -y )
   echo Installing ripgrep for fast searching...
   echo $( apt install ripgrep -y )
   echo Please install ctags for code indexing...
   echo Installing vim plugin manager
   if [ -a ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim ]
    then echo Dein plugin manager already installed
   else
   echo  $( curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && sh ./installer.sh ~/.cache/vimfiles )
   fi
  $( rm -rf .vim && git clone https://github.com/jamestthompson3/vimConfig.git ~/.vim )
   echo Done!

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
   echo Installing vim plugin manager
   if [ -a ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim ]
    then echo Dein plugin manager already installed
   else
    echo $( curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && sh ./installer.sh ~/.cache/vimfiles )
   fi
  echo Linking to system vimrc
  $( ln -s vimrc ~/vimrc )
  echo Installing fonts...
  echo $( brew tap caskroom/fonts )
  echo $( brew cask install font-iosevka )
 echo Done!
else
  echo Sorry, pal, I don\'t do Windows
fi
