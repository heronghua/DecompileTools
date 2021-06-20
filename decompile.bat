::set environment

@if "%DEBUG%"=="" @echo off

setlocal

set OUTPUT=%cd%/output

set APK_TOOL_JAR=%~dp0/apktool_2.5.0.jar
set DEX2JAR=%~dp0/dex2jar-2.0/d2j-dex2jar.bat
set JD_GUI=%~dp0/jd-gui.exe
set HAO_ZIPC=HaoZipC


java -jar %APK_TOOL_JAR% d -f %1 -o %OUTPUT%

:: extract dex files from apk 
%HAO_ZIPC% e %1 -o%OUTPUT%/dexes/ *.dex


::convert dex files to jar
for %%A in ("%OUTPUT%\dexes"\*.dex) do (
	:: getLastPart of parameter A "%%~nxA"
	call %DEX2JAR% %%A -o %OUTPUT%/outputJars/"%%~nxA".jar
)

echo %1 decompiled classes to file://%OUTPUT%/outputJars/*.jar

set /p choice= Do you want to open jd-gui right now?(Y/N)
if "%choice%"=="Y" call  %JD_GUI% &

endlocal


