#!/bin/bash

source $APP_PATH/common/scripts/start-nvm.sh

nvm run default $APP_PATH/dist/index.js
