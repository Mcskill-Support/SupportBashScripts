@echo off
:: Set UTF-8 code page
chcp 65001 > nul

:: Define log file variable
set "LOGFILE=system_report.log"

:: Clear (or create) the log file
type nul > "%LOGFILE%"

:: --- CPU Information ---
echo [*] Getting CPU information...
echo =================================================== CPU DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Select-Object Name | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- GPU Information ---
echo [*] Getting GPU information...
echo =================================================== GPU DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Select-Object Caption, DriverVersion | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- RAM Information ---
echo [*] Getting RAM information...
echo =================================================== RAM DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "[PSCustomObject]@{'Total (GB)' = ([Math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB))} | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Swap Information ---
echo [*] Getting Swap (PageFile) information...
echo =================================================== SWAP DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_PageFileUsage | ForEach-Object { [PSCustomObject]@{Name = $_.Name; 'Allocated (MB)' = [Math]::Round($_.AllocatedBaseSize / 1MB, 2); 'Used (MB)' = [Math]::Round($_.CurrentUsage / 1MB, 2)}} | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Operating System Information ---
echo [*] Getting OS information...
echo =================================================== OS DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- User Information ---
echo [*] Getting user information...
echo =================================================== USER DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "[PSCustomObject]@{Name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[1]; Home = $Home} | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Java Version ---
echo [*] Checking Java version...
echo =================================================== JAVA VERSION =================================================== >> "%LOGFILE%"
echo. >> "%LOGFILE%"
java -version >> "%LOGFILE%" 2>&1
echo. >> "%LOGFILE%"
echo. >> "%LOGFILE%"

:: --- JAVA_HOME Environment Variable ---
echo [*] Getting JAVA_HOME environment variable...
echo =================================================== JAVA_HOME =================================================== >> "%LOGFILE%"
if defined JAVA_HOME (
    echo JAVA_HOME = %JAVA_HOME% >> "%LOGFILE%"
) else (
    echo JAVA_HOME is not set. >> "%LOGFILE%"
)

:: --- Disk Drives Information ---
echo [*] Getting disk drive information...
echo =================================================== DISK DRIVE DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, FileSystem, @{Name='FreeSpace(GB)';Expression={[math]::Round($_.FreeSpace/1GB,2)}}, @{Name='Size(GB)';Expression={[math]::Round($_.Size/1GB,2)}} | Format-Table -AutoSize | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Network Settings ---
echo [*] Getting network configuration...
echo =================================================== NETWORK SETTINGS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-NetIPConfiguration | Format-Table -AutoSize | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Motherboard Information ---
echo [*] Getting motherboard information...
echo =================================================== MOTHERBOARD DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product, Version, SerialNumber | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Running Services ---
echo [*] Getting running services...
echo =================================================== SERVICES STATUS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-Service | Format-Table Name, Status, DisplayName -AutoSize | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Drivers Information ---
echo [*] Getting drivers information...
echo =================================================== DRIVERS DETAILS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-CimInstance Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, Manufacturer | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Programs with GUI ---
echo [*] Getting list of active GUI programs...
echo =================================================== ACTIVE APPLICATIONS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-Process | Where-Object {$_.MainWindowTitle} | Format-Table Name, MainWindowTitle | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Installed Applications ---
echo [*] Getting list of installed applications...
echo =================================================== INSTALLED APPLICATIONS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Process List ---
echo [*] Getting unique process names...
echo =================================================== PROCESS LIST =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "(Get-Process | Select-Object).Name | Sort-Object -Unique | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Event Logs Summary ---
echo [*] Getting recent system event logs...
echo =================================================== EVENT LOGS SUMMARY =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "Get-EventLog -LogName System -Newest 10 | Format-Table -AutoSize | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

:: --- Regional and Locale Settings ---
echo [*] Getting regional and locale settings...
echo =================================================== REGIONAL AND LOCALE SETTINGS =================================================== >> "%LOGFILE%"
powershell -NoProfile -Command "[System.Globalization.CultureInfo]::CurrentCulture | Format-List * | Out-File -FilePath \"%LOGFILE%\" -Append -Encoding UTF8"

echo =======================================
echo [*] Report saved in "%LOGFILE%"
pause
