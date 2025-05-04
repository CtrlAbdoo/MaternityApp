@echo off
setlocal enabledelayedexpansion
echo Final repository cleanup...

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

REM Make sure .gitignore includes assets
echo Updating .gitignore to exclude assets...

REM Create a temporary file
type .gitignore > tempgitignore.txt

REM Check if assets entry already exists
findstr "assets/images/" tempgitignore.txt >nul
if errorlevel 1 (
    echo.>> tempgitignore.txt
    echo # Assets - keep these local only>> tempgitignore.txt
    echo assets/images/*.png>> tempgitignore.txt
    echo assets/images/**/*.png>> tempgitignore.txt
    echo assets/images/*.jpg>> tempgitignore.txt
    echo assets/images/**/*.jpg>> tempgitignore.txt
    echo.>> tempgitignore.txt
    move /y tempgitignore.txt .gitignore
    echo Updated .gitignore to exclude image assets
) else (
    echo .gitignore already contains assets entries
    del tempgitignore.txt
)

REM Add .gitignore
"%GIT_PATH%" add .gitignore

REM Check for build files still in git
echo Checking for any remaining build files...
"%GIT_PATH%" rm --cached -r --ignore-unmatch build

REM Check LFS status
echo Checking Git LFS status...
"%GIT_PATH%" lfs ls-files

REM Commit any changes
"%GIT_PATH%" status --short | findstr . >nul
if %errorlevel% equ 0 (
    "%GIT_PATH%" commit -m "Final cleanup - ensure build files and images are ignored"
    
    REM Push with force-with-lease to be safer
    echo Pushing final changes...
    for /f "tokens=*" %%i in ('"%GIT_PATH%" rev-parse --abbrev-ref HEAD') do set BRANCH_NAME=%%i
    "%GIT_PATH%" push origin %BRANCH_NAME% --force-with-lease
) else (
    echo No changes to commit.
)

echo.
echo Cleanup complete! Future commits should be much smaller.
echo.
echo IMPORTANT: Your image assets remain in your project folder 
echo but are no longer tracked by Git. Other team members will 
echo need to get these files from you via alternative means.
echo.

endlocal
exit /b 0 