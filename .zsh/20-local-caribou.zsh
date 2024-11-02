# Local settings for caribou

if [[ $(hostname) == "caribou" ]]; then
    alias bkup="sudo /root/restic-backup/bin/resticprofile -c /root/restic-backup/profiles.yaml $@"
    alias code="code-insiders"

    # Local settings

    export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

    # Misc aliases

    alias valheim-mods-upload-alfonsovo="rsync -pPr ~/.config/r2modmanPlus-local/Valheim/profiles/SMichalem/BepInEx/plugins/ cloudbarn:/dockers/valheim-alfonsovo/server/BepInEx/plugins/ --delete && ssh cloudbarn chown 166536:166536 -R /dockers/valheim-alfonsovo/server"
fi
