@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  uncompress script for Windows
@rem  usage extrCompressFileImpl.bat compressedFile.zip regexToMatch destDir
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set HAO_ZIPC=HaoZipC
set URAR=WinRaR.exe

::init output 
if not exist %3 mkdir %3
del %3%2 > nul 2>&1


::jar -xf %1 %2 %3
::if "%ERRORLEVEL%" == "0" goto mainEnd
::echo Warning extract file with jar failed
goto extractDexFromApkByHaoZip


:extractDexFromApkByHaoZip
%HAO_ZIPC% e %1 -o%3 %2
if "%ERRORLEVEL%" == "0" goto mainEnd
echo Warning ,you do not install HaoZip
goto extractDexFromApkByRar

:extractDexFromApkByRar
%URAR% x %1 %2 %3
if "%ERRORLEVEL%" == "0" goto mainEnd
echo Error , you neither installed zip nor rar
goto fail



:fail
exit /b 1


:mainEnd
if "%OS%"=="Windows_NT" endlocal