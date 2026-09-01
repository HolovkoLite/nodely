@echo off
title Pubblicazione Mappe Nodely

set "CARTELLA_MAPPE=%~dp0"
set "CARTELLA_MAPPE=%CARTELLA_MAPPE:~0,-1%"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\Documents\Varie\Mappe Nodely\pubblica-mappe.ps1" -Sorgente "%CARTELLA_MAPPE%"

echo.
echo ------------------------------------------------------------
echo Premi un tasto per chiudere questa finestra.
echo ------------------------------------------------------------
pause >nul