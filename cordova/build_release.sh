# increase version number in config.xml
rm *apk
cordova build android --release --keystore=android_playstore.keystore --storePassword=android_playstore --alias=android_playstore
cp /home/ashish/work/be_autonomous/cordova/platforms/android/build/outputs/apk/android-release-unsigned.apk BeAutonomousReleaseSigned.apk
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ../../android_playstore.keystore BeAutonomousReleaseSigned.apk android_playstore
/home/ashish/android/build-tools/26.0.1/zipalign -v 4 BeAutonomousReleaseSigned.apk BeAutonomous.apk
