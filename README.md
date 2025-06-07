# ![logo](https://github.com/8192Bit/cloudmusicqt/blob/master/cloudmusicqt80.png?raw=true "logo") cloudmusicqt 
A qt port for netease cloud music. Currently symbian and harmattan devices are supported.

## Building

To build cloudmusicqt with full functionality that Symbian Belle provided, you need to have following tools installed:
1. [QtSDK1.2](https://nnm.nnchan.ru/dl/sdk/QtSdk-offline-win-x86-v1_2_1.zip)[^1]
2. [Symbian Belle Qt SDK (named like SymbianSR1Qt474)](https://nnm.nnchan.ru/dl/sdk/Belle_SDK_for_QtSDK_v1.2.1_SymbianSR1Qt474.7z)[^1]

[^1]: Thanks to [shinovon](https://github.com/shinovon) for file hosting.


Open Qt Creator. Go to <u>T</u>ools-<u>O</u>ptions-Build and Run-Qt Versions-Add..., then select qmake.exe inside SymbianSR1Qt474\bin.

Open cloudmusicqt.pro with Qt Creator, check "Symbian Device", "Harmattan Device". "Qt Simulator" is optional for a quick and inaccurate test on your computer.

Click "details" next to Symbian Device, check "Qt 4.7.3 (Symbian1Qt473)" debug and release, "Qt 4.7.4 (SymbianSR1Qt474)" debug and release.

Change to Projects mode (by clicking Projects button on the left of Qt Creator window) to modify detailed building configurations.

Open Build/Run Target Selector (by clicking the phone icon above the big green Run button) to select package for which platform to build.

You might add a fake Harmattan device to create deb package, and set sign mode to Not signed in the Create SIS Package step.

Click the Run button to create the distributable file to the project root. (cloudmusicqt_unsigned.sis and cloudmusicqt_x.x.x_armel.deb)

