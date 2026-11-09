@echo off
chcp 65001 >nul
rem ============================================================
rem  common: read config.bat, validate, make ssh passwordless
rem  every step script calls this first - do not run it alone
rem ============================================================
set "BASE=%~dp0"
set "SSHOPT=-o StrictHostKeyChecking=no -o ConnectTimeout=10"

set "IP="
set "USR="
if not exist "%BASE%config.bat" goto :nocfg
call "%BASE%config.bat"

if "%IP%"=="" goto :nocfg
if "%USR%"=="" goto :nocfg

echo %IP%|findstr /r /c:"^[0-9][0-9]*[.][0-9][0-9]*[.][0-9][0-9]*[.][0-9][0-9]*$" >nul
if errorlevel 1 goto :badip

rem ---- silent test: already key-based? then do nothing ----
ssh %SSHOPT% -o BatchMode=yes -o ConnectTimeout=8 %USR%@%IP% "exit 0" 2>"%TEMP%\w132d_ssh.txt"
if not errorlevel 1 goto :ok

findstr /i /c:"refused" /c:"timed out" /c:"unreachable" /c:"not resolve" /c:"no route" "%TEMP%\w132d_ssh.txt" >nul
if not errorlevel 1 goto :noconn

rem ---- reachable but no key yet ----
:mkkey
if not exist "%USERPROFILE%\.ssh" mkdir "%USERPROFILE%\.ssh" >nul 2>nul
type "%BASE%msg\c-start.txt"
type "%BASE%msg\c-keyintro.txt"
if exist "%USERPROFILE%\.ssh\id_ed25519.pub" goto :push
echo   generating local ssh key ...
ssh-keygen -t ed25519 -N "" -C "w132d" -f "%USERPROFILE%\.ssh\id_ed25519" >nul 2>nul

:push
if not exist "%USERPROFILE%\.ssh\id_ed25519.pub" goto :keyfail
type "%USERPROFILE%\.ssh\id_ed25519.pub" | ssh %SSHOPT% %USR%@%IP% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && tr -d '\r' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys"
if errorlevel 1 goto :keyfail

echo   setting up sudo without password ...
ssh -t %SSHOPT% %USR%@%IP% "echo '%USR% ALL=(ALL) NOPASSWD: ALL' > /tmp/w132d.sudo && sudo visudo -cf /tmp/w132d.sudo && sudo install -m 440 -o root -g root /tmp/w132d.sudo /etc/sudoers.d/w132d && rm -f /tmp/w132d.sudo && echo SUDO-OK"
goto :ok

:nocfg
type "%BASE%msg\c-nocfg.txt"
pause
exit /b 1

:badip
echo   IP = %IP%
type "%BASE%msg\c-badip.txt"
pause
exit /b 1

:noconn
type "%BASE%msg\c-noconn.txt"
echo   trying   ssh %USR%@%IP%
echo.
pause
exit /b 1

:keyfail
type "%BASE%msg\c-keyfail.txt"

:ok
exit /b 0
