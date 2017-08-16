adb shell setprop log.tag.FA VERBOSE
adb shell setprop log.tag.FA-SVC VERBOSE
adb shell setprop debug.firebase.analytics.app com.beautonomous.first
adb logcat -v time -s FA FA-SVC
