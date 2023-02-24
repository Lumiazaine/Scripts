DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow
ipconfig /flushdns
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
del /q/f/s %TEMP%\*
del /f /s /q %windir%\prefetch\*.* & rd /s /q %windir%\temp & md %windir%\temp
cleanmgr /AUTOCLEAN
cleanmgr /verylowdisk
javac -cache-dir c:\temp\jws
javaws -clearcache
javaws -Xclearcache -silent -Xnosplash
rd /s /q %systemdrive%\$Recycle.bin 
gpupdate /force 
shutdown /r /t 2