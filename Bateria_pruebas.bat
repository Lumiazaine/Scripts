::limpiar dns
ipconfig /flushdns

::log passwords previa
@echo off
cmdkey /list:>previa.txt


::Limpiar Temporales
del /q/f/s %TEMP%\*

::Limpiar Caché java
javac -cache-dir c:\temp\jws
javaws -clearcache
javaws -Xclearcache -silent -Xnosplash

::Limpiar Caché historial navegador
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1

:: Vaciar papelera reciclaje
rd /s /q %systemdrive%\$Recycle.bin 


::log passwords post
@echo off
cmdkey /list:>post.txt

::Check keys
fc previa.txt post.txt

::Actualizar directivas
gpupdate /force 

:: Reiniciar Equipo
shutdown /r /t 2
