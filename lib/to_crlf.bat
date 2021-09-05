:entry_point
call %*
exit /b


:to_crlf <input_file>
:to_crlf.alt1
:to_crlf.alt2
for %%f in (-c, --check-exist) do if /i ^"%1^" == "%%f" exit /b 0
if not exist "%~f1" ( 1>&2 echo%0: File not found & exit /b 2 )
type "%~f1" 2> nul | more /t4 > "%~f1.tmp" && (
    move /y "%~f1.tmp" "%~f1" > nul && exit /b 0
)
1>&2 echo%0: Convert EOL failed
exit /b 3


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=is_crlf"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      to_crlf - convert EOL from LF to CRLF
::
::  SYNOPSIS
::      to_crlf <input_file>
::      to_crlf.alt1 <input_file>
::      to_crlf.alt2 <input_file>
::
::  EXIT STATUS
::      0:  - EOL conversion is successful.
::      3:  - File not found.
::      3:  - EOL conversion failed.
::
::  NOTES
::      - Tabs are converted to 4 spaces (Limitation of more.com)
::      - An empty line is added to end of file (Limitation of more.com)
::      - If the input file is '%~f0', the script SHOULD exit (not 'exit /b')
::        after a successful conversion to prevent unexpected errors.
exit /b 0


:doc.demo
echo Detecting EOL...
for %%n in (1 2) do call :is_crlf.alt%%n --check-exist 2> nul && (
    call :is_crlf.alt%%n && (
        echo Conversion not necessary
        exit /b 0
    )
)
echo Converting EOL...
for %%n in (1 2) do call :to_crlf.alt%%n --check-exist 2> nul && (
    echo Call [to_crlf.alt%%n]
    call :to_crlf.alt%%n "%~f0" && (
        echo Conversion is successful
        echo Script will exit.
        pause
        exit 0
    ) || echo Conversion failed
)
exit /b 0


:EOF
exit /b
