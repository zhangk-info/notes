@echo off
:: %1 -- The first Parameter

:start
tasklist|findstr -i "v2rayN.exe"
if ERRORLEVEL 1 (goto err) else (goto continue)
 
:err
echo v2rayN.exe not ok.
@REM 延时5s
choice /t 5 /d y /n >nul
goto :start
 
:continue
echo .
echo .
echo .
echo .
wmic process where "name='v2rayN.exe'" call setpriority "high priority"
wmic process where "name='xray.exe'" call setpriority "high priority"
echo .
echo .
echo .
echo .
echo v2rayN.exe is ok.
choice /t 5 /d y /n >nul
@REM