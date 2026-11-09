@echo off
chcp 65001 >nul
setlocal
title W132D - 4 WiFi
call "%~dp0_common.bat"
if errorlevel 1 exit /b 1
set "TAR=%BASE%files\w132d-fix.tar.gz"
set "SUB=wifi.sh"


type "%BASE%msg\s4.txt"
echo   Device : %USR%@%IP%

echo.

if not exist "%TAR%" goto :notar

echo [1/2] uploading ...
scp %SSHOPT% "%TAR%" %USR%@%IP%:/tmp/w132d-fix.tar.gz
if errorlevel 1 goto :upfail

echo [2/2] running on device ...
ssh -t %SSHOPT% %USR%@%IP% "sudo sh -c 'rm -rf /tmp/w132d-fix && tar xzf /tmp/w132d-fix.tar.gz -C /tmp && sh /tmp/w132d-fix/wifi.sh'"

echo.
type "%BASE%msg\s4-end.txt"
pause
exit /b 0

:upfail
type "%BASE%msg\upload-fail.txt"
pause
exit /b 1

:notar
type "%BASE%msg\no-tar.txt"
pause
exit /b 1

