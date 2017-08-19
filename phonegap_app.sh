rm -rf phonegap
rm -rf cordova/www/phonegap
mkdir phonegap
# cp index.html phonegap/beautonomous.html
cp -r assets phonegap
cp index.js phonegap/beautonomous.js
# sed -i 's/index.js/phonegap\/beautonomous.js/g' phonegap/beautonomous.html
# sed -i 's/assets/phonegap\/assets/g' phonegap/beautonomous.html
cp -a phonegap cordova/www
