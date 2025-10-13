:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_path"
set "%~1categories=file"
exit /b 0


:diffbin <return_var> <input_file1> <input_file2>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_file1=%~f2"
set "_file2=%~f3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "_result="
fc /b "!_file1!" "!_file2!" > ".diffbin._fc_diff"
for /f "usebackq skip=1 tokens=1* delims=:" %%a in (".diffbin._fc_diff") do (
    if not defined _result (
        set "_result=%%a: %%b"
        if /i "%%a" == "FC" (
            if /i "%%b" == " !_file1! longer than !_file2!" set "_result=-1"
            if /i "%%b" == " !_file2! longer than !_file1!" set "_result=-2"
            if /i "%%b" == " no differences encountered" set "_result=-"
        ) else set /a "_result=0x%%a"
    )
)
del /f /q ".diffbin._fc_diff"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:doc.man
::  NAME
::      diffbin - get the offset of the first difference between two files
::
::  SYNOPSIS
::      diffbin <return_var> <input_file1> <input_file2>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result (in bytes).
::
::      input_file
::          Path of the input file.
::
::  ENVIRONMENT
::      This function uses:
::      - Temporary files
::
::      Global variables that affects this function:
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
exit /b 0


:doc.demo
call :input_path --exist --file file1
call :input_path --exist --file file2
echo=
call :diffbin offset "!file1!" "!file2!"
echo=
if "!offset:~0,1!" == "-" (
    if "!offset!" == "-" echo Both files are the same
    if "!offset!" == "-1" echo No content difference, but file 1 is longer
    if "!offset!" == "-2" echo No content difference, but file 2 is longer
) else set /a "!offset!" 2> nul && (
        echo First difference at offset !offset! bytes
) || echo unknown result: !offset!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
< nul set /p "=planet" > "source"
< nul set /p "=plan" > "shorter"
< nul set /p "=planet" > "equal"
< nul set /p "=planetarium" > "longer"
< nul set /p "=plants" > "different"

for %%a in (
    "-:     equal"
    "-1:    shorter"
    "-2:    longer"
    "4:    different"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :diffbin result source %%c
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
