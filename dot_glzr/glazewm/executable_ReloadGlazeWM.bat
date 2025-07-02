@echo off

glazewm command wm-exit

:waitloop
tasklist /FI "IMAGENAME eq glazewm.exe" | find /I "glazewm.exe" >nul
if not errorlevel 1 (
    timeout /t 1 >nul
    goto waitloop
)

glazewm
