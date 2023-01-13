:entry_point
call %*
exit /b


:updater [-n] [-y] [-f] [-u url] <script_path>
setlocal EnableDelayedExpansion
for %%v in (_assume_yes _notify_only _force _dl_url) do set "%%v="
call :argparse2 --name %0 ^
    ^ "script_path:             set _this" ^
    ^ "[-n,--notify-only]:      set _notify_only=true" ^
    ^ "[-y,--yes]:              set _assume_yes=true" ^
    ^ "[-f,--force]:            set _force=true" ^
    ^ "[-u,--download-url URL]: set _dl_url" ^
    ^ -- %* || exit /b 2
for %%f in ("!_this!") do set "_this=%%~ff"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "_other=!cd!\.updater.downloaded.bat"
call "!_this!" -c :metadata _this. || (
    1>&2 echo%0: Fail to read metadata & exit /b 3
)
if not defined _dl_url set "_dl_url=!_this.download_url!"
if not defined _dl_url (
    1>&2 echo%0: No download url found & exit /b 3
)
call :download_file "!_dl_url!" "!_other!" || (
    1>&2 echo%0: Download failed & exit /b 3
)
call "!_other!" -c :metadata _other. || (
    1>&2 echo%0: Fail to read downloaded metadata & exit /b 4
)
if not "!_other.name!" == "!_this.name!" (
    1>&2 echo%0: warning: Script name is different: '!_this.name!' and '!_other.name!'
)
call :version_parse _this._p_ver "!_this.version!"
call :version_parse _other._p_ver "!_other.version!"
if "!_other._p_ver!" LSS "!_this._p_ver!" (
    echo No updates are available
) else if "!_other._p_ver!" == "!_this._p_ver!" (
    echo You are using the latest version
) else (
    echo !_this.name! !_this.version! upgradable to !_other.name! !_other.version!
)
if not defined _force (
    if "!_other._p_ver!" LEQ "!_this._p_ver!" exit /b 5
)
if defined _notify_only exit /b 0
if not defined _assume_yes (
    call :input_yesno -d "N" -m "Proceed with update? [y/N] " || exit /b 5
)
(
    copy /b /y /v "!_other!" "!_this!" > nul
) && (
    echo Update success
    exit /b 0
) || exit /b 6
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse2 download_file version_parse input_yesno"
set "%~1extra_requires=argparse2 ping_test coderender get_pid_by_title input_path"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      updater - update a batch script from the internet
::
::  SYNOPSIS
::      updater [-n] [-y] [-f] [-u url] <script_path>
::
::  DESCRIPTION
::      Check for updates, download them, notify user, and update the script.
::      The script must accept the argument '-c :metadata <prefix>' to get
::      metadata of the script (name, version, download_url).
::
::  POSITIONAL ARGUMENTS
::      return_prefix
::          Prefix of the variable to store the metadata (if exit code is 0)
::
::      script_path
::          Path of the batch file.
::
::  OPTIONS
::      -n, --notify-only
::          Notify about updates only, do not upgrade script
::
::      -y, --yes
::          Assume yes when prompt
::
::      -f, --force
::          Force update even if problems are detected or script is
::          already the newest version
::
::      -u URL, --download-url URL
::          Use this URL to download instead of the one defined in metadata()
::
::  ENVIRONMENT
::      tmp_dir
::          Path to store the update file.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Update successful
::          - Update is available (--notify-only)
::      1:  - Unknown failure
::      2:  - Invalid parameters
::      3:  - Cannot read script metadata
::          - No download url found
::          - Download update fail
::      4:  - Cannot read downloaded metadata
::      5:  - No updates available (current > downloaded)
::          - Using latest version (current == downloaded)
::          - Update is available but not proceeded
::      6:  - Upgrade failed.
exit /b 0


:doc.demo
call :input_path --exist --file script_file --optional || exit /b 0
call :updater "!script_file!"
exit /b 0


:tests.setup
set "server_is_down="
set "test_server_title=test_server_!random!"
rem Start a FTP/HTTP file server in current directory
call :tests.setup.start_server
timeout /t 3 > nul
call :get_pid_by_title server_pid "!test_server_title!" || (
    set "server_is_down=true"
    call %unittest% skip "Cannot start dummy server"
    exit /b 0
)
call :coderender "%~f0" tests.template.dummy  > "remote.bat"
exit /b 0

:tests.setup.start_server
rem Install Python first, then run:
rem pip install twisted

start /min "!test_server_title!" cmd /c twistd ftp -r .
exit /b 0


:tests.teardown
if not defined server_is_down (
    taskkill /f /t /pid !server_pid! > nul
)
exit /b 0


:tests.test_notify
for %%a in (
    "upgradable: -v 0.1"
    "latest"
    "no updates: -v 2.0"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    call :coderender "%~f0" tests.template.dummy "%%c" > "local.bat"
    call :updater -n "local.bat" > message.stdout

    set "message="
    set /p "message=" < message.stdout
    set "message=[!message!]"

    set "keword_in_text="
    if not "!message!" == "!message:%%b=!" set "keword_in_text=true"
    if not defined keword_in_text (
        call %unittest% fail "Notification does not show '%%b' when it is supposed to"
    )
)
exit /b 0


:tests.test_force_update
type "remote.bat" > "local.bat" || exit /b
echo !random! >> "local.bat" || exit /b
call :updater -f -y "local.bat" > nul
fc /a /lb1 remote.bat local.bat > nul || (
    call %unittest% fail
)
exit /b 0


:tests.template.dummy [-n name] [-v version]
set "name=dummy"
set "version=1.0"
call :argparse2 ^
    ^ "[-n,--name NAME]:        set name" ^
    ^ "[-v,--version VERSION]:  set version" ^
    ^ -- %* || ( 1>&2 echo parse failed & exit /b 2 )
::  :entry_point
::  @goto main
::
::
::  :metadata [return_prefix]
echo set "%%~1name=!name!"
echo set "%%~1version=!version!"
::  set "%~1authors=Someone"
::  set "%~1license=The MIT License"
::  set "%~1description=Dummy Script"
::  set "%~1release_date=12/31/2000"
::  set "%~1url="
::  set "%~1download_url=ftp://localhost:2121/remote.bat"
::  exit /b 0
::
::
::  :main
::  @if ^"%1^" == "-c" @goto scripts.call
::  @goto scripts.main
::
::
::  :scripts.main
::  @setlocal EnableDelayedExpansion EnableExtensions
::  @echo off
::  1>&2 echo warning: wrong entry point
::  @exit /b
::
::
::  :scripts.call <label> [arguments]
::  @(
::      setlocal DisableDelayedExpansion
::      call set command=%%*
::      setlocal EnableDelayedExpansion
::      for /f "tokens=1* delims== " %%a in ("!command!") do @(
::          endlocal
::          endlocal
::          call %%b
::      )
::  )
::  @exit /b
exit /b 0


:EOF
exit /b
