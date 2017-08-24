
model="$IRON_IOT_MODEL"

rm -rf $APP_PATH/*

echo '****** PERFORMING COMMON PREP ******'
wget -O $APP_PATH/prep.sh https://raw.githubusercontent.com/ironman9967/iron-iot-common/master/scripts/prep.sh
chmod +x $APP_PATH/prep.sh
$APP_PATH/prep.sh $model
rm -rf $APP_PATH/prep.sh

echo "****** BUILDING $model ******"
wget -O $APP_PATH/prep.sh "https://raw.githubusercontent.com/ironman9967/iron-iot-$model/master/scripts/prep.sh"
chmod +x $APP_PATH/prep.sh
$APP_PATH/prep.sh $model
rm -rf $APP_PATH/prep.sh

echo "****** $model BUILT SUCCESSFULLY ******"
