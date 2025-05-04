@echo off
setlocal enabledelayedexpansion
echo Smart Git Commit and Push (with size check)

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

REM Get current branch name
for /f "tokens=*" %%i in ('"%GIT_PATH%" rev-parse --abbrev-ref HEAD') do set BRANCH_NAME=%%i
echo Current branch: %BRANCH_NAME%

REM Check for large files before adding (using simpler approach)
echo Checking for large files before adding (>5MB)...
for /f "tokens=*" %%f in ('dir /s /b /a:-d ^| findstr /v "\.git\\"') do (
    for /f "tokens=3" %%s in ('dir /a:-d "%%f" ^| findstr /r /c:"^[0-9]"') do (
        set size=%%s
        set size=!size:,=!
        if !size! gtr 5000000 (
            echo WARNING: Large file detected: %%f ^(!size! bytes^)
            set /p CONTINUE=Do you want to continue with this file? (y/n): 
            if /i "!CONTINUE!" neq "y" (
                echo Skipping this file. You may want to add it to .gitignore
                "%GIT_PATH%" rm --cached "%%f" 2>nul
            )
        )
    )
)

REM Add files to commit
echo Adding files to commit...
"%GIT_PATH%" add .

REM Show what will be committed
echo Files to be committed:
"%GIT_PATH%" status --short

REM Ask for confirmation
set /p CONFIRM=Are you sure you want to commit these changes? (y/n): 
if /i "%CONFIRM%" neq "y" (
    echo Commit canceled.
    exit /b 0
)

REM Get commit message
set /p COMMIT_MSG=Enter commit message: 
if "%COMMIT_MSG%"=="" (
    echo Commit message cannot be empty.
    exit /b 1
)

REM Commit changes
echo Committing changes...
"%GIT_PATH%" commit -m "%COMMIT_MSG%"

REM Push to remote
echo Pushing to remote...
"%GIT_PATH%" push origin %BRANCH_NAME%

echo Done!
endlocal
exit /b 0 