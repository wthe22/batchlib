:entry_point > nul 2> nul
call %*
exit /b


:fnmatch <string> <pattern>
@setlocal EnableDelayedExpansion EnableExtensions
set "_string=%~1"
set "_pattern=%~2"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set "_last="
set "_parts="
set "_leftover=!_pattern!"
for /l %%n in (1,1,10) do if defined _leftover (
    for /f "tokens=1* delims=*" %%a in ("!_leftover!") do (
        set "_part="
        if "%%n" == "1" if not "!_pattern:~0,1!" == "*" set "_part=%%a"
        if not defined _part set "_part=*%%a"
        set "_parts=!_parts!!_part!!LF!"
        set "_leftover=%%b"
    )
)
set "_last=!_part:~1!"
set "_leftover=!_string!"
for /f "tokens=* delims=" %%p in ("!_parts!") do (
    if not defined _leftover exit /b 3
    set _leftover=!_leftover:%%p=^"!
    if not "!_leftover:~0,1!" == ^"^"^" exit /b 3
    set "_leftover=!_leftover:~1!"
)
if "!_pattern:~-1,1!" == "*" exit /b 0
if not defined _leftover exit /b 0
call :strlen _len _last
if not "!_leftover:~-%_len%!" == "!_last!" exit /b 3
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=strlen"
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
::      any string that ends with '.bat'. The comparison is case sensitive.
::
::  POSITIONAL ARGUMENTS
::      string
::          The string to check. Symbols that are not supported: ="^!
::
::      pattern
::          The pattern to match. The supported pattern is only wildcards '*'.
::          Supports up to 10 wildcards.
::
::  EXIT STATUS
::      0:  - Success.
::      3:  - String does not match pattern.
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


:tests.test_literal_match
call :tests.check_match "abc" "abc"
call :tests.check_match "" ""
exit /b 0


:tests.test_literal_unmatch
call :tests.check_unmatch "asd" "as"
call :tests.check_unmatch "asd" "sd"
call :tests.check_unmatch "asd" ""
call :tests.check_unmatch "" "asd"
exit /b 0


:tests.test_simple_match
call :tests.check_match "aabbcc" "*"
call :tests.check_match "aabbcc" "*bcc"
call :tests.check_match "aabbcc" "a*cc"
call :tests.check_match "aabbcc" "aab*"
exit /b 0


:tests.test_nongreedy_end_match
call :tests.check_match "abcccccccccccc" "ab*c"
call :tests.check_match "abcccccccccccc" "ab*cccccccc"
exit /b 0


:tests.test_nongreedy_end_unmatch
call :tests.check_unmatch "abccccccccccccd" "ab*c"
exit /b 0


:tests.test_simple_unmatch
call :tests.check_unmatch "a" "ab*"
call :tests.check_unmatch "abc" "a*b"
call :tests.check_unmatch "abc" "abc*abc"
exit /b 0


:tests.check_match <args>
call :fnmatch %* || (
    call %unittest% fail ^
        ^ "Given string '%~1' and pattern '%~2', expected success, got failure"
)
exit /b 0


:tests.check_unmatch <args>
call :fnmatch %* && (
    call %unittest% fail ^
        ^ "Given string '%~1' and pattern '%~2', unexpected success"
)
exit /b 0
