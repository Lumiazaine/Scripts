
:main
@ECHO off
cls
:main
ECHO ------------------------------------------
ECHO                  Mcgyver                
ECHO            Creado por David Luna
ECHO ------------------------------------------
ECHO 1. Bateria pruebas
ECHO 2. Reparar imagen corrupta sistema
ECHO 3. Otros
set choice=
set /p choice=Escoge una opcion:
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Bateria_pruebas
if '%choice%'=='2' goto Repair
if '%choice%'=='3' goto other
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:Bateria_pruebas
ECHO Batería de pruebas
ipconfig /flushdns
del %temp%\*.* /s /q
del C:\Windows\prefetch\*.*/s/q
cleanmgr /verylowdisk
cleanmgr /AUTOCLEAN
javac -cache-dir c:\temp\jws
javaws -clearcache
javaws -Xclearcache -silent -Xnosplash
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
gpupdate /force 
::shutdown /r /t 2
goto end
:Repair
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow
goto end
:other
-------------------------------------------------------------------------------------------


cls
:start1
ECHO ------------------------------------------
ECHO               Otras herrsamientas    
ECHO
ECHO ------------------------------------------
ECHO 1. Ver Key Windows
ECHO 2. Creador perfil de emergencia Thunderbird 
ECHO 3. inicio
set choice=
set /p choice=Escoge una opcion:
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto key
if '%choice%'=='2' goto Thunderbird
if '%choice%'=='3' goto main
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:key
@echo off
For /F "Tokens=*" %%a in ('wmic path softwarelicensingservice get OA3xOriginalProductKey ^|findstr /r "[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]-"') Do (set KEY=%%a)
echo CLAVE WINDOWS: [%KEY%]
pause
cls
:start1
cls
:Thunderbird
@echo off
echo ****** %date% %time%  *******> %temp%\crear_perfil_thunderbird.log
echo Comprobando fichero de configuración de ThunderBird >> %temp%\crear_perfil_thunderbird.log
if not exist  "%appdata%\ThunderBird\profiles.ini" goto no_existe_ini
rem En este punto vemos que ya existe un .ini en el perfil del usuario
echo *** Existe fichero de configuracion %appdata%\ThunderBird\profiles.ini >> %temp%\crear_perfil_thunderbird.log
echo Comprobando si apunta a c:\correo >> %temp%\crear_perfil_thunderbird.log
rem Si la ruta apunta a c:\correo dejamos el ini sin tocarlo
find /I "Path=C:\correo\profiles" "%appdata%\ThunderBird\profiles.ini" >> %temp%\crear_perfil_thunderbird.log
if %errorlevel%==0 goto sigue
rem en caso contrario renombramos el ini para crear uno nuevo
echo El fichero de configuracion no apunta a c:\correo, sino a >> %temp%\crear_perfil_thunderbird.log
find "Path=" "%appdata%\ThunderBird\profiles.ini" >> %temp%\crear_perfil_thunderbird.log
set old_ini=profiles_ini_%random%.txt
echo     moviendolo a %old_ini% >> %temp%\crear_perfil_thunderbird.log
ren "%appdata%\ThunderBird\profiles.ini" %old_ini% >> %temp%\crear_perfil_thunderbird.log
:no_existe_ini
echo Creando nuevo fichero de configuracion >> %temp%\crear_perfil_thunderbird.log

rem Por si no se ha iniciado nunca Thnderbird
mkdir "%appdata%\ThunderBird" > nul 2> nul

rem Creamos el ini
echo [General] >"%appdata%\ThunderBird\profiles.ini"
echo StartWithLastProfile=1>>"%appdata%\ThunderBird\profiles.ini"

echo [Profile0] >>"%appdata%\ThunderBird\profiles.ini"
echo Name=%username%>>"%appdata%\ThunderBird\profiles.ini"
echo IsRelative=0 >>"%appdata%\ThunderBird\profiles.ini"
echo Path=C:\correo\profiles\%username%>>"%appdata%\ThunderBird\profiles.ini"
echo default=1 >>"%appdata%\ThunderBird\profiles.ini"

:sigue
echo ----------  >> %temp%\crear_perfil_thunderbird.log
echo Comprobando perfil de ThunderBird >> %temp%\crear_perfil_thunderbird.log
if exist C:\correo\profiles\%username% goto existe_perfil
echo Creando perfil C:\correo\profiles\%username% >> %temp%\crear_perfil_thunderbird.log
rem Por si no se ha iniciado nunca Thnderbird
mkdir "C:\correo\profiles" > nul 2> nul
REM ACLARAR QUE PASA CUANDO NO TIENE EMAIL
rem Pasado a dentro del kix: xcopy /s /y /I "%~dp0perfil_defecto" C:\correo\profiles\%username% > nul 2> nul
if not ""%cadfile% == "" goto cadfile_ok
echo Script no lanzado desde el inicio de sesion >> %temp%\crear_perfil_thunderbird.log
set cadFile=%TEMP%\cad%random%.txt >> %temp%\crear_perfil_thunderbird.log
copy /y \\se41\script$\comun\kixtart\wget.exe %temp% >> %temp%\crear_perfil_thunderbird.log
copy /y \\se41\script$\comun\kixtart\libeay32.dll %temp% >> %temp%\crear_perfil_thunderbird.log
copy /y \\se41\script$\comun\kixtart\ssleay32.dll %temp% >> %temp%\crear_perfil_thunderbird.log
rem copy \\se41\script$\comun\kixtart\*.dll %temp%
set wget=%temp%\wget.exe
%temp%\wget.exe http://huvrweb.dmsas.sda.sas.junta-andalucia.es/wacu/inicio.aspx?usuario=%username% --output-document=%cadfile% -q
:cadfile_ok
rem Luego habra que añadir el /i al wkix32 para que no se vea la creacion de perfil
start "Perfil Thunderbird" "\\se41\script$\comun\kixtart\kix32.exe" /i "\\se41\sti\software\Aplicaciones Hospitalarias HUVR\ThunderBird\Otros\crear_perfil_thunderbird.kix" $usuario=%username% $RUTA=%RUTA% $wget=%wget%  $cadfile=%cadfile% $perfil_defecto="%~dp0perfil_defecto" $log=%temp%\crear_perfil_thunderbird.log /f 
goto fin
:existe_perfil
echo *** Existe ya un perfil en C:\correo\profiles\%username%... saliendo >> %temp%\crear_perfil_thunderbird.log
echo ******  ******* >> %temp%\crear_perfil_thunderbird.log
:start1

-------------------------------------------------------------------------------------------
ECHO TEST
goto end
:end
pause