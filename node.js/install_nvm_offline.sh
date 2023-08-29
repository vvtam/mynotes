NVM_VERSION="nvm-0.39.5"
unzip "${NVM_VERSION}.zip"
export NVM_DIR="$HOME/.nvm" && (
  mkdir "$NVM_DIR"
  cd ${NVM_VERSION} && cp bash_completion nvm-exec nvm.sh ${NVM_DIR}/
  cd "$NVM_DIR"
) && \. "$NVM_DIR/nvm.sh"

cat >> ~/.bashrc <<EOF
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
