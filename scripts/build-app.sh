#!/bin/bash

appPath=$1
version=$2
model=$3
iteration=$4
mi=$model
if [ "$iteration" != "" ]
then
	mi=$mi"-$iteration"
fi
repo="iron-iot-$mi"

suffix="${mi}_app_$version.tar.gz"
prebuild="prebuild_${suffix}"
built="built_${suffix}"

echo 'removing temp'
rm -rf $appPath/temp

echo 'creating temp'
mkdir $appPath/temp

echo 'setting temp perms'
chmod 777 $appPath/temp

echo "extracting release $appPath/$prebuild"
tar xvzf $appPath/$prebuild --transform s:[^/]*:temp: -C $appPath

echo 'removing release tar'
rm $appPath/$prebuild

echo 'starting nvm'
source $appPath/common/scripts/start-nvm.sh

echo "navigating to temp $appPath/temp"
cd $appPath/temp

echo 'npm install all deps'
npm i

echo 'building app'
npm run build

echo 'navigate up from temp'
cd ..

echo 'copying dist'
cp -r $appPath/temp/dist $appPath/dist
echo 'copying scripts'
cp -r $appPath/temp/scripts $appPath/scripts
echo 'copying package.json'
cp $appPath/temp/package.json $appPath/
echo 'copying package-lock.json'
cp $appPath/temp/package-lock.json $appPath/

echo 'removing temp'
rm -rf $appPath/temp

echo 'npm install production deps'
npm i --production
