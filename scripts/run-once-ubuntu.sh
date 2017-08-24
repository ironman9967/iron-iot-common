
#################################
# !!!  RUN CONFIG.SH FIRST  !!! #
#################################
if [ "$IRON_IOT_MODEL" == "" ] || [ "$user" == "" ] || [ "$GITHUB_API_URI" == "" ] || [ "$CLOUD_URI" == "" ] || [ "$ARMB_1_URI" == "" ] || [ "$APP_PATH" == "" ]; then
	echo "ERROR: missing variables, did you run config.sh?"
	exit 1
fi

desc="iron-iot-svc-app-$IRON_IOT_MODEL"
script="$APP_PATH/.nuke.sh"
restart="always"

mkdir -p $APP_PATH
rm -f $script
touch $script
sudo chmod 777 $script

echo '#!/bin/bash' >> $script
echo 'export IRON_IOT_MODEL='$IRON_IOT_MODEL >> $script
echo 'export CLOUD_URI='$CLOUD_URI >> $script
echo 'export GITHUB_API_URI='$GITHUB_API_URI >> $script
echo 'export ARMB_1_URI='$ARMB_1_URI >> $script
echo 'export APP_PATH='$APP_PATH >> $script
echo 'chmod 777 $HOME' >> $script
echo 'chmod 777 $APP_PATH' >> $script
echo 'rm -rf $APP_PATH/build.sh' >> $script
echo 'wget -O $APP_PATH/build.sh https://raw.githubusercontent.com/ironman9967/iron-iot-common/master/scripts/build.sh' >> $script
echo 'chmod +x $APP_PATH/build.sh' >> $script
echo '$APP_PATH/build.sh' $IRON_IOT_MODEL >> $script
echo 'echo "starting $IRON_IOT_MODEL app"' >> $script
echo 'chmod +x $APP_PATH/common/scripts/start.sh' >> $script
echo '$APP_PATH/common/scripts/start.sh' >> $script

chmod +x $script

sudo systemctl stop $desc
sudo systemctl disable $desc
sudo rm -f /etc/systemd/system/$desc.service
sudo systemctl daemon-reload

echo -e "[Unit]\nDescription=$desc\nAfter=network.target\n\n[Service]\nUser=$user\nUMask=000\nExecStart=$script\nRestart=$restart\n\n[Install]\nWantedBy=multi-user.target\n" | sudo tee "/etc/systemd/system/$desc.service"
sudo systemctl enable $desc
sudo systemctl start $desc
sudo systemctl status $desc
