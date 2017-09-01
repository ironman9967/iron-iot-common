#!/bin/bash

echo 'removing common'
rm -rf $APP_PATH/common

echo 'creating common'
mkdir $APP_PATH/common

echo 'setting common perms'
chmod 777 $APP_PATH/common

releaseUrl=$GITHUB_API_URI/repos/ironman9967/iron-iot-common/releases/latest

echo "requesting latest release from $releaseUrl"
res=`curl -H "Accept: application/vnd.github.v3+json" $releaseUrl`

if [ $? -eq 0 ]
then
	echo "!!! ERROR REQUESTING LATEST RELEASE !!!"
	echo $res
	exit 1
else
	echo 'common prep downloaded successfully'
fi

url=`echo $res | grep -o 'tarball_url.*' | grep -o 'http[^",]*'`

echo "release url $url"

version=`echo $url | grep -o '[^/]*$'`

echo "downloading common release $version"
rm -rf $APP_PATH/latest.tar.gz
`wget -O $APP_PATH/latest.tar.gz $url`

echo 'extracting release'
tar xzf $APP_PATH/latest.tar.gz --transform s:[^/]*:common: -C $APP_PATH

echo 'removing release tar'
rm $APP_PATH/latest.tar.gz
