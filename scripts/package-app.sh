
built=$1

echo "packaging $built"
tar czvf $APP_PATH/. $built
echo "$built packaged"
