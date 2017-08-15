rm -rf phonegap
mkdir phonegap
cp index.html phonegap/be_autonomous.html
cp -r assets phonegap
cp index.js phonegap/be_autonomous.js
sed -i 's/index.js/phonegap\/be_autonomous.js/g' phonegap/be_autonomous.html
sed -i 's/assets/phonegap\/assets/g' phonegap/be_autonomous.html
cp -a phonegap cordova/www
