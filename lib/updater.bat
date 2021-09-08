:entry_point
call %*
exit /b


:updater [-n] [-y] [-f] [-u url] <script_path>
setlocal EnableDelayedExpansion
for %%v in (_assume_yes _notify_only _force _dl_url) do set "%%v="
call :argparse ^
    ^ "#1:store                     :_this" ^
    ^ "-n,--notify-only:store_const :_notify_only=true" ^
    ^ "-y,--yes:store_const         :_assume_yes=true" ^
    ^ "-f,--force:store_const       :_force=true" ^
    ^ "-u,--download-url:store      :_dl_url" ^
    ^ -- %* || exit /b 2
for %%f in ("!_this!") do set "_this=%%~ff"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "_other=!cd!\latest.bat"
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
call :parse_version _this._p_ver "!_this.version!"
call :parse_version _other._p_ver "!_other.version!"
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
    call :Input.yesno -d "N" -m "Proceed with update? [y/N] " || exit /b 0
)
(
    copy /b /y /v "!_other!" "!_this!" > nul
) && (
    echo Update success
    exit /b 0
) || exit /b 6
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse download_file parse_version Input.yesno"
set "%~1extra_requires=ping_test coderender get_pid_by_title Input.path"
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
::      Notify for updates, download them, and update the script.
::      The script must accept the argument '-c :metadata <prefix>' to get
::      metadata of the script (name, version, download_url).
::
::  POSITIONAL ARGUMENTS
::      return_prefix
::          Prefix of the variable to store the metadata (if exit code is 0)
::
::      script_path
::          Path of the (batch) file.
::
::  OPTIONS
::      -n, --notify-only
::          Notify about updates only, do not upgrade script
::
::      -y, --yes
::          Assume yes when prompt
::
::      -f, --force
::          Force update even if incompatibility is detected or script is
::          already the newest version
::
::      -u URL, --download-url URL
::          Use this URL to download instead of the one set in metadata()
::
::  ENVIRONMENT
::      tmp_dir
::          Path to store the update file.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Success
::      1:  - Unknown failure
::      2:  - Invalid parameters
::      3:  - Fail to obtain download url
::          - Fail to download update
::          - Invalid download link
::      4:  - Fail to read downloaded metadata
::      5:  - No updates available / using latest version
::      6:  - Upgrade failed.
::
::  NOTES
::      - This function is still experimetal and is subject to change.
exit /b 0


:doc.demo
call :Input.path --exist --file script_file --optional || exit /b 0
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
call :coderender "%~f0" tests.template.dummy  > "dummy.bat"
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
call :updater -n "dummy.bat" > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_force_update
call :updater -f -y "dummy.bat" > nul || (
    call %unittest% fail
)
exit /b 0


:tests.template.dummy
::  :entry_point
::  @goto main
::
::
::  :metadata [return_prefix]
::  set "%~1name=dummy"
::  set "%~1version=0.1"
::  set "%~1author=anon"
::  set "%~1license=The MIT License"
::  set "%~1description=Dummy Script"
::  set "%~1release_date=12/31/2000"
::  set "%~1url="
::  set "%~1download_url=ftp://localhost:2121/dummy.bat"
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
