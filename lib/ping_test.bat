:entry_point
call %*
exit /b


:ping_test <return_prefix> <host> [ping_opts]
set "_index=0"
for /f "usebackq tokens=1-8 delims=(:=, " %%a in (`ping "%~2" %~3 `) do (
    if "%%c, %%d, %%e, %%f" == "could, not, find, host" exit /b 2
    if "%%a, %%b, %%d, %%f" == "Packets, Sent, Received, Lost" (
        set "%~1packet_sent=%%c"
        set "%~1packet_received=%%e"
        set "%~1packet_lost=%%g"
        set "%~1packet_loss=%%h"
        set "%~1packet_loss=!%~1packet_loss:~0,-1!"
    )
    if "%%a, %%c, %%e" == "Minimum, Maximum, Average" (
        set "%~1min=%%b"
        set "%~1max=%%d"
        set "%~1avg=%%f"
        for %%v in (min max avg) do set "%~1%%v=!%~1%%v:~0,-2!"
    )
)
if "!~1loss!" == "100" exit /b 2
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=net"
exit /b 0


:doc.man
::  NAME
::      ping_test - Test if an host/IP responds to a ping test
::
::  SYNOPSIS
::      ping_test <return_prefix> <host> [ping_opts]
::
::  POSITIONAL ARGUMENTS
::      return_prefix
::          Prefix of the variable to store the metadata.
::          Variables (as seen in PING command) includes:
::          - Packet: sent, received, lost, loss,
::          - Ping: min, max, avg.
::
::      host
::          Hostname or IP of the target.
::
::      ping_opts
::          Parameters to use in ping test. By default, it is empty.
::
::  EXIT STATUS
::      0:  - Ping test receives response (at least once).
::      2:  - Ping test failed (100% packet loss).
exit /b 0


:doc.demo
call :Input.string host || set "host=google.com"
echo=
echo Ping: !host!
call :ping_test ping. !host! && (
    echo Ping Successful
) || echo Ping Failed
echo=
set ping.
exit /b 0


:EOF
exit /b
