:entry_point > nul 2> nul
call %*
exit /b


:fnmatch <string> <pattern>
@setlocal EnableDelayedExpansion EnableExtensions
set "_string=%~1"
set "_pattern=%~2"
set "_parts="
set "_leftover=:!_pattern!:"
for /l %%n in (1,1,10) do if defined _leftover (
    for /f "tokens=1* delims=*" %%a in ("!_leftover!") do (
        set _parts=!_parts! "%%a"
        set "_leftover=%%b"
    )
)
set "_leftover=:!_string!:"
set "_match=true"
for %%p in (!_parts!) do if defined _match (
    set "_leftover=!_leftover:*%%~p= !"
    if not "!_leftover:~0,1!" == " " set "_match="
    set "_leftover=!_leftover:~1!"
)
if not defined _match exit /b 3
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      fnmatch - filename-style string pattern matching
::
::  SYNOPSIS
::      fnmatch <string> <pattern>
::
::  DESCRIPTION
::      Match string with filename-style wildcards. For example, '*.bat' matches
::      any string that ends with '.bat'.
::
::  POSITIONAL ARGUMENTS
::      string
::          The string to check.
::
::      pattern
::          The pattern to match. Supported pattern is only wildcards '*'.
::          Supports up to 10 wildcards.
exit /b 0


:doc.demo
call :Input.string pattern || set "pattern=*.bat"
call :Input.string string || set "string=batchlib.bat"
echo=
call :fnmatch "!pattern!" "!string!" && (
    echo String matches pattern
) else echo String does not match pattern
exit /b 0


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.test_match_without_pattern
call :tests.check_match "test" "test"
call :tests.check_match ":test" ":test"
call :tests.check_match "test:" "test:"
exit /b 0


:tests.test_not_match_without_pattern
call :tests.check_not_match "test:" "test"
call :tests.check_not_match ":test" "test"
call :tests.check_not_match "test" ":test"
call :tests.check_not_match "test" "test:"
exit /b 0


:tests.test_match_string
call :tests.check_match "helloooo" "hell*"
call :tests.check_match "helloooo" "hel*o"
call :tests.check_match "hheeello" "*ello"
call :tests.check_match "test.test:.test" "test*.test*"
exit /b 0


:tests.test_not_match_string
call :tests.check_not_match "holla" "h*ll*o"
exit /b 0


:tests.test_match_label
call :tests.check_match "tests.test_something" "test*.test*"
call :tests.check_match ":tests.test_something" ":test*.test*"
exit /b 0


:tests.test_match_filename
call :tests.check_match "a.bat" "*.bat"
call :tests.check_match "batchlib-1000.bat" "batchlib-*.bat"
exit /b 0


:tests.check_match <args>
call :fnmatch %* || (
    call %unittest% fail ^
        ^ "Given string '%~1' and pattern '%~2', expected success, got failure"
)
exit /b 0


:tests.check_not_match <args>
call :fnmatch %* && (
    call %unittest% fail ^
        ^ "Given string '%~1' and pattern '%~2', unexpected success"
)
exit /b 0
