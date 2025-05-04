@echo off
setlocal enabledelayedexpansion
echo Cleaning Large File Storage (LFS) objects...

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

REM List LFS objects
echo Listing LFS tracked files:
"%GIT_PATH%" lfs ls-files

echo.
echo Identifying problematic large files in the repository...
"%GIT_PATH%" rev-list --objects --all | "%GIT_PATH%" cat-file --batch-check="%%H %%t %%s" | findstr "blob" | findstr /V ".git" | sort /R /+8 | more

echo.
echo Looking for large files in assets folder...
dir /S /B assets\*.png assets\*.jpg assets\*.gif assets\*.webp assets\*.mp4 assets\*.zip 2>nul

echo.
set /p CONTINUE=Do you want to untrack large asset files? (y/n): 
if /i "%CONTINUE%" neq "y" (
    echo Operation canceled. No changes made.
    exit /b 0
)

REM Remove large asset files from git tracking
echo Removing large asset files from git tracking...
for /f "tokens=*" %%f in ('dir /S /B assets\*.png assets\*.jpg assets\*.gif assets\*.webp assets\*.mp4 assets\*.zip 2^>nul') do (
    for /f "tokens=3" %%s in ('dir /a:-d "%%f" ^| findstr /r /c:"^[0-9]"') do (
        set size=%%s
        set size=!size:,=!
        if !size! gtr 1000000 (
            echo Removing %%f from git tracking (size: !size! bytes)
            "%GIT_PATH%" rm --cached "%%f"
        )
    )
)

REM Commit changes
echo Committing changes...
"%GIT_PATH%" commit -m "Remove large asset files from git tracking"

REM Push changes
echo Pushing changes to remote repository...
for /f "tokens=*" %%i in ('"%GIT_PATH%" rev-parse --abbrev-ref HEAD') do set BRANCH_NAME=%%i
"%GIT_PATH%" push origin %BRANCH_NAME% --force

echo Done!
endlocal
exit /b 0 