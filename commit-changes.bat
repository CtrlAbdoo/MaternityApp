@echo off
echo Committing changes to repository

REM Set the path to Git if it's not in your PATH
set GIT_PATH=C:\Program Files\Git\bin\git.exe

REM Check if Git exists at the standard location
if not exist "%GIT_PATH%" (
    echo Searching for Git...
    for /f "tokens=*" %%i in ('where git 2^>nul') do (
        set GIT_PATH=%%i
        goto :found_git
    )
    
    echo Git not found. Please install Git or provide the correct path.
    exit /b 1
)

:found_git
echo Using Git at: %GIT_PATH%

REM Get current branch name
for /f "tokens=*" %%i in ('"%GIT_PATH%" rev-parse --abbrev-ref HEAD') do set BRANCH_NAME=%%i
echo Current branch: %BRANCH_NAME%

REM Create a temporary .gitignore if one doesn't exist
if not exist ".gitignore" (
    echo Creating temporary .gitignore file
    (
        echo # Dart/Flutter
        echo .dart_tool/
        echo .flutter-plugins
        echo .flutter-plugins-dependencies
        echo build/
        echo .packages
        echo pubspec.lock
        
        echo # Android
        echo android/gradle-wrapper.jar
        echo android/.gradle
        echo android/captures/
        echo android/gradlew
        echo android/gradlew.bat
        echo android/local.properties
        echo android/**/GeneratedPluginRegistrant.*
        
        echo # iOS/XCode
        echo ios/**/*.mode1v3
        echo ios/**/*.mode2v3
        echo ios/**/*.moved-aside
        echo ios/**/*.pbxuser
        echo ios/**/*.perspectivev3
        echo ios/**/*sync/
        echo ios/**/.sconsign.dblite
        echo ios/**/.tags*
        echo ios/**/.vagrant/
        echo ios/**/DerivedData/
        echo ios/**/Icon?
        echo ios/**/Pods/
        echo ios/**/.symlinks/
        echo ios/**/profile
        echo ios/**/xcuserdata
        
        echo # IDE
        echo .idea/
        echo .vscode/
        echo *.iml
        
        echo # Windows
        echo windows/flutter/ephemeral/
        
        echo # macOS
        echo macos/Flutter/ephemeral/
        
        echo # Linux
        echo linux/flutter/ephemeral/
    ) > .gitignore
)

REM Add all files except those ignored
"%GIT_PATH%" add .

REM Commit with message
set /p COMMIT_MSG="Enter commit message: "
"%GIT_PATH%" commit -m "%COMMIT_MSG%"

REM Push to remote with upstream setup
echo Setting upstream branch and pushing...
"%GIT_PATH%" push --set-upstream origin %BRANCH_NAME%

echo Done!
exit /b 0 