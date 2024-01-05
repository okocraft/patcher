@if "%DEBUG%"=="" @echo off

set SOURCE_DIR_NAME=source
set PATCH_DIR_NAME=patches
set WORK_DIR_NAME=work

@REM Defines directory paths if not set

if "%SOURCE_DIR%"=="" (
    set SOURCE_DIR=%~dp0%SOURCE_DIR_NAME%\
)

if "%PATCH_DIR%"=="" (
    set PATCH_DIR=%~dp0%PATCH_DIR_NAME%\
)

if "%WORK_DIR%"=="" (
    set WORK_DIR=%~dp0%WORK_DIR_NAME%\
)

@REM Performs the specified operation

set SUBCOMMAND=%1

if "%SUBCOMMAND:~0,3%"=="app" (
    goto applyPatches
) else if "%SUBCOMMAND:~0,3%"=="reb" (
    goto rebuildPatches
) else (
    echo Unknown subcommand: %1
    exit /b 1
)



:applyPatches

@REM Checks if the source directory exists
if not exist %SOURCE_DIR% (
    echo No source directory found: %SOURCE_DIR%
    exit /b 1
)

if not exist %WORK_DIR% (
    mkdir %WORK_DIR%
)

cd %WORK_DIR%

@REM Creates a new git repository if not exists
if not exist ".git" (
    git init
    git config commit.gpgSign false
    git commit --allow-empty -m "Initial Commit" --author="Initial <init@example.com>"
)

@REM Resets a git repository to empty
for /f "usebackq" %%i in (`"git rev-list --max-parents=0 HEAD"`) do set FIRST_COMMIT_HASH=%%i
git reset --hard %FIRST_COMMIT_HASH%

@REM Copies sources to work
echo D | xcopy %SOURCE_DIR% %WORK_DIR% /s /q

@REM Commits initial source
git add .
git commit --allow-empty -m "Initial Source" --author="Initial <init@example.com>"

@REM Creates tags that uses for creating patches
git tag -d base > nul 2>&1
git tag base

@REM If the patch directory does not exists, exits this script
if not exist %PATCH_DIR% (
    goto end
)

@REM Collects patches

@setlocal enabledelayedexpansion

set patches=

for /R %PATCH_DIR% %%i in (*.patch) do (
    set patch=%%i
    set patches=!patches! !patch!
)

@REM If no patches found, exits this script
if "%patches%"=="" (
    goto end
)

@REM Applies patches
git am --3way --ignore-whitespace %patches%

@REM Ends this script
goto end



:rebuildPatches

@REM Deletes the patch directory if exists
rmdir %PATCH_DIR% /s /q 2>nul

@REM Rebuild patches.
cd %WORK_DIR%
git format-patch --zero-commit --full-index --no-signature --no-stat -N -o %PATCH_DIR% tags/base..HEAD

@REM Ends this script
goto end



:end
exit /b 0
