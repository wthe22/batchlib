:entry_point
call %*
exit /b


:combi_wcdir [-f|-d] [-s] <return_var> <search_paths> <wildcard_paths>
setlocal EnableDelayedExpansion EnableExtensions
set "_list_dir=true"
set "_list_file=true"
set "_seperator="
call :argparse ^
    ^ "#1:store                     :_return_var" ^
    ^ "#2:store                     :_path1" ^
    ^ "#3:store                     :_path2" ^
    ^ "-s,--seperator:store         :_seperator_var" ^
    ^ "-f,--file:store_const        :_list_file=" ^
    ^ "-d,--directory:store_const   :_list_dir=" ^
    ^ -- %* || exit /b 2
call :capchar LF NL
for %%v in (_path1 _path2) do (
    set "%%v=!%%v:/=\!"
    set ^"%%v=!%%v:;=%NL%!^"
    set "_temp="
    for /f "tokens=* delims=" %%a in ("!%%v!") do (
        set "_is_listed="
        for /f "tokens=* delims=" %%b in ("!_temp!") do if "%%a" == "%%b" set "_is_listed=true"
        if not defined _is_listed set "_temp=!_temp!%%a!LF!"
    )
    set "%%v=!_temp!"
)
set "_found="
for /f "tokens=* delims=" %%a in ("!_path1!") do for /f "tokens=* delims=" %%b in ("!_path2!") do (
    set "_result="
    pushd "!tmp!"
    call :wcdir._find "%%a\%%b"
    set "_found=!_found!!_result!"
)
set "_result="
for /f "tokens=* delims=" %%a in ("!_found!") do (
    set "_is_listed="
    for /f "tokens=* delims=" %%b in ("!_result!") do if "%%a" == "%%b" set "_is_listed=true"
    if not defined _is_listed set "_result=!_result!%%a!LF!"
)
set "_result=::BEGIN::!LF!!_result!"
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
set "%~1install_requires=argparse wcdir capchar"
set "%~1extra_requires=Input.string"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      combi_wcdir - find files/folders that matches the wildcard paths
::                    within the search paths
::
::  SYNOPSIS
::      combi_wcdir [-f|-d] [-s] <return_var> <search_paths> <wildcard_paths>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the results. By default, each path is seperated
::          by a Line Feed (hex code '0A').
::
::      search_paths
::          String that contains the base paths of wildcard_paths, each seperated
::          by a semicolon ';'. May contain multiple wildcards.
::
::      wildcard_paths
::          String that contains the wildcard paths to find, each seperated by a
::          semicolon ';'. May contain multiple wildcards.
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
::  ENVIRONMENT
::      cd
::          Affects the base path of the search if the combination of
::          search path and wildcard path is a relative path.
::
::  NOTES
::      - Variables in path will not be expanded (e.g.: %appdata%).
exit /b 0


:doc.demo
call :capchar LF
call :Input.string search_paths || set "search_paths=C:\Windows\System32;C:\Windows\SysWOW64"
call :Input.string wildcard_paths || set "wildcard_paths=*script.exe"
call :combi_wcdir result "!search_paths!" "!wildcard_paths!" -s LF
echo=
echo Search paths:
echo !search_paths:;=^
%=REQUIRED=%
!
echo=
echo Wildcard paths:
echo !wildcard_paths:;=^
%=REQUIRED=%
!
echo=
echo Found List:
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
set "search_paths=C:\Windows\System32;C:\Windows\SysWOW64"
set "wildcard_paths=*script.exe"
call :combi_wcdir result "!search_paths!" "!wildcard_paths!"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:EOF
exit /b
