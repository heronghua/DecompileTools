::set environment

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  Decompile script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set OUTPUT=%cd%/output

@rem With apk tool you can decode resouces files such as AndroidManifest.xml and resources.arsc
@rem if Brand modified frameworks you can install frameworks by command apktool if/install-framework <framework.apk> before use this script

set APK_TOOL_JAR=%~dp0/apktool_2.5.0.jar

@rem You can use gradle to build latest dex2jar tools from 
@rem https://github.com/pxb1988/dex2jar
@rem After assemble ,you can find tools under dex2jar-2.x\dex-tools\build\distributions
set DEX2JAR=%~dp0/dex2jar-2.0/d2j-dex2jar.bat

set JD_GUI=%~dp0/jd-gui.exe


@rem extract classes
java -jar %APK_TOOL_JAR% d -f %1 -o %OUTPUT%
if "%ERRORLEVEL%" == "0" goto extractDexFromApk
echo apkTool decode apk failed
goto fail

:extractDexFromApk
call extractCompressFileImpl.bat %1 *.dex "%OUTPUT%"/dexes/
if "%ERRORLEVEL%" == "0" goto convertDexFilesToJars
echo extract dex file failed

:convertDexFilesToJars
for %%A in ("%OUTPUT%\dexes"\*.dex) do (
	:: getLastPart of parameter A "%%~nxA"
	call %DEX2JAR% %%A -o %OUTPUT%/outputJars/"%%~nxA".jar
)

echo %1 decompiled classes to file://%OUTPUT%/outputJars/*.jar

set /p choice= Do you want to open jd-gui right now?(Y/N)
if "%choice%"=="Y" goto openJarsWithJDGUI 
goto mainEnd

:openJarsWithJDGUI
set JP=
for %%X in ("%OUTPUT%"\outputJars\*.jar) do (
    set JP=%JP% %%X
)
echo "%JP%"
call  %JD_GUI% %JP% &
goto mainEnd

:fail
pause>nul
exit /b 1


:mainEnd
if "%OS%"=="Windows_NT" endlocal




