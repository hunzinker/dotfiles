#!/usr/bin/env bash

test -w $HOME/.bash_profile &&
    cp $HOME/.bash_profile $HOME/.bash_profile.bak &&
    rm $HOME/.bash_profile &&
    echo "Your original .bash_profile has been backed up to .bash_profile.bak."

CURRENT_DIR="$(cd "$(dirname $0)" && pwd)"

_load_bash() {
    for file in $(ls "${CURRENT_DIR}/bash/"); do
        local filename="$(basename ${file})"
        local dest="${CURRENT_DIR}/bash/${filename}"
        if [ ! -e "${HOME}/.${filename}" ]; then
            cp "${dest}" "${HOME}/.${filename}"
        else
            echo "File .${filename} exists. Skipping..."
        fi
    done
}

_load_extras() {
    declare -a extras=( 'dircolors' 'gemrc' )
    for e in ${extras[@]}; do
        local dest="${CURRENT_DIR}/${e}"
        while true; do
            read -p "Would you like to install ${e}? [Y/N]" RESP
            case $RESP in
                [yY])
                    if [ ! -e "${HOME}/.${e}" ]; then
                        cp "$dest" "${HOME}/.${e}"
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

install() {
    _load_bash
    _load_extras
    _load_gitconfig
}

install

exit 0
