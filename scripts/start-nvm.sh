#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

NVM_CURRENT_VERSION="v"`nvm --version`
if [ "$NVM_CURRENT_VERSION" == "v" ]
then
	NVM_CURRENT_VERSION="not-installed"
fi

echo "nvm current version is $NVM_CURRENT_VERSION"

NVM_LATEST_VERSION=`curl -i $GITHUB_API_URI/repos/creationix/nvm/releases/latest | grep -o 'tag_name.*' | grep -o 'v[^/"]*",' | grep -o '[^",]*'`

echo "nvm latest version is $NVM_LATEST_VERSION"

if [ "$NVM_CURRENT_VERSION" == "" ] || [ "$NVM_CURRENT_VERSION" != "$NVM_LATEST_VERSION" ]
then
	echo "removing nvm directory"
	rm -rf $NVM_DIR

	echo "updating nvm from $NVM_CURRENT_VERSION to $NVM_LATEST_VERSION"
	curl -o- "https://raw.githubusercontent.com/creationix/nvm/$NVM_LATEST_VERSION/install.sh" | bash

	echo "nvm updated to $NVM_LATEST_VERSION"
else
	echo "nvm $NVM_CURRENT_VERSION is up to date"
fi

echo "starting nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
echo "nvm version is v"`nvm --version`
