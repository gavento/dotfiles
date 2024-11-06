#!/bin/bash
set -e -u -o pipefail

TGT_PATH=$HOME/.local/bin/fzf
mkdir -p $HOME/.local/bin

if ! [[ -f $TGT_PATH ]]; then
    echo "$TGT_PATH not found, installing"
    curl -fL https://github.com/junegunn/fzf/releases/download/v0.56.0/fzf-0.56.0-linux_amd64.tar.gz | tar -xz -C $HOME/.local/bin -f - fzf 
    echo "d70f43b3f1900123c4d3de5a0aafd12ec0b9d9a222df8d90ee6aee773e740f2c" $TGT_PATH | sha256sum -c || \
        ( echo Wrong SHA on $TGT_PATH !!!; rm $TGT_PATH; false )
    chmod a+x $TGT_PATH
fi
