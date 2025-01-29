:entry_point
call %*
exit /b


:combi_wcdir [-f|-d] [-s] <return_var> <first_parts> <second_parts>
setlocal EnableDelayedExpansion EnableExtensions
set "_list_dir=true"
set "_list_file=true"
set "_seperator="
call :argparse --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "first_parts:             set _path1" ^
    ^ "second_parts:            set _path2" ^
    ^ "[-s,--seperator VAR]:    set _seperator_var" ^
    ^ "[-f,--file]:             set _list_file=" ^
    ^ "[-d,--directory]:        set _list_dir=" ^
    ^ -- %* || exit /b 2
call :capchar LF NL
for %%v in (_path1 _path2) do (
    set "%%v=!%%v:/=\!"
    set %%v=!%%v:;=%NL%!
)
call :list_lf2set _path1 _path1
call :list_lf2set _path2 _path2
set "_found="
for /f "tokens=* delims=" %%a in ("!_path1!") do for /f "tokens=* delims=" %%b in ("!_path2!") do (
    set "_result="
    pushd "!tmp!"
    call :wcdir._find "%%a\%%b"
    set "_found=!_found!!_result!"
)
set "_result=::BEGIN::!LF!!_found!"
for /f "tokens=* delims=" %%r in ("!_result!") do (
    if "%%r" == "::BEGIN::" (
        endlocal
        set "%_return_var%="
    ) else (
        if "%_seperator_var%" == "" (
            set "%_return_var%=!%_return_var%!%%r;"
        ) else set "%_return_var%=!%_return_var%!%%r!%_seperator_var%!"
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=list_lf2set argparse wcdir capchar"
set "%~1extra_requires=input_string"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      combi_wcdir - find files within a combination of paths
::
::  SYNOPSIS
::      combi_wcdir [-f|-d] [-s] <return_var> <first_parts> <second_parts>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the results. By default, each path is seperated
::          by a Line Feed (hex code '0A').
::
::      first_parts
::          The list of paths for the first part, each seperated by a semicolon.
::          May contain multiple wildcards.
::
::      second_parts
::          The list of paths for the second part, each seperated by a semicolon.
::           May contain multiple wildcards.
::
::  OPTIONS
::      -f, --file
::          Search for file only.
::
::      -d, --directory
::          Search for directory only.
::
::      -s CHAR_VAR, --seperator CHAR_VAR
::          Use value stored in CHAR_VAR instead of semicolon to seperate results.
::
::  NOTES
::      - Variables in path will not be expanded (e.g.: %appdata%).
exit /b 0


:doc.demo
call :capchar LF
call :input_string first_parts || set "first_parts=C:\Windows\System32;C:\Windows\SysWOW64"
call :input_string second_parts || set "second_parts=*script.exe"
call :combi_wcdir result "!first_parts!" "!second_parts!" -s LF
echo=
echo First parts of path:
echo !first_parts:;=^
%=REQUIRED=%
!
echo=
echo Second parts of path:
echo !second_parts:;=^
%=REQUIRED=%
!
echo=
echo Combination of paths found:
echo=!result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_demo
set "expected="
for %%d in (
    "C:\Windows\System32"
    "C:\Windows\SysWOW64"
) do if exist %%d for %%f in ("%%~d\*script.exe") do (
    set "expected=!expected!%%~ff;"
)
if not defined expected (
    call %unittest% skip "No file with matching pattern found to run test"
    exit /b 0
)
set "first_parts=C:\Windows\System32;C:\Windows\SysWOW64"
set "second_parts=*script.exe"
call :combi_wcdir result "!first_parts!" "!second_parts!"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:EOF
exit /b
