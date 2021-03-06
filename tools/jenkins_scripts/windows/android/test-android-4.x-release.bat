::This script is used to accomplish a android automated compiler.
::You should make sure have accomplished the environment setting.
::You should add %ANDROID_HOME%\tools and %ANDROID_HOME%\platform-tools to the environment variable of Path.

::Copy monkeyrunner python script to android sdk tools directory.
cd ..\..
copy %cd%\Monkeyrunner_TestCpp.py %ANDROID_HOME%\tools
copy %cd%\ReportManager.py %ANDROID_HOME%\tools

cd ..\..
set PROJECT_HOME=%cd%
cd samples\TestCpp\proj.android\bin

::Copy test apk to android sdk tools directory.
copy %cd%\TestCpp-release-14.apk %ANDROID_HOME%\tools
copy %cd%\TestCpp-release-15.apk %ANDROID_HOME%\tools

::Enter android sdk tools directory.
set ANDROID_ROOT=%ANDROID_HOME:~0,2%
%ANDROID_ROOT%
cd %ANDROID_HOME%\tools

::If monkeyrunner test failed,it automatically exit and make ERRORLEVEL nonzero.

::Running monkeyrunner test(release,API level:14).
ren TestCpp-release-14.apk TestCpp-release.apk
call monkeyrunner Monkeyrunner_TestCpp.py TestCpp-release.apk
if %ERRORLEVEL% NEQ 0 call python ReportManager.py && exit 1
rm TestCpp-release.apk

::Running monkeyrunner test(release,API level:15).
ren TestCpp-release-15.apk TestCpp-release.apk
call monkeyrunner Monkeyrunner_TestCpp.py TestCpp-release.apk
if %ERRORLEVEL% NEQ 0 call python ReportManager.py && exit 1
rm TestCpp-release.apk

rm Monkeyrunner_TestCpp.py
rm ReportManager.py

::Monkeyrunner success!
echo Monkeyrunner Test Success!

::Clean project files.
set PROJECT_ROOT=%PROJECT_HOME:~0,2%
%PROJECT_ROOT%
cd %PROJECT_HOME%

git checkout -f
git clean -df -x
exit 0

::End