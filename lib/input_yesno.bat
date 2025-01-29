:entry_point
call %*
exit /b


:input_yesno [-m message] [-y value] [-n value] [-d value] [return_var]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_return_var _message) do set "%%v="
set "_yes_value=Y"
set "_no_value=N"
call :argparse --name %0 ^
    ^ "[return_var]:            set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-y,--yes VALUE]:        set _yes_value" ^
    ^ "[-n,--no VALUE]:         set _no_value" ^
    ^ "[-d,--default VALUE]:    set _default" ^
    ^ -- %* || exit /b 2
if not defined _message set "_message=Input !_return_var!? [y/n] "
call :input_yesno._loop || exit /b 4
set "_result="
if /i "!user_input:~0,1!" == "Y" set "_result=!_yes_value!"
if /i "!user_input:~0,1!" == "N" set "_result=!_no_value!"
for /f "tokens=* delims= eol=" %%r in ("_!_result!") do (
    endlocal
    if not "%_return_var%" == "" (
        set "%_return_var%=%%r"
        set "%_return_var%=!%_return_var%:~1!"
    )
    if /i "%user_input:~0,1%" == "Y" exit /b 0
    if /i "%user_input:~0,1%" == "N" exit /b 5
)
exit /b 1
#+++

:input_yesno._loop
for /l %%# in (1,1,10) do for /l %%# in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined _default (
        if not defined user_input set "user_input=!_default!"
    )
    if /i "!user_input:~0,1!" == "Y" exit /b 0
    if /i "!user_input:~0,1!" == "N" exit /b 0
)
echo%0: Too many invalid inputs
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse"
set "%~1category=ui"
exit /b 0


:doc.man
::  NAME
::      input_yesno - read a yes/no from standard input
::
::  SYNOPSIS
::      input_yesno [-m message] [-y value] [-n value] [-d value] [return_var]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  OPTIONS
::      -m MESSAGE, --message MESSAGE
::          Use MESSAGE as the prompt message.
::          By default, the message is generated automatically.
::
::      -y VALUE, --yes VALUE
::          Returns VALUE if the user enters any string that starts with 'Y'.
::          By default, it is 'Y'.
::
::      -n VALUE, --no VALUE
::          Returns VALUE if the user enters any string that starts with 'N'.
::          By default, it is 'N'.
::
::      -d VALUE, --default VALUE
::          Assume user enters VALUE if the user does not enter anything.
::
::  EXIT STATUS
::      0:  - User enters any string that starts with 'Y'.
::      2:  - Invalid argument.
::      4:  - Too many invalid inputs (100 attempts).
::      5:  - User enters any string that starts with 'N'.
exit /b 0


:doc.demo
call :input_yesno your_ans --message "Do you like programming? Y/N? " && (
    echo Its a yes^^!
) || echo Its a no...
echo Your input: !your_ans!
echo=
call :input_yesno your_ans --message "Is it true? Y/N? " --yes "true" --no "false"
echo Your input ('true', 'false'): '!your_ans!'
echo=
call :input_yesno your_ans --message "Do you excercise? [y/N] " --default="N"
echo Your input ('Y', 'N', default 'N'): '!your_ans!'
echo=
call :input_yesno your_ans --message "Is this defined? Y/N? " -y="yes" -n=""
echo Your input ('yes', ''): '!your_ans!'
exit /b 0


:tests.setup
> "enter_y" (
    echo y
)
> "enter_n" (
    echo n
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_input
for %%a in (
    "Y: y n"
    "Y: Y n"
    "Y: yes n"
    "Y: yea n"
    "N: n y"
    "N: N y"
    "N: no y"
    "N: nah y"
    "Y: a bn y n"
    "N: a by n y"
    "Y: LF y n"
    "N: LF n y"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do (
            if "%%i" == "LF" (
                echo=
            ) else echo %%i
        )
    )
    call :input_yesno result < "input" > nul
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_errorlevel
for %%a in (
    "0: y n"
    "5: n y"
    "0: LF y n"
    "4: LF"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do (
            if "%%i" == "LF" (
                echo=
            ) else echo %%i
        )
    )
    call :input_yesno result < "input" > nul
    set "result=!errorlevel!"
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_null_value
for %%a in (y n) do (
    set "result=a"
    call :input_yesno -%%a "" result < "enter_%%a" > nul
    set "expected="
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%a', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_default_value
for %%a in (
    "0:Y:y"
    "5:N:n"
) do for /f "tokens=1-3 delims=:" %%b in (%%a) do (
    call :input_yesno --default "%%d" value < nul > nul
    set "result=!errorlevel!"
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%d', expected value '!expected!', got '!result!'"
    )
    set "result=!value!"
    set "expected=%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%d', expected errorlevel '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
