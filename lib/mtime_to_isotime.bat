:entry_point
call %*
exit /b


:mtime_to_isotime <return_var> <mtime>
setlocal EnableDelayedExpansion
set "_mtime=%~2"
set "_return_var=%~1"
set "_r=!_mtime!"
set "_r=!_r:~6,4!-!_r:~0,2!-!_r:~3,2!T!_r:~17,2!!_r:~11,2!:!_r:~14,2!"
set "_tmp=!_r:~11,4!"
for %%r in ("M12=M00" "M0=M" "AM=" "PM=12+") do set "_tmp=!_tmp:%%~r!"
set /a "_tmp=!_tmp!"
set "_tmp=0!_tmp!"
set "_r=!_r:~0,11!!_tmp:~-2,2!!_r:~15!"
for /f "tokens=1* delims=:" %%q in ("Q:!_r!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.path"
set "%~1category=time file"
exit /b 0


:doc.man
::  NAME
::      mtime_to_isotime - convert modification timestamp to iso time format
::
::  SYNOPSIS
::      mtime_to_isotime <return_var> <mtime>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      mtime
::          Modification time of file. The format is 'mm/dd/YYYY HH:MM <AM/PM>' or
::          '%m/%d/%Y %I:%M %p' in terms of format code. This can be obtained from
::          running the following command:
::              FOR %I in (<file>) do echo %~tI
exit /b 0


:doc.demo
call :Input.path file --exist --optional || set "file=%~f0"
set "mtime="
for %%f in ("!file!") do set "mtime=%%~tf"
call :mtime_to_isotime isotime "!mtime!"
echo=
echo File   : !file!
echo Modification time  : !mtime!
echo ISO formatted time : !isotime!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_convert_hour
for %%a in (
    "2021-04-30T09:55=04/30/2021 09:55 AM"
    "2021-04-30T10:55=04/30/2021 10:55 AM"
    "2021-04-30T00:55=04/30/2021 12:55 AM"
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "expected=%%b"
    call :mtime_to_isotime result "%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
