#!/bin/bash

BREW_APPS=$(cat <<EOF
apr   gdk-pixbuf  libev   openssl@1.1  readline apr-util  gettext   libevent  p11-kit   ripgrep autoconf  glib   libffi   pango   ruby automake  gmp   libpng   pcre   socat aws-keychain  gnutls   librsvg   pcre2   spdylay aws-shell  go   libtasn1  perl   speedtest-cli bash   gobject-introspection libtiff   php56   sqlite bash-completion  graphite2  libtool   php56-mcrypt  the_silver_searcher berkeley-db@4  graphviz  libunistring  php56-xdebug  tmux boost   harfbuzz  libxml2   php70   tree c-ares   htop   libyaml   php70-mcrypt  unixodbc cairo   httpd   mcrypt   php70-xdebug  unrar cowsay   hub   mhash   pixman   vegeta docker   icu4c   miniupnpc  pkg-config  vim fish   imagemagick  mtr   postgresql  watch fontconfig  jansson   mysql   protobuf  webp fortune   jemalloc  nettle   pv   wget freetype  jpeg   nghttp2   python   xz gd   keychain  nmap   python3   zsh gdbm   libcroco  openssl   qt   zsh-syntax-highlighting
EOF
         )
PIP_APPS=<<EOF
altgraph==0.10.2
anglerfish==2.5.0
astroid==1.4.9
backports.functools-lru-cache==1.2.1
bdist-mpkg==0.5.0
bitarray==0.8.1
bonjour-py==0.3
colorama==0.3.9
configparser==3.5.0
cov-core==1.15.0
coverage==4.1
css-html-js-minify==2.2.2
docopt==0.6.2
enum34==1.1.6
impyla==0.13.8
isort==4.2.5
lazy-object-proxy==1.2.2
lolcat==0.44
macholib==1.5.1
matplotlib==1.3.1
mccabe==0.5.0
mock==1.0.1
modulegraph==0.10.4
numpy==1.8.0rc1
pathspec==0.5.5
pip==9.0.1
prettytable==0.7.2
py==1.4.34
py2app==0.7.3
pylint==1.6.5
pyobjc-core==2.5.1
pyobjc-framework-Accounts==2.5.1
pyobjc-framework-AddressBook==2.5.1
pyobjc-framework-AppleScriptKit==2.5.1
pyobjc-framework-AppleScriptObjC==2.5.1
pyobjc-framework-Automator==2.5.1
pyobjc-framework-CFNetwork==2.5.1
pyobjc-framework-Cocoa==2.5.1
pyobjc-framework-Collaboration==2.5.1
pyobjc-framework-CoreData==2.5.1
pyobjc-framework-CoreLocation==2.5.1
pyobjc-framework-CoreText==2.5.1
pyobjc-framework-DictionaryServices==2.5.1
pyobjc-framework-EventKit==2.5.1
pyobjc-framework-ExceptionHandling==2.5.1
pyobjc-framework-FSEvents==2.5.1
pyobjc-framework-InputMethodKit==2.5.1
pyobjc-framework-InstallerPlugins==2.5.1
pyobjc-framework-InstantMessage==2.5.1
pyobjc-framework-LatentSemanticMapping==2.5.1
pyobjc-framework-LaunchServices==2.5.1
pyobjc-framework-Message==2.5.1
pyobjc-framework-OpenDirectory==2.5.1
pyobjc-framework-PreferencePanes==2.5.1
pyobjc-framework-PubSub==2.5.1
pyobjc-framework-QTKit==2.5.1
pyobjc-framework-Quartz==2.5.1
pyobjc-framework-ScreenSaver==2.5.1
pyobjc-framework-ScriptingBridge==2.5.1
pyobjc-framework-SearchKit==2.5.1
pyobjc-framework-ServiceManagement==2.5.1
pyobjc-framework-Social==2.5.1
pyobjc-framework-SyncServices==2.5.1
pyobjc-framework-SystemConfiguration==2.5.1
pyobjc-framework-WebKit==2.5.1
pyOpenSSL==0.13.1
pyparsing==2.0.1
pytest==2.5.2
pytest-cov==1.5
python-dateutil==1.5
pytz==2013.7
PyYAML==3.12
requests==2.3.0
scipy==0.13.0b1
setuptools==18.5
singledispatch==3.4.0.3
six==1.4.1
thrift==0.9.3
uptime-cli==0.2.11
vboxapi==1.0
virtualenv==15.1.0
wheel==0.30.0
wrapt==1.10.8
xattr==0.6.4
yamllint==1.9.0
zope.interface==4.1.1
EOF
echo "$PIP_APPS" >> /tmp/.pip_apps

