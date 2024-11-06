#!/bin/bash
set -e -u -o pipefail

TGT_PATH=$HOME/.local/bin/yadm
if ! command -v yadm &> /dev/null && ! [[ -f $TGT_PATH ]]; then
    echo "$TGT_PATH not found, installing"
    curl -fLo $TGT_PATH https://raw.githubusercontent.com/yadm-dev/yadm/refs/tags/3.2.2/yadm
    echo "dd6a9a9f6442a1b8c742952132413c68ce55c077c5fd49f85a3aa219a33b6198" $TGT_PATH | sha256sum -c || \
        ( echo Wrong SHA on $TGT_PATH !!!; rm $TGT_PATH; false )
    chmod a+x $TGT_PATH
fi
PATH=$HOME/.local/bin:$PATH

yadm clone https://github.com/gavento/dotfiles

dotfiles-install-fzf.sh
