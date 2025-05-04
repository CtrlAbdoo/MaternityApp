@echo off
echo Finding largest files in the repository...

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

echo.
echo === LARGEST FILES TRACKED BY GIT ===
echo.

REM Find large files in git using PowerShell (Windows-compatible)
PowerShell -Command "& { '%GIT_PATH%' ls-tree -r -t -l --full-name HEAD | ForEach-Object { $_ -match '^.*\s+(\d+)\s+(.*)$' > $null; if ($matches) { [PSCustomObject]@{Size=[int]$matches[1]; Path=$matches[2]} } } | Sort-Object -Property Size -Descending | Select-Object -First 20 | Format-Table -AutoSize }"

echo.
echo === FINDING RECENTLY ADDED LARGE FILES ===
echo.

REM List all objects in the repository with their sizes
echo This may take a moment...
"%GIT_PATH%" rev-list --objects --all | "%GIT_PATH%" cat-file --batch-check="%%H %%t %%s" | findstr blob | sort /R /+8

echo.
echo To remove a specific large file from git tracking (but keep it on disk):
echo "%GIT_PATH%" rm --cached path/to/large/file
echo.
echo Then commit the removal:
echo "%GIT_PATH%" commit -m "Remove large file from tracking"
echo.

exit /b 0 