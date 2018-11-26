@echo off

SET MSBUILD="C:\Program Files (x86)\MSBuild\14.0\bin\MSBuild.exe"
SET RSVARS="C:\Program Files (x86)\Embarcadero\Studio\19.0\bin\rsvars.bat"
SET PROJECT="C:\src\github\felipecaputo\delphi-amqp\DelphiAMQP.dproj"

call %RSVARS%
%MSBUILD% %PROJECT% "/t:Clean,Make" "/verbosity:minimal"

if %ERRORLEVEL% NEQ 0 GOTO END

echo. 

if "%1"=="" goto END

if /i %1%==test (
  pushd "C:\src\github\felipecaputo\delphi-amqp\Win32\Debug"
  "C:\src\github\felipecaputo\delphi-amqp\Win32\Debug\DelphiAMQP.exe" 
  popd
)
:END