BREW_CASKS="chefdk  virtualbox java vagrant"
CHEF_GEMS="knife-spork knife-block knife-supermarket knife-ohno2 knife-cssh knife-solve knife-block"

sudo -v

if [ ! -z $DEBUG ] ; then
    set -x
    set -e
fi

#
# this is just for the emacs install.
#
if [ "$1" == "--source" ] ; then
    INSTALL='source'
else
    INSTALL='brew'
fi

#
# Link all the dotfiles to homedir
#
DOTFILES_DIR="$HOME/repos/dotfiles";
EXCLUDE='(setterupper|.el|~|README|lock|#|\.Trash|^\.git)'

cd $HOME
for i in $(ls -a $DOTFILES_DIR | egrep -v "$EXCLUDE" | egrep -v "^\.+$") ; do
    if [ ! -d $HOME/$i ] ; then
        CMD="ln -nfs $DOTFILES_DIR/$i"
    fi
    if [ -z $DEBUG ] ; then
        $($CMD)
    else
        echo "$CMD"
    fi
done

#
# Install XCode CLI Tools
#
sudo xcode-select --install

cd ~/.oh-my-zsh
git submodule update --init
echo "ENTER YOUR SYSTEM PASSWORD: "
chsh -s $(which zsh)

#
# Install Homebrew and some packages
#

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if [ ! -f ~/.brewhub ] ; then
    echo "\n\n"
    echo "You must reate a personal access token:"
    echo "https://github.com/settings/tokens/new?scopes=gist,public_repo&description=Homebrew"
    echo "Enter Github Token for Homebrew: "
    read github_key
    echo "export HOMEBREW_GITHUB_API_TOKEN='$github_key'" > ~/.brewhub
    source ~/.brewhub
fi

brew tap caskroom/versions
brew install $BREW_APPS
brew cask install $BREW_CASKS

sudo chown -R $(whoami) ~/.chefdk
eval "$(chef shell-init $SHELL)"

# emacs setup

# if [ $INSTALL == 'source' ]; then

#     if [ -e /usr/local/share/emacs ] ; then
#         sudo rm -rf /usr/local/share/emacs
#     fi

#     cd repos
#     git clone -b emacs-24 git@github.com:emacs-mirror/emacs.git
#     cd emacs
#     ./autogen.sh
#     ./configure --without-x --with-ns
#     make && sudo make install
# elif [ $INSTALL == 'brew' ]; then
#     brew install --with-cocoa --srgb emacs
#     brew linkapps emacs
# fi

mkdir -p $HOME/.emacs.d/personal/savefile/
touch $HOME/.emacs.d/personal/savefile/savehist
touch $HOME/.password.el.gpg

if [ ! -d /etc/profile.d ] ; then
    sudo mkdir -p /etc/profile.d
    sudo touch /etc/profile.d/jake.sh
fi

# GoLang
GO_PATH=$HOME/go
mkdir $GO_PATH

#
# ChefDK
#
# chefdk was installed via Homebrew, just configure it
#

mkdir -p $HOME/.chef
mkdir -p $HOME/repos

/opt/chefdk/embedded/bin/gem install $CHEF_GEMS --verbose --update

echo "Complete. Loading Z-Shell"
cd $HOME && zsh
