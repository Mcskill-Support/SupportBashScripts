@echo off
:: Set UTF-8 code page
chcp 65001 > nul

:: Define log file variable
set "LOGFILE=network_report.log"

:: Clear (or create) the log file
type nul > "%LOGFILE%"

:: --- Network Settings ---
echo [*] Getting network configuration...
echo =================================================== NETWORK SETTINGS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-NetIPConfiguration | Format-Table -AutoSize | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"


echo [*] Getting network information...
echo =================================================== NETWORK =================================================== >> %LOGFILE%
powershell -Command "Invoke-RestMethod -Uri https://api.2ip.me/provider.json?ip= -Method Get | ForEach-Object { [PSCustomObject]@{IP = $_.ip; Name = $_.name_rus; Ripe = $_.name_ripe; Site = $_.site} } | Out-File -FilePath %LOGFILE% -Append -Encoding UTF8"


set HOST=s1.mcskill.net
echo [*] Pinging "%HOST%"...
echo =================================================== PING %HOST% =================================================== >> %LOGFILE%
ping %HOST% >> %LOGFILE%
echo [*] Tracing "%HOST%"...
echo =================================================== TRACE %HOST% =================================================== >> %LOGFILE%
tracert %HOST% >> %LOGFILE%

set HOST=t1.mcskill.net
echo [*] Pinging "%HOST%"...
echo =================================================== PING %HOST% =================================================== >> %LOGFILE%
ping %HOST% >> %LOGFILE%
echo [*] Tracing "%HOST%"...
echo =================================================== TRACE %HOST% =================================================== >> %LOGFILE%
tracert %HOST% >> %LOGFILE%

set HOST=tcpshield.net
echo [*] Pinging "%HOST%"...
echo =================================================== PING %HOST% =================================================== >> %LOGFILE%
ping %HOST% >> %LOGFILE%
echo [*] Tracing "%HOST%"...
echo =================================================== TRACE %HOST% =================================================== >> %LOGFILE%
tracert %HOST% >> %LOGFILE%


echo ======================================================================
echo [*] Report saved in "%LOGFILE%"
pause
