:entry_point > nul 2> nul
call %*
exit /b


:functions.match <return_var> <input_file> <pattern>
setlocal EnableDelayedExpansion EnableExtensions
set "_return_var=%~1"
set "_input_file=%~f2"
set "_pattern=%~3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions.list "!_input_file!" > ".functions.match._tokens" 2> nul || exit /b 2
for /f "usebackq tokens=*" %%l in (".functions.match._tokens") do (
    call :fnmatch "%%l" "!_pattern!" && set "_result=!_result! %%l"
)
for /f "tokens=1* delims= " %%q in ("Q !_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 3
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=functions.list fnmatch"
set "%~1extra_requires=Input.string Input.path capchar"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      functions.match - find labels that matches the specified pattern
::
::  SYNOPSIS
::      functions.match <return_var> <input_file> <pattern>
::
::  DESCRIPTION
::      Find all labels that matches the pattern in the input file.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the results, each seperated by space.
::
::  OPTIONS
::      -p PATTERN, --pattern PATTERN
::          Pattern of the function label to match. Supports up to 10 wildcards '*'.
::          It uses path pattern matching sytle. By default, it is '*'.
::
::      -f INPUT_FILE, --file INPUT_FILE
::          Path of the input file. By default, it is the current file.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file if relative path is given.
::
::      tmp_dir
::          Path to store the temporary results.
::
::      tmp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Label is found.
::      2:  - Cannot open input file.
::      3:  - Label is not found.
::
::  NOTES
::      - The label of the function MUST only be preceeded by either nothing or
::        spaces (i.e. only space indentation is allowed)
::      - Does not support labels that have:
::          - '^' or '*' in label name
::      - Only Windows EOL is supported.
exit /b 0


:doc.demo
call :Input.path input_file --file --exist
call :Input.string pattern || set "pattern=l*e*"
echo=
echo Input file : !input_file!
echo Pattern    : !pattern!
call :functions.match label_match "!input_file!" "!pattern!"
echo=
echo Found match:
set "match_count=0"
for %%l in (!label_match!) do (
    set /a "match_count+=1"
    set "match_count=   !match_count!"
    set "match_count=!match_count:~-3,3!"
    echo !match_count!. %%l
)
exit /b 0


:tests.setup
set "return.found=0"
set "return.not_found=3"
call :capchar LF
> "pattern_basic" (
    echo=call %*
    echo exit /b
    echo=
    echo :
    echo :scripts.main
    echo :scripts.call
    echo :hello
    echo :hi
    echo :howdy
    echo ::comment
)
> "for_unittest" (
    echo :tests.test_
    echo :tests.test_single_dot
    echo :tests..test_double_dot
    echo :tests.test_1
    echo :tests.test_1.prepare
    echo :tests.part.test_1
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_match
set test_cases= ^
    ^ 5:*!LF!^
    ^ 0:*z*!LF!^
    ^ 1:*e*!LF!^
    ^ 3:*i*!LF!^
    ^ 2:h*o*!LF!^
    ^ 2:scripts.*!LF!^
    ^ %=end=%
for /f "tokens=1* delims=: " %%a in ("!test_cases!") do (
    set "given=%%b"
    set "expected=%%a"
    call :functions.match labels "pattern_basic" "!given!"
    set "result=0"
    for %%l in (!labels!) do set /a "result+=1"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_errorlevel
for %%t in (
    "found: hello"
    "not_found: ola"
) do for /f "tokens=1* delims=: " %%a in (%%t) do (
    set "given=%%b"
    call :functions.match labels "pattern_basic" "!given!"
    set "result=!errorlevel!"
    set "expected=!return.%%a!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests._test_for_unittest
rem TODO: Make pattern for unittest labels
set "expected=4"
call :functions.match labels "for_unittest" "tests*.test_*"
set "result=0"
for %%l in (!labels!) do set /a "result+=1"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:EOF  # End of File
exit /b
