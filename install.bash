#!/usr/bin/env bash

test -w $HOME/.bash_profile &&
    cp $HOME/.bash_profile $HOME/.bash_profile.bak &&
    rm $HOME/.bash_profile &&
    echo "Your original .bash_profile has been backed up to .bash_profile.bak."

CURRENT_DIR="$(cd "$(dirname $0)" && pwd)"

_check_binaries() {
    local binaries=( brew git rbenv tmux )
    for b in ${binaries[@]}; do
        hash "$b" > /dev/null 2>&1
        if [ $? -gt 0 ]; then
            echo "Missing binary: ${b}  please install to continue..."
            exit 1
        fi
    done
}

_brew_install_formulas() {
    while true; do
        read -p "Would you like to install brew formulas? [Y/N]" RESP
        case $RESP in
            [yY])
                brew tap homebrew/cask
                brew cask install java
                while read line; do
                    brew install $line
                done < ${CURRENT_DIR}/brew/formulas
                brew cask install docker
                brew cask install android-sdk
                break
                ;;
            [nN])
                break
                ;;
            *)
                echo "Please enter y or n."
                ;;
        esac
    done
}

_load_bash() {
    for file in $(ls "${CURRENT_DIR}/bash/"); do
        local filename="$(basename ${file})"
        local dest="${CURRENT_DIR}/bash/${filename}"
        if [ ! -e "${HOME}/.${filename}" ]; then
            ln -s "${dest}" "${HOME}/.${filename}"
        else
            echo "File .${filename} exists. Skipping..."
        fi
    done
    touch $CURRENT_DIR/ignored/bash_paths
}

_load_extras() {
    declare -a extras=( 'dircolors' 'gemrc' 'gitignore_global' 'inputrc' )
    for e in ${extras[@]}; do
        local dest="${CURRENT_DIR}/${e}"
        while true; do
            read -p "Would you like to install ${e}? [Y/N]" RESP
            case $RESP in
                [yY])
                    if [ ! -e "${HOME}/.${e}" ]; then
                        cp "$dest" "${HOME}/.${e}"
                        if [ ${e} == "gitignore_global" ]; then
                            _global_gitignore
                        fi
                    else
                        echo "File .${e} exists. Skipping..."
                    fi
                    break
                    ;;
                [nN])
                    break
                    ;;
                *)
                    echo "Please enter y or n."
                    ;;
            esac
        done
    done
}

_load_gitconfig() {
    local conf="gitconfig"
    local dest="${CURRENT_DIR}/${conf}"
    while true; do
        read -p "Would you like to install ${conf}? [Y/N]" RESP
        case $RESP in
            [yY])
                if [ ! -e "${HOME}/.${conf}" ]; then
                    cp "${dest}" "${HOME}/.${conf}"

                    # Set the name
                    read -p "Your first and last name: " YOUR_NAME
                    sed -i "s/%NAME%/$YOUR_NAME/g" "${HOME}/.${conf}"

                    # Set the email
                    read -p "Your email: " YOUR_EMAIL
                    sed -i "s/%EMAIL%/$YOUR_EMAIL/g" "${HOME}/.${conf}"
                else
                    echo "File .${conf} exists. Skipping..."
                fi
                break
                ;;
            [nN])
                break
                ;;
            *)
                echo "Please enter y or n."
                ;;
        esac
    done
}

_global_gitignore() {
    echo "Adding global gitignore to your cross-repository configuration."
    $(git config --global core.excludesfile ~/.gitignore_global)
}


_osx_settings() {
    local name=$(uname)

    if [[ $name == "Darwin" ]]; then
        while true; do
            read -p "Would you like to install OS X Settings? [Y/N]" RESP
            case $RESP in
                [yY])
                    $($CURRENT_DIR/osx/set-defaults.sh)
                    break
                    ;;
                [nN])
                    break
                    ;;
                *)
                    echo "Please enter y or n."
                    ;;
            esac
        done
    fi
}

_load_bin() {
    while true; do
        read -p "Would you like to install bin scripts? [Y/N]" RESP
        case $RESP in
            [yY])
                mkdir -p $HOME/bin
                cp -i $CURRENT_DIR/bin/* $HOME/bin
                break
                ;;
            [nN])
                break
                ;;
            *)
                echo "Please enter y or n."
                ;;
        esac
    done
}

_load_tmux() {
    while true; do
        read -p "Would you like to install tmux conf? [Y/N]" RESP
        case $RESP in
            [yY])
                for file in $(ls "${CURRENT_DIR}/tmux/"); do
                    local filename="$(basename ${file})"
                    local dest="${CURRENT_DIR}/tmux/${filename}"
                    if [ ! -e "${HOME}/.${filename}" ]; then
                        ln -s "${dest}" "${HOME}/.${filename}"
                    else
                        echo "File .${filename} exists. Skipping..."
                    fi
                done
                $(git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm)
                break
                ;;
            [nN])
                break
                ;;
            *)
                echo "Please enter y or n."
                ;;
        esac
    done
}

_load_ack() {
    while true; do
        read -p "Would you like to install ackrc? [Y/N]" RESP
        case $RESP in
            [yY])
                for file in $(ls "${CURRENT_DIR}/ack/"); do
                    local filename="$(basename ${file})"
                    local dest="${CURRENT_DIR}/ack/${filename}"
                    if [ ! -e "${HOME}/.${filename}" ]; then
                        ln -s "${dest}" "${HOME}/.${filename}"
                    else
                        echo "File .${filename} exists. Skipping..."
                    fi
                done
                break
                ;;
            [nN])
                break
                ;;
            *)
                echo "Please enter y or n."
                ;;
        esac
    done
}

install() {
    _check_binaries
    _brew_install_formulas
    _load_bash
    _load_extras
    _load_gitconfig
    _global_gitignore
    _osx_settings
    _load_bin
    _load_tmux
    _load_ack
    cat ${CURRENT_DIR}/post_install_notes.txt
}

install

exit 0
