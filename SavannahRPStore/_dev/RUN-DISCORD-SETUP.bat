@echo off
title Savannah RP - Discord Setup
echo.
echo   Savannah RP - Discord server builder
echo   ------------------------------------
echo   This creates the roles, categories and channels in your Discord.
echo   It only ADDS - it never deletes anything.
echo.
echo   You need a BOT TOKEN and your SERVER ID.
echo   (Instructions are at the top of discord-setup.ps1 and in DISCORD-SETUP.md)
echo.
pause
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0discord-setup.ps1"
echo.
pause
