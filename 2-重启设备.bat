@echo off
chcp 65001 >nul
setlocal
title W132D - 2 REBOOT
call "%~dp0_common.bat"
if errorlevel 1 exit /b 1

type "%BASE%msg\s2.txt"
echo   Device : %USR%@%IP%
echo.
set "yn="
set /p "yn=  reboot now ?  type y then Enter : "
if /i not "%yn%"=="y" exit /b 0

echo.
echo sending reboot ...
ssh %SSHOPT% %USR%@%IP% "sudo reboot" >nul 2>nul

echo.
type "%BASE%msg\s2-end.txt"
pause
exit /b 0
