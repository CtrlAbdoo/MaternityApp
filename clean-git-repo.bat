@echo off
echo Cleaning repository of large unnecessary files...

REM Set the path to Git
set GIT_PATH=C:\Program Files\Git\bin\git.exe

REM Check if Git exists
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

REM Check if we're in a git repository
"%GIT_PATH%" rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Not in a git repository.
    exit /b 1
)

REM Find and remove common large files from Git tracking (not from disk)
echo Removing build directories from Git tracking...
"%GIT_PATH%" rm --cached -r --ignore-unmatch build
echo Removed build/ directory from git (files remain on disk)

"%GIT_PATH%" rm --cached -r --ignore-unmatch .dart_tool
echo Removed .dart_tool/ directory from git

"%GIT_PATH%" rm --cached -r --ignore-unmatch .idea
echo Removed .idea/ directory from git

"%GIT_PATH%" rm --cached -r --ignore-unmatch ios/Pods
echo Removed ios/Pods/ directory from git

"%GIT_PATH%" rm --cached -r --ignore-unmatch android/.gradle
echo Removed android/.gradle/ directory from git

"%GIT_PATH%" rm --cached -r --ignore-unmatch windows/flutter/ephemeral
echo Removed windows/flutter/ephemeral/ directory from git

"%GIT_PATH%" rm --cached -r --ignore-unmatch macos/Flutter/ephemeral
echo Removed macos/Flutter/ephemeral/ directory from git

"%GIT_PATH%" rm --cached -r --ignore-unmatch linux/flutter/ephemeral
echo Removed linux/flutter/ephemeral/ directory from git

echo Removing common generated files...
"%GIT_PATH%" rm --cached --ignore-unmatch pubspec.lock
"%GIT_PATH%" rm --cached --ignore-unmatch .flutter-plugins
"%GIT_PATH%" rm --cached --ignore-unmatch .flutter-plugins-dependencies
"%GIT_PATH%" rm --cached -r --ignore-unmatch .gradle
"%GIT_PATH%" rm --cached --ignore-unmatch local.properties
"%GIT_PATH%" rm --cached -r --ignore-unmatch android/app/debug
"%GIT_PATH%" rm --cached -r --ignore-unmatch android/app/profile
"%GIT_PATH%" rm --cached -r --ignore-unmatch android/app/release
"%GIT_PATH%" rm --cached -r --ignore-unmatch android/build
"%GIT_PATH%" rm --cached -r --ignore-unmatch android/gradle

REM Get current status
echo Current repository status:
"%GIT_PATH%" status --short

REM Prompt before committing
set /p CONTINUE=Commit these changes? (y/n): 
if /i "%CONTINUE%" neq "y" (
    echo Operation canceled. No changes committed.
    exit /b 0
)

REM Commit changes with the removed files
echo Creating commit for removed files...
"%GIT_PATH%" commit -m "Remove large unnecessary files from Git tracking"

REM Make sure .gitignore is working
echo Checking .gitignore effectiveness...
echo build/ is excluded: 
"%GIT_PATH%" check-ignore -v build

echo Done! Repository should be much smaller now.

REM Automatically push the changes
echo Pushing changes to remote repository...
for /f "tokens=*" %%i in ('"%GIT_PATH%" rev-parse --abbrev-ref HEAD') do set BRANCH_NAME=%%i
echo Current branch: %BRANCH_NAME%
"%GIT_PATH%" push origin %BRANCH_NAME%

echo Push completed.
exit /b 0 