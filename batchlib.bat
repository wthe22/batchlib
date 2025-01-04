:entry_point
@goto main


rem ############################################################################
rem License
rem ############################################################################

:license
echo MIT No Attribution
echo=
echo Copyright 2017-2024 wthe22
echo=
echo Permission is hereby granted, free of charge, to any person obtaining a copy of this
echo software and associated documentation files (the "Software"), to deal in the Software
echo without restriction, including without limitation the rights to use, copy, modify,
echo merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
echo permit persons to whom the Software is furnished to do so.
echo=
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
echo INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
echo PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
echo HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
echo OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
echo SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      batchlib - batch script library
::
::  SYNOPSIS
::      batchlib
::      batchlib (-h|--help)
::      batchlib -c :<label> [arguments] ...
::      batchlib build <input_file> [backup_name]
::      batchlib debug <library> :<label> [arguments] ...
::      batchlib test [library]
::      batchlib template <name>
::
::  CALL SUBCOMMAND
::          batchlib -c :<label> [arguments] ...
::
::      Make batchlib CALL the specified label with the following arguments.
::
::  BUILD SUBCOMMAND
::          batchlib build <input_file> [backup_name]
::
::      Add/update dependencies of a file (made from the new script template).
::      Dependencies are found in 'install_requires' in lib.dependencies() and
::      'extra_requires' is ignored. Build is aborted if any errors occur.
::      Please keep codes between 'entry_point' and 'EOF'. Codes beyond that will
::      be removed.
::
::      POSITIONAL ARGUMENTS
::          input_file
::              Path of the input file to build.
::
::          backup_name
::              Path of the backup file.
::
::  RUN SUBCOMMAND
::          batchlib run <library> :<label> [arguments] ...
::
::      Run the library and call :LABEL with the ARGUMENTS.
::
::      This subcommand is not available in the minified version.
::
::  DEBUG SUBCOMMAND
::          batchlib debug <library> :<label> [arguments] ...
::
::      Run the library and call :LABEL with the ARGUMENTS.
::      Additional debugging features are:
::      - The quicktest() and unittest() libraries are included.
::      - Debug commands are executed and output is redirected to STDERR
::        if 'debug' variable is not defined.
::      - Library is always rebuilt before running.
::
::      This subcommand is not available in the minified version.
::
::  MAN SUBCOMMAND
::          batchlib man [library]
::
::      Shows documentation of a library. If no library name is specified,
::      it will show documentation of batchlib.
::
::      This subcommand is not available in the minified version.
::
::  TEST SUBCOMMAND
::          batchlib test [library]
::
::      Run unittests of a library. If no library is given, it will
::      test all libraries instead.
::
::      This subcommand is not available in the minified version.
::
::  TEMPLATE SUBCOMMAND
::          batchlib template <name>
::
::      Create the specified template and output to STDOUT.
::      Available templates: minified.
::
::      This subcommand have no templates in the minified version.
exit /b 0


:doc.argument_syntax
::  ARGUMENT SYNTAX
::      Description about how arguments are processed by functions. Here is a list
::      of possible arguments syntax used in the library and its usage example:
::
::      function_name <number>
::              call :function_name 1
::
::          Angle brackets <> means it is required. Number is a positional argument
::           and it is required. Errors might occur if argument is not specified.
::
::      function_name <number ...>
::              call :function_name "1 1 1"
::
::          Number can be specified multiple times within a pair of quotes.
::          Values are accessed through %~1.
::
::      function_name <number> ...
::              call :function_name 1 "2" "3" 4
::
::          Number can be specified multiple times and they must not share the
::          same pair of quotes. Values are accessed through %*.
::
::      function_name [number]
::              call :function_name  # OK, because number is optional
::              call :function_name 1
::
::          Square brackets [] means it is optional.
::
::      function_name [-n|--number]
::              call :function_name -n
::              call :function_name --number
::
::          -n and --number are options. They can be used interchangeably
::          (they are just the same thing).
::
::      function_name [-n number]
::              call :function_name -n 1
::              call :function_name -n  # Error: missing expected argument
::
::          Number must be specified after the -n flag. Errors might occur if
::          the expected argument is not specified.
::
::      function_name [--number] <message>
::              call :function_name --number "Hello"  # OK
::              call :function_name "Hello" --number  # Also OK
::
::          An option can be placed anywhere if it occurs before the positional
::          arguments.
::
::      function_name <message> [--number]
::              call :function_name "Hello" --number  # OK
::              call :function_name --number "Hello"  # Error: wrong position
::
::          An option must occur in the same position if it occurs after the
::          positional arguments. In this case, --number must be specified in
::          the second position if used.
::
::  ARGUMENT VALIDATION
::      Some libraries have argument validation. Usually they can be identified by
::      having the 'invalid argument' exit status. However, most library did not
::      have argument validation. It assumes that the given argument syntax and
::      values are valid. Make sure you validate the value first before passing it
::      to the function (e.g. if the function only accepts an integer, make sure
::      you pass an integer too, not alphabets, symbols, hexadecimal, etc.).
exit /b 0


:doc._guides
::  Variable names: [A-Za-Z_][A-Za-z0-9_.][A-Za-z0-9]
::  - Starts with an alphabet or underscore
::  - Only use alphabets, numbers, underscores, dashes, and dots
::  - Ends with an alphabet, underscore, or number
::  - Use variable names as a namespace
::
::  - external: something that is stored in other files
exit /b 0


:doc.help
echo usage:
echo    batchlib
echo        Run batchlib in interactive mode
echo=
echo    batchlib (-h^|--help)
echo        Show this help
echo=
echo    batchlib -c :^<label^> [arguments] ...
echo        Call the specified label with arguments
echo=
echo    batchlib build ^<input_file^> [backup_name]
echo        Add/update dependency of a file
echo=
echo    batchlib run ^<library^> :^<label^> [arguments] ...
echo        Run a function in the library (Not available in minified version)
echo=
echo    batchlib debug ^<library^> :^<label^> [arguments] ...
echo        Debug a library (Not available in minified version)
echo=
echo    batchlib man [library]
echo        Shows documentation of a library or the batchlib itself
echo        (Not available in minified version)
echo=
echo    batchlib test [library]
echo        Run unittest to a library (Not available in minified version)
echo=
echo    batchlib template ^<name^>
echo        Create the specified template and output to STDOUT.
exit /b 0


rem ############################################################################
rem Changelog
rem ############################################################################

:changelog
::  TLDR
::      Simplifying usage with some new features, and license change
::
::  - New subcommand: run
::  - New functions: list_lf2set, conf_edit, argparse2, endlocal, updater,
::    get_net_iface, timeleft
::  - Bug fixes: endlocal, quicktest, strip, input_yesno
::  - Behavior changes: quicktest, check_path, strip
::  - Incompatible changes: unittest, endlocal
::  - Deprecated / removed: ut_fmt_basic, argparse
::  - License: Remove attribution requirement (MIT No Attribution)
::
::  Library
::  - Include unittest() to library in debug mode
::  - Remove '-c' subcommand requirement to build script
::  - Add build script warning when ':entry_point' is not at line 1
::
::  - list_lf2set(): New! Similar to list2set() but with Line Feed seperator
::  - ini_edit(): New! INI configuration file editor
::  - get_net_iface(): NEW! Get network interface data
::
::  - argparse(): Deprecated. Please use argparse2() instead.
::  - argparse2():
::      - Successor of argparse()
::      - Help flag detection and auto-generated usage syntax
::      - Required/optional spec detection
::      - A single flag can now capture multiple arguments
::  - check_path(): Adjust exit status so invalid argument
::                  errors are distinguishable
::  - combi_wcdir(): Simplify code by using list_lf2set()
::  - endlocal():
::      - Fix string gets executed when it contains ampersand
::      - Add ability to quit multiple stacks of setlocal
::      - Function signature change
::  - get_os(): Function can now detect Windows 11
::  - input_yesno(): Fix value not returned if the value is null
::  - nroot(): Improve readabilty
::  - prime(): Add nroot dependency and improve readabilty
::  - quicktest():
::      - Empty label string now triggers auto detect label
::      - Use outcome message as-is to prevent errors from unquoted string
::      - Error in tests.setup() will abort the test,
::        making behavior consistent with unittest
::  - strip():
::      - Function can now safely process special characters in variable
::        and strip double quotes
::  - timeit(): Add unittest, reformat macro code
::  - timeleft(): Add macro
::  - ut_fmt_basic(): Removed / merged into unittest() as 'basic' output.
::  - unittest():
::      - Remove '-s' flag
::      - Rework and simplify usage of '-o' flag
::      - Added an experimental TAP output
::  - updater(): Remove '-c' subcommand requirement
::  - version_parse(): Add python testing code
::
::  Documentation
::  - Fix argument syntax of: quicktest, hexlify, argparse2
::  - Fix demo of: unittest
::  - Improve some documentations
::  - Template subcommand will list available template when no name is given
::  - Mark functions as required or optional in template.bat
::  - Add new subcommand to view documentation of a script
exit /b 0


:changelog.dev
::  - input_yesno():
::      - Fix regressioin where return var becomes required
::      - Fix null value not returned
::  - ini_edit():
::      - Renamed from conf_edit()
::      - Add limited section support
exit /b 0

rem ############################################################################
rem Metadata
rem ############################################################################

:metadata [return_prefix]
set "%~1name=batchlib"
set "%~1version=3.2a1"
set "%~1authors=wthe22"
set "%~1license=MIT No Attribution"
set "%~1description=Batch Script Library"
set "%~1release_date=12/31/2024"   :: mm/dd/YYYY
set "%~1url=https://github.com/wthe22/batchlib"
set "%~1download_url=https://raw.githubusercontent.com/wthe22/batchlib/master/batchlib.bat"
exit /b 0


:about
setlocal EnableDelayedExpansion
call :metadata
echo !description! / !name! !version! ^(!release_date!^)
echo=
echo A collection of functions/snippets for batch script
echo Created to make batch scripting easier
echo=
echo Updated on !release_date!
echo=
echo Feel free to use, share, or modify this script for your projects :)
echo Visit http://winscr.blogspot.com/ or https://github.com/wthe22/batch-scripts
echo for more scripts^^!
echo=
echo=
echo Copyright (C) 2017-2024 by !authors!
echo Licensed under !license!
endlocal
exit /b 0


rem ############################################################################
rem Configurations
rem ############################################################################

:config
call :config.default
call :config.preference
exit /b 0


:config.default
rem Default/common configurations. DO NOT MODIFY
rem Directory for temporary files
set "tmp_dir=!tmp!\!SOFTWARE.name!"
rem Directory to keep library, builds, etc.
set "lib_dir=%~dp0lib"
set "build_dir=%~dp0build"
exit /b 0


:config.preference
rem Configurations to change/override
:: set "tmp_dir=%~dp0tmp\tmp"
exit /b 0


rem ############################################################################
rem Main
rem ############################################################################

:main
@if ^"%1^" == "-c" @goto subcommand.call
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
if ^"%1^" == "-h" goto doc.help
if ^"%1^" == "--help" goto doc.help
call :metadata SOFTWARE.
call :config
call :common_setup
if ^"%1^" == "" (
    call :main_script
) else call :subcommand.%*
set "exit_code=!errorlevel!"
call :common_cleanup
@exit /b !exit_code!


:common_setup
set "flags.is_minified="
call :flags.is_minified 2> nul && set "flags.is_minified=true"

set "lib="
call :true 2> nul || set "lib=:lib.call "
set "no_cleanup="
if defined flags.is_minified (
    set "lib_dir="
    set "build_dir="
)

for %%p in (
    tmp_dir
    lib_dir
    build_dir
) do if defined %%p if not exist "!%%p!" md "!%%p!"

call :Library.unload_info
call :Library.read_names
call :Library.read_dependencies
if not defined flags.is_minified (
    call :LibBuild.remove_orphans
)
exit /b 0


:common_cleanup
if defined no_cleanup exit /b 0

for %%p in (
    tmp_dir
) do if defined %%p if exist "!%%p!" rd /s /q "!%%p!"
exit /b 0


:main_script
call :true 2> nul || call :self_build
call :Library.read_args
call :Category.unload_info
call :Category.load
call :main_menu
cls
exit /b


:subcommand.build <file>
call :build_script %*
exit /b


:subcommand.run <library> :<label> [arguments] ...
set "library=%~1"
call :LibBuild.update "!library!" || exit /b 3
endlocal & (
    cd /d "%build_dir%"
    set "tmp_dir=%tmp_dir%"
)
call %*
exit /b


:subcommand.debug <library> :<label> [arguments] ...
set "library=%~1"
for %%v in ("Library_!library!.extra_requires") do set "%%~v=!%%~v! quicktest unittest"
call :LibBuild.build "!library!" || exit /b 3
endlocal & (
    cd /d "%build_dir%"
    set "tmp_dir=%tmp_dir%"
)
if not defined debug set "debug=/? > nul & 1>&2"
call %*
set "no_cleanup=true"
exit /b


:subcommand.man <library>
if ^"%1^" == "" (
    call :functions_range _range "%~f0"  doc.man
    call :readline "%~f0" !_range! 1:-1 4
) else (
    set "_library=%~1"
    set "_library_source=!lib_dir!\!_library!.bat"
    call :functions_range _range "!_library_source!" "doc.man" && (
        call :readline "!_library_source!" !_range! 1:-1 4
    )
)
exit /b 0


:subcommand.test <library>
call :tests.run_lib_test %1
exit /b


:subcommand.template <name>
set "template_name=%~1"
if not defined template_name (
    call :functions_match labels "%~f0" "template.*"
    set "_templates= "
    for %%l in (!labels!) do (
        for /f "tokens=2 delims=." %%a in ("%%l") do (
            set "_templates=!_templates: %%a = !%%a "
        )
    )
    set "_templates=!_templates:~1,-1!"
    echo Available templates: !_templates!
    exit /b 0
)
call :coderender "%~f0" "template.!template_name!"
exit /b


:subcommand.call -c :<label> [arguments] ...
@(
    setlocal DisableDelayedExpansion
    call set command=%%*
    setlocal EnableDelayedExpansion
    for /f "tokens=1* delims== " %%a in ("!command!") do @(
        endlocal
        endlocal
        call %%b
    )
)
@exit /b


rem ############################################################################
rem User Interfaces
rem ############################################################################

:ui
exit /b 0


:main_menu
set "user_input="
cls
echo !SOFTWARE.DESCRIPTION! !SOFTWARE.VERSION!
echo=
echo 1. Browse documentation
echo 2. Use command line
echo 3. Test Libraries
echo 4. Generate minified version
echo 5. Build/add dependencies to a script
echo 6. Reload Library
echo=
echo H. Help
echo 0. Exit
echo=
echo What do you want to do?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" call :browse_lib
if "!user_input!" == "2" call :conemu
if "!user_input!" == "3" (
    call :tests.run_lib_test
    pause
    goto main_menu
)
if "!user_input!" == "4" call :new_template_menu "minified" "Minified Script"
if "!user_input!" == "5" call :build_menu
if "!user_input!" == "6" (
    call :Library.unload_info
    call :Library.read_names
    call :Library.read_dependencies
    call :Library.read_args
    call :Category.unload_info
    call :Category.load
    call :LibBuild.remove_orphans
    pause
    goto main_menu
)
if /i "!user_input!" == "H" call :help_menu
goto main_menu


:self_build
setlocal EnableDelayedExpansion
echo Adding/updating dependencies to this script...
set "lib=:lib.call "
call :build_script "%~f0"
echo Build done [exit code !errorlevel!]
pause
exit /b 0


:help_menu
set "user_input="
cls
echo 1. Usage
echo 2. Library Argument Syntax
echo 3. Change Log
echo=
echo U. Check for Update
echo A. About Script
echo 0. Exit
echo=
echo What do you want to do?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" call :show_docs doc.man
if "!user_input!" == "2" call :show_docs doc.argument_syntax
if "!user_input!" == "3" call :show_docs changelog
if /i "!user_input!" == "A" (
    cls
    call :about
    echo=
    pause
    goto help_menu
)
if /i "!user_input!" == "U" (
    call :updater -n "%~f0" && (
        echo Get the latest version at !SOFTWARE.url!
    )
    pause
    goto help_menu
)
goto help_menu


:browse_lib
set "selected.quit="
set "selected.category="
set "selected.function="
:browse_lib._loop
if defined selected.quit exit /b 2
if not defined selected.category (
    call :InputCategory selected.category || (
        set "selected.quit=true"
        goto browse_lib._loop
    )
)
if not defined selected.function (
    call :InputFunction selected.function !selected.category! || (
        set "selected.category="
        goto browse_lib._loop
    )
)
call :LibMenu !selected.function!
set "selected.function="
goto browse_lib._loop


:InputCategory <return_var>
set "_selected="
call :InputCategory.select_menu
set "%~1=!_selected!"
if not defined _selected exit /b 2
exit /b 0
#+++

:InputCategory.select_menu
set "user_input="
cls
call :InputCategory.get_item list
echo=
echo S. Search function
echo 0. Back
echo=
echo Which category do you want to choose?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 2
if /i "!user_input!" == "S" (
    call :InputCategory.search_menu && exit /b 0
) else call :InputCategory.get_item "!user_input!" && exit /b 0
goto InputCategory.select_menu
#+++

:InputCategory.get_item <list|number>
set "_count=0"
for %%c in (!Category.all!) do (
    if not "!Category_%%c.item_count!" == "0" (
        set /a "_count+=1"
        if /i ^"%1^" == "list" (
            set "_count=   !_count!"
            echo !_count:~-3,3!. !Category_%%c.name! ^(%%c^) [!Category_%%c.item_count!]
        ) else if "%~1" == "!_count!" set "_selected=%%c"
    )
)
if not defined _selected exit /b 2
exit /b 0
#+++

:InputCategory.search_menu
set "user_input="
cls
echo 0. Back
echo=
echo Input search keyword:
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 2
call :Library.search Category_search.functions "!user_input!"
set "_selected=search"
set "Category_search.name=Search Result for '!user_input!'"
set "Category_search.item_count=0"
for %%f in (!Category_search.functions!) do set /a "Category_search.item_count+=1"
exit /b 0


:InputFunction <return_var> <category>
set "_category=%~2"
set "_selected="
call :InputFunction.select_menu
set "%~1=!_selected!"
if not defined _selected exit /b 2
exit /b 0
#+++

:InputFunction.select_menu
set "user_input="
cls
echo=!Category_%_category%.name!
echo=
set "_count=0"
for %%c in (!_category!) do ( rem
) & for %%f in (!Category_%%c.functions!) do (
    set /a "_count+=1"
    set "_count=   !_count!"
    echo !_count:~-3,3!. !Library_%%f.args!
)
echo=
echo 0. Back
echo=
echo Which function do you want to choose?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 2
set "_count=0"
for %%c in (!_category!) do ( rem
) & for %%f in (!Category_%%c.functions!) do (
    set /a "_count+=1"
    if "!user_input!" == "!_count!" (
        set "_selected=%%f"
        exit /b 0
    )
)
goto InputFunction.select_menu
#+++

:InputFunction.get_item <list|number>
set "_count=0"
for %%c in (!_category!) do ( rem
) & for %%f in (!Category_%%c.functions!) do (
    set /a "_count+=1"
    if /i ^"%1^" == "list" (
        set "_count=   !_count!"
        echo !_count:~-3,3!. !Library_%%f.args!
    ) else if "%~1" == "!_count!" set "_selected=%%f"
)
if not defined _selected exit /b 2
exit /b 0


:LibMenu <function>
setlocal EnableDelayedExpansion
set "_library=%~1"
set "_library_source=!lib_dir!\!_library!.bat"
set "_library_build=!build_dir!\!_library!.bat"
call "!_library_source!" :lib.dependencies "Library_!_library!." 2> nul
call :LibBuild.update "!_library!"
call :LibMenu.menu
exit /b 0
#+++

:LibMenu.menu
set "user_input="
cls
echo !Library_%_library%.args!
echo=
echo 1. Read manual
echo 2. Run demo
echo 3. Run tests
echo 4. More information
echo 5. View source
echo=
echo 0. Back
echo=
echo What do you want to do?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" call :LibMenu.read_manual
if "!user_input!" == "2" call :LibMenu.run_demo
if "!user_input!" == "3" call :LibMenu.run_tests
if "!user_input!" == "4" call :LibMenu.show_info
if "!user_input!" == "5" call :LibMenu.view_source
goto LibMenu.menu


:LibMenu.read_manual
cls
call :functions_range _range "!_library_source!" "doc.man" && (
    call :readline "!_library_source!" !_range! 1:-1 4
)
echo=
pause
exit /b 0


:LibMenu.run_demo
setlocal EnableDelayedExpansion
cls
call :functions_range _range "!_library_source!" "doc.man" && (
    call :readline "!_library_source!" !_range! 1:-1 4
)
echo=
echo ================================================================================
echo=
call "!_library_build!" :doc.demo
echo=
pause
exit /b 0


:LibMenu.run_tests
setlocal EnableDelayedExpansion
call :tests.run_lib_test !_library!
pause
exit /b 0


:LibMenu.show_info
cls
set "category= "
for %%c in (!Library_%_library%.category!) do set "category=!category!!Category_%%c.name!, "
set "category=!category:~1,-2!"
call :Library.rdepends rdepends "!Library.all!" "!_library!" "install"
set "rdepends=!rdepends: %_library% = !"

echo Name               : !_library!
echo Argument Syntax    : !Library_%_library%.args!
echo Category           : !category!
echo=
echo Install requires   : !Library_%_library%.install_requires!
echo Extra requires     : !Library_%_library%.extra_requires!
echo Required by        : !rdepends!
echo=
pause
exit /b 0


:LibMenu.view_source
cls
call :functions_range _range "!_library_source!" "!_library!" && (
    call :readline "!_library_source!" !_range!
)
echo=
pause
exit /b 0


:new_template_menu <template> <description>
setlocal EnableDelayedExpansion
set "_template=%~1"
set "_description=%~2"
call :input_path save_file --file --warn-overwrite --optional ^
    ^ --message "Input new !_description! path (Enter nothing to cancel): " ^
    ^ || exit /b 2
echo=
echo !_description! path:
echo !save_file!
echo=
echo Generating...
set "start_time=!time!"
call :coderender "%~f0" "template.!_template!" > "!save_file!"
call :difftime time_taken "!time!" "!start_time!"
call :ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
pause
exit /b 0


:build_menu
call :input_path script_file --file --exist --optional ^
    ^ --message "Input script path (Enter nothing to cancel): " ^
    ^ || exit /b 2
call :input_path backup_file --file --warn-overwrite --optional  ^
    ^ --message "Input backup path (optional): "
echo=
echo Generating...
set "start_time=!time!"
if defined backup_file (
    call :build_script "!script_file!" "!backup_file!"
) else call :build_script "!script_file!"
call :difftime time_taken "!time!" "!start_time!"
call :ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
pause
exit /b 0


:show_docs <label>
cls
call :functions_range _range "%~f0" %1
call :readline "%~f0" !_range! 1:-1 4
echo=
pause
exit /b 0


rem ############################################################################
rem Core
rem ############################################################################

:core
exit /b 0


:build_script <input_file> [backup_name]
setlocal EnableDelayedExpansion
set "_input_file=%~f1"
set "_backup_file=%~f2"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
if defined flags.is_minified set "lib="
call %lib%:functions_range _range "!_input_file!" "lib.dependencies" || exit /b 3
call %lib%:readline "!_input_file!" !_range! > "_lib_dependencies.bat" || exit /b 3
call "_lib_dependencies.bat" || exit /b 3
call :Library.depends _dep "!install_requires!" || exit /b 3
call :Library.unload_info
call %lib%:functions_range _range "!_input_file!" "entry_point EOF" || exit /b 3
for /f "tokens=1,4 delims=: " %%a in ("!_range!") do (
    set "_range=%%a:%%b"
    if %%a GTR 1 (
        1>&2 echo%0: warning: Expected ':entry_point' label at line 1, found at line %%a
    )
)
> "_build_script.tmp" (
    call %lib%:readline "!_input_file!" !_range! || exit /b 3
    echo=
    echo=
    echo :: Automatically Added by !SOFTWARE.name! !SOFTWARE.VERSION! on !date! !time!
    echo=
    if defined flags.is_minified (
        call :functions_range _ranges "%~f0" "!_dep!" || exit /b 3
        for %%r in (!_ranges!) do (
            call :readline "%~f0" %%r || exit /b 3
            echo=
            echo=
        )
    ) else (
        for %%l in (!_dep!) do (
            call %lib%:functions_range _range "!lib_dir!\%%l.bat" "%%l" || exit /b 3
            call %lib%:readline "!lib_dir!\%%l.bat" !_range! || exit /b 3
            echo=
            echo=
        )
    )
) || exit /b 3
if defined _backup_file (
    copy /b /v /y "!_input_file!" "!_backup_file!" > nul || exit /b 3
)
move /y "_build_script.tmp" "!_input_file!" > nul || exit /b 3
exit /b 0


:self_extract_func <label> ...
setlocal EnableDelayedExpansion
set "_success=true"
set "_labels= "
for %%l in (%*) do set "_labels=!_labels!%%~l "
call :functions_range _range "%~f0" "!_labels!" || set "_success="
for %%r in (!_range!) do (
    call :readline "%~f0" %%r || set "_success="
    echo=
    echo=
)
if not defined _success exit /b 3
exit /b 0


:Category.unload_info
call :unset_all "Category." "Category_"
exit /b 0


:Category.load
call :Category.load_names
call :Category.build
exit /b 0


:Category.load_names
set "Category.all= "
set "Category.default=none"
for %%a in (
    "all: All"
    "number: Number"
    "string: String"
    "algorithms: Algorithms"
    "time: Date and Time"
    "file: File and Folder"
    "net: Network"
    "env: Environment"
    "ui: User Interface"
    "cli: Command Line Interface"
    "packaging: Packaging"
    "devtools: Development Tools"
    "external: External"
    "experimental: Experimental"
    "none: Uncategorized"
    "search: Search Results"
) do for /f "tokens=1* delims=: " %%c in (%%a) do (
    set "Category.all=!Category.all!%%c "
    set "Category_%%c.name=%%d"
)
set "Category.valid_values=!Category.all!"
for %%c in (all none search) do (
    set "Category.valid_values=!Category.valid_values: %%c = !"
)
exit /b 0


:Category.build
set "Category_all.functions=!Library.all!"
for %%l in (!Library.all!) do (
    set "_category="
    for %%c in (!Library_%%l.category!) do (
        if defined Category_%%c.name (
            set "_category=!_category! %%c"
        ) else ( 1>&2 echo%0: Unknown category '%%c' in %%l^(^) )
    )
    if not defined _category set "_category=!Category.default!"
    for %%c in (!_category!) do (
        set "Category_%%c.functions=!Category_%%c.functions! %%l"
    )
)
for %%c in (!Category.all!) do (
    set "_count=0"
    for %%l in (!Category_%%c.functions!) do set /a "_count+=1"
    set "Category_%%c.item_count=!_count!"
)
exit /b 0


:LibBuild.remove_orphans
for %%l in ("!build_dir!\*") do (
    if not exist "!lib_dir!\%%~nxl" (
        echo Remove leftover build of %%~nl^(^)
        del /f /q "%%~fl"
    )
)
exit /b 0


:LibBuild.update [library ...]
setlocal EnableDelayedExpansion
set "_library=%~1"
if not defined _library set "_library=!Library.all!"
call :LibBuild.find_outdated _to_build "!_library!"
if not defined _to_build exit /b 0
echo Updating: !_to_build!
for %%l in (!_to_build!) do (
    echo building %%l^(^)
    call :LibBuild.build "%%l"
)
exit /b 0


:LibBuild.find_outdated <return_var> <library ...>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_library=%~2"
set "_result= "
for %%l in (!_library!) do (
    for %%f in ("!build_dir!\%%l.bat") do set "_btime=%%~tf"
    for %%v in (_btime) do (
        set "%%v=!%%v:~6,4!-!%%v:~0,2!-!%%v:~3,2!T!%%v:~17,2!!%%v:~11,2!:!%%v:~14,2!"
        set "%%v=!%%v:M12=M00!"
    )
    set "_is_outdated="
    call :Library.depends _dep "%%l" "install extra"
    for %%d in (!_dep!) do if not defined _is_outdated (
        for %%f in ("!lib_dir!\%%d.bat") do set "_mtime=%%~tf"
        for %%v in (_mtime) do (
            set "%%v=!%%v:~6,4!-!%%v:~0,2!-!%%v:~3,2!T!%%v:~17,2!!%%v:~11,2!:!%%v:~14,2!"
            set "%%v=!%%v:M12=M00!"
        )
        if "!_btime!" LEQ "!_mtime!" set "_is_outdated=true"
    )
    if defined _is_outdated set "_result=!_result!%%l "
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "!%_return_var%!" == " " set "%_return_var%="
)
exit /b 0


:LibBuild.build <library>
setlocal EnableDelayedExpansion
set "_library=%~1"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
if not exist "!lib_dir!\!_library!.bat" (
    1>&2 echo%0: file not found: "!lib_dir!\!_library!.bat"
    exit /b 2
)
if not exist "!build_dir!" mkdir "!build_dir!"
for %%l in (!_library!) do (
    call :LibBuild.check_extraction "!lib_dir!\%%l.bat" "%%l" || (
        1>&2 echo%0: warning: possible incomplete extraction of %%l^(^)
    )
    set "_dep=!Library_%%l.install_requires!"
    for %%r in (install extra) do set "_dep=!_dep! !Library_%%l.%%r_requires!"
    call :LibBuild.build._template "!lib_dir!\%%l.bat" "!_dep!" > "%%l.bat.tmp" && (
        move /y "%%l.bat.tmp" "!build_dir!\%%l.bat" > nul
    ) || (
        1>&2 echo%0: Could not build %%l^(^)
        del /f /q "%%l.bat.tmp"
        exit /b 3
    )
)
exit /b 0
#+++

:LibBuild.check_extraction <input_file> <label>
setlocal EnableDelayedExpansion
set "_input_file=%~f1"
set "_label=%~2"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call %lib%:functions_range _range "!_input_file!" "!_label!" || exit /b 4
for /f "tokens=1-2 delims=: " %%a in ("!_range!") do (
    call %lib%:readline "!_input_file!" 1:%%a 0:-1
    if not "%%b" == "" call %lib%:readline "!_input_file!" %%b: 1:
) > "_other"
call %lib%:functions_list "_other" > "_labels"
set "_match="
for /f "usebackq tokens=*" %%l in ("_labels") do (
    set "_leftover=:%%l"
    set _leftover=!_leftover::%_label%=x:!
    if "!_leftover:~0,2!" == "x:" set "_match=true"
)
if defined _match exit /b 3
exit /b 0
#+++

:LibBuild.build._template <source> [dependency ...]
setlocal EnableDelayedExpansion
set "_source=%~f1"
set "_dependencies=%~2"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
echo :: Generated on !date! !time!
echo=
echo=
type "!_source!" || exit /b 3
echo=
echo=
echo :: Automatically Added
echo=
call :Library.depends _dep "!_dependencies!" || exit /b 3
call :Library.unload_info
for %%l in (!_dep!) do (
    call %lib%:functions_range _range "!lib_dir!\%%l.bat" "%%l" || exit /b 3
    call %lib%:readline "!lib_dir!\%%l.bat" !_range! || exit /b 3
    echo=
    echo=
)
exit /b 0


:Library.unload_info
call :unset_all "Library." "Library_"
exit /b 0


:Library.read_names
setlocal EnableDelayedExpansion
set "_result= "
for %%f in ("!lib_dir!\*.bat") do (
    set "_filename=%%~nf"
    set "_valid=true"
    if defined _valid (
        for %%s in (. _) do (
            if "!_filename:~0,1!" == "%%s" set "_valid="
        )
    )
    if defined _valid (
        set "_tokens="
        for %%_ in (!_filename!) do set "_tokens=!_tokens!1"
        if not "!_tokens!" == "1" (
             set "_valid="
            1>&2 echo%0: Invalid function name: '%%~nf'
        )
    )
    if defined _valid (
        set "_result=!_result!!_filename! "
    )
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "Library.all=%%b"
)
exit /b 0


:Library.read_args
goto Library.read_args.from_lib_dir


:Library.read_args.from_lib_dir
for %%l in (!Library.all!) do (
    for /f "usebackq tokens=1*" %%a in ("!lib_dir!\%%l.bat") do ( rem
    ) & if /i "%%a" == ":%%l" (
        set "Library_%%l.args=%%l   %%b"
    )
    if not defined Library_%%l.args (
        1>&2 echo%0: Could not read arguments for '%%l'
        set "Library_%%l.args=%%l   ???"
    )
)
exit /b 0


:Library.read_args.from_self
for /f "usebackq tokens=1*" %%a in ("%~f0") do ( rem
) & for /f "tokens=1 delims=:" %%l in ("%%a") do (
    if ":%%l" == "%%a" if not "!Library.all: %%l = !" == ":%%l" (
        set "Library_%%l.args=%%l   %%b"
    )
)
for %%l in (!Library.all!) do (
    if not defined Library_%%l.args (
        1>&2 echo%0: Could not read arguments for '%%l'
    )
)
exit /b 0


:Library.read_dependencies
for %%l in (!Library.all!) do (
    set "Library_%%l.install_requires=?"
    call "!lib_dir!\%%l.bat" :lib.dependencies "Library_%%l." 2> nul || (
        1>&2 echo%0: Failed to call lib.dependencies^(^) in '%%l'
    )
)
exit /b 0


:Library.depends <return_var> <library ...> [requires ...]
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_library=%~2"
set "_requires=%~3"
if not defined _requires set "_requires=install"
set "_search_list= "
for %%l in (!_library!) do (
    for %%r in (!_requires!) do (
        for /f "tokens=1-2 delims=[]" %%a in ("%%l[%%r]") do (
            set "_search_list=!_search_list!%%a[%%b] "
        )
    )
)
set "_result= "
set "_stack="
set "_bad="
set "_errorlevel=0"
call :Library.depends._visit "!_search_list!"
set "_result=!_result:[install] = !"
call :Library.remove_extras_pkg _result
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
    exit /b %_errorlevel%
)
exit /b 1
#+++

:Library.depends._visit <library ...>
set "_lib= "
for %%l in (%~1) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l[install]") do (
    set "_lib= %%a[%%b]!_lib!"
    )
)
for %%l in (%_lib%) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l") do (
    set "_stack=%%a[%%b] !_stack!"
    set "_visit=true"
    if not "!_stack: %%a[%%b] =!" == "!_stack!" (
        1>&2 echo%0: Cyclic dependencies detected in stack: !_stack!
        set /a "_errorlevel|=0x4"
        set "_visit="
    )
    if not "!_result: %%a[%%b] =!" == "!_result!" set "_visit="
    if not defined Library_%%a.install_requires (
        1>&2 echo%0: Failed to resolve dependency in stack: !_stack!
        set /a "_errorlevel|=0x2"
        set "_visit="
    )
    if defined _visit (
        call :Library.depends._visit "!Library_%%a.%%b_requires!"
    )
    if "!_result: %%a[%%b] =!" == "!_result!" set "_result= %%a[%%b]!_result!"
    for /f "tokens=1* delims= " %%r in ("!_stack!") do set "_stack=%%s"
)
exit /b 0


:Library.rdepends <return_var> <search_list> <library ...> [requires ...]
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_search_list_raw=%~2"
set "_library=%~3"
set "_requires=%~4"
if not defined _requires set "_requires=install"
set "_search_list="
for %%l in (!_search_list_raw!) do (
    for %%r in (!_requires!) do (
        for /f "tokens=1-2 delims=[]" %%a in ("%%l[%%r]") do (
            set "_search_list=!_search_list! %%a[%%b]"
        )
    )
)
set "_match_list="
for %%l in (!_library!) do (
    for /f "tokens=1-2 delims=[]" %%a in ("%%l[install]") do (
        set "_match_list=!_match_list! %%a[%%b]"
    )
)
set "_result= "
set "_stack="
set "_visited= "
call :Library.rdepends._visit "!_search_list!"
set "_result=!_result:[install] = !"
call :Library.remove_extras_pkg _result
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
)
exit /b 0
#+++

:Library.rdepends._visit <library ...>
for %%l in (%~1) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l[install]") do (
    set "_stack=%%a[%%b] !_stack!"
    set "_match="
    for %%m in (!_match_list!) do if "%%a[%%b]" == "%%m" set "_match=true"
    if defined _match (
        for %%s in (!_stack!) do (
            if "!_result: %%s =!" == "!_result!" set "_result= %%s!_result!"
        )
    ) else (
        set "_visit=true"
        if not "!_stack: %%a[%%b] =!" == "!_stack!" set "_visit="
        if not "!_visited: %%a[%%b] =!" == "!_visited!" set "_visit="
        if not defined Library_%%a.install_requires set "_visit="
        if defined _visit (
            set "_visited= %%a[%%b]!_visited!"
            call :Library.rdepends._visit "!Library_%%a.%%b_requires!"
        )
    )
    for /f "tokens=1* delims= " %%r in ("!_stack!") do set "_stack=%%s"
)
exit /b 0


:Library.remove_extras_pkg <variable>
setlocal EnableDelayedExpansion
set "_variable=%~1"
set "_value=!%~1!"
set "_result= "
for %%l in (!_value!) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l") do (
    if "!_result: %%a =!" == "!_result!" set "_result=!_result!%%a "
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_variable%=%%b"
    if "%%b" == " " set "%_return_var%="
)
exit /b 0


:Library.search <return_var> <keyword>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_keyword=%~2"
set "_result= "
for /f "tokens=* delims=" %%k in ("!_keyword!") do (
    for %%l in (!Library.all!) do (
        set "_temp= !Library_%%l.args!"
        if not "!_temp:%%k=!" == "!_temp!" (
            set "_result=!_result!%%l "
        )
    )
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
    if not defined %_return_var% exit /b 2
)
exit /b 0


rem ############################################################################
rem Library
rem ############################################################################

:lib.dependencies [return_prefix]
set %~1install_requires= ^
    ^ functions_range readline functions_list true unset_all ^
    ^ coderender unittest version_parse ^
    ^ conemu input_path input_yesno input_string updater ^
    ^ difftime ftime ^
    ^ %=END=%
exit /b 0


:lib.call <library> [args]
@for /f "tokens=1 delims=: " %%a in ("%~1") do @(
    goto 2> nul
    call "%lib_dir%\%%a.bat" %*
)
@exit /b 1


rem ############################################################################
rem Templates
rem ############################################################################

:template.minified
call :Library.unload_info
call :Library.read_names
call :Library.read_dependencies
call :Category.load
set "sep_line="
for /l %%n in (5,1,80) do set "sep_line=!sep_line!#"

call :self_extract_func "entry_point"

call :template.minified._section_header "License"
call :self_extract_func "license"

call :template.minified._section_header "Documentation"
call :self_extract_func ^
    ^ doc.help ^
    ^ doc.man ^
    ^ %=END=%

call :template.minified._section_header "Metadata"
call :self_extract_func "metadata"
call :self_extract_func "about"

call :template.minified._section_header "Configurations"
call :self_extract_func ^
    ^ config ^
    ^ config.default ^
    ^ config.preference ^
    ^ %=END=%

call :template.minified._section_header "Main"
call :self_extract_func ^
    ^ main ^
    ^ common_setup ^
    ^ common_cleanup ^
    ^ %=END=%
::  :main_script
::  echo !SOFTWARE.DESCRIPTION! !SOFTWARE.VERSION!
::  echo=
::  call :conemu
::  exit /b 0
::
::
call :self_extract_func ^
    ^ subcommand.build ^
    ^ subcommand.template ^
    ^ subcommand.call ^
    ^ %=END=%

call :template.minified._section_header "Core"
call :self_extract_func ^
    ^ core ^
    ^ build_script ^
    ^ self_extract_func ^
    ^ Library.unload_info ^
    ^ %=END=%

::  :Library.read_names
::  set Library.all= ^
set "_count=0"
set "_value="
for %%l in (!Library.all!) do (
    set /a "_count+=1"
    set "_value=!_value! %%l"
    if "!_count!" == "8" (
        echo     ^^^^ !_value:~1! ^^^^
        set "_count=0"
        set "_value="
    )
)
if defined _value echo     ^^^^ !_value:~1! ^^^^
echo     ^^^^ %%=END=%%!=DUMMY=!
::  exit /b 0
::
::
::  :Library.read_dependencies
for %%l in (!Library.all!) do (
    for %%a in (
        install_requires extra_requires
    ) do for %%v in (Library_%%l.%%a) do (
        if defined %%v echo set "%%v=!%%v!"
    )
)
::  exit /b 0
::
::
::  :Library.read_args
::  goto Library.read_args.from_self
::
::
call :self_extract_func ^
    ^ Library.read_args.from_self ^
    ^ Library.depends ^
    ^ Library.rdepends ^
    ^ Library.remove_extras_pkg ^
    ^ Library.search ^
    ^ %=END=%
::  :flags.is_minified
::  rem Indicator that script is minified
::  exit /b 0
::
::

call :template.minified._section_header "Tests"
call :self_extract_func "tests"

call :template.minified._section_header "Library"
call :self_extract_func ^
    ^ lib.dependencies ^
    ^ lib.call ^
    ^ %=END=%
call :Library.depends ordered_lib "!Library.all!"
for %%l in (!ordered_lib!) do (
    call :functions_range _range "!lib_dir!\%%l.bat" "%%l"
    call :readline "!lib_dir!\%%l.bat" !_range!
    echo=
    echo=
)

call :template.minified._section_header "End"
call :self_extract_func "EOF"
exit /b 0
#+++

:template.minified._section_header
echo rem !sep_line!
echo rem %~1
echo rem !sep_line!
echo=
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :unittest --output "basic"
exit /b 0


:tests.run_lib_test [library]
setlocal EnableDelayedExpansion
set "_library=%~1"
if defined _library (
    call :LibBuild.update "!_library!"
    set "target=!build_dir!\!_library!.bat"
) else (
    call :LibBuild.update
    set "target=!build_dir!\*.bat"
)
call :Library.unload_info
cmd /q /e:on /v:on /c ""%~f0" -c :unittest "!target!" --target-args "" --output "basic""
exit /b


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.test_version
call :metadata
call :version_parse _ "!version!" || (
    call %unittest% fail "Invalid version scheme '!version!'"
)
exit /b 0


:tests.Library.test_unload
set "Library.test=hello hi"
set "Library_hello.install_requires=hi"
set "Library_hello.args=hello   <name>"
call :Library.unload_info
set "success=true"
for %%v in (
    Library.test
    Library_hello.install_requires
    Library_hello.args
) do if defined %%v set "success="
if not defined success (
    call %unittest% fail
)
exit /b 0


:tests.Library.test_read_names
if exist "dummy_lib" rd /s /q "dummy_lib"
mkdir "dummy_lib"
for %%d in (dummy_lib) do set "lib_dir=%%~fd"
call 2> "!lib_dir!\_hidden.bat"
call 2> "!lib_dir!\hi.bat"
call 2> "!lib_dir!\hello.vbs"
call :Library.read_names
set "result=!Library.all!"
set "expected= hi "
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_read_args
if exist "dummy_lib" rd /s /q "dummy_lib"
mkdir "dummy_lib"
for %%d in (dummy_lib) do set "lib_dir=%%~fd"
> "!lib_dir!\hi.bat" (
    echo :hi ^<name^> [message]
)
set "Library.all=hi"
call :Library.read_args
set "result=!Library_hi.args!"
set "expected=hi   <name> [message]"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_depends
set "Library.all=bed chair plank stick table wood wool"
set "Library_table.install_requires=plank stick"
set "Library_chair.install_requires=plank wool stick"
set "Library_bed.install_requires=plank wool"
set "Library_plank.install_requires= "
set "Library_stick.install_requires= "
set "Library_wood.install_requires= "
set "Library_wool.install_requires= "
set "given=table wool bed"
set "expected= table stick bed plank wool "
call :Library.depends result "!given!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_depends_extra
set "Library.all=plank stick table"
set "Library_table.install_requires=plank stick"
set "Library_plank.install_requires= "
set "Library_stick.install_requires= "
set "Library_stick.extra_requires=table"
set "given=stick stick[extra]"
set "expected= stick table plank "
call :Library.depends result "!given!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_depends_cyclic
set "Library.all=chichen egg"
set "Library_chicken.install_requires=egg"
set "Library_egg.install_requires=chicken"
set "given=chicken egg"
call :Library.depends result "!given!" 2> nul && (
    call %unittest% fail "Given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.Library.test_depends_unresolvable
set "Library.all=magic"
set "Library_magic.install_requires="
set "given=magic"
call :Library.depends result "!given!" 2> nul && (
    call %unittest% fail "Given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.Library.test_search
set "Library.all=plank stick table"
set "Library_plank.args=plank   <width> <height>"
set "Library_stick.args=stick   <length>"
set "Library_table.args=table   <length> <width> <height>"
set "given=eng"
call :Library.search result "eng"
set "expected= stick table "
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_check_extraction
> "dummy.bat" (
    echo :hello
    echo exit /b 0
    echo=
    echo :hello.world
    echo exit /b 0
    echo=
    echo :hi
    echo exit /b 0
)
call :LibBuild.check_extraction "dummy.bat" hello && (
    call %unittest% fail "Success with partial extraction"
)
call :LibBuild.check_extraction "dummy.bat" hi || (
    call %unittest% fail "Fail with full extraction"
)
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b


:: Automatically Added by batchlib 3.2a on Mon 11/18/2024 23:47:42.01

:true
exit /b 0


:unset_all [variable_prefix] ...
for %%p in (%*) do (
    for /f "usebackq tokens=1 delims==" %%v in (`set "%%~p" 2^> nul`) do (
        set "%%v="
    )
)
exit /b 0


:coderender <file> <label> [arg]
setlocal EnableDelayedExpansion EnableExtensions
set "_source_file=%~f1"
set "_label=%~2"
set "_args=%~3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions_range _range "!_source_file!" "!_label!"
call :readline "!_source_file!" !_range! 1 > ".coderender._template" || exit /b 2
for %%f in (code literal) do call 2> ".coderender._%%f"
findstr /n "^" ".coderender._template" > ".coderender._numbered"
call :coderender._group_lines
> ".coderender._render.bat" (
    echo goto coderender._render
    echo=
    echo=
    echo :coderender._render
    type ".coderender._code"
    echo exit /b
    echo=
    echo=
    type ".coderender._literal"
    echo=
    echo=
    type "%~f0"
)
call ".coderender._render.bat" !_args! || exit /b 3
exit /b 0
#+++

:coderender._group_lines
setlocal DisableDelayedExpansion
set "_prev_group="
for /f "usebackq tokens=* delims=" %%o in (".coderender._numbered") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    for /f "tokens=1 delims=:" %%n in ("!_line!") do set "_line_no=%%n"
    set "_line=!_line:*:=!"

    set "_group=code"
    if "!_line:~0,4!" == "::  " set "_group=literal"
    if "!_line:~0,3!" == "::" set "_group=literal"

    if not "!_group!" == "!_prev_group!" (
        if "!_group!" == "literal" (
            >> ".coderender._code" (
                echo call :coderender._type line_!_line_no!
            )
            >> ".coderender._literal" (
                echo :coderender._captured.line_!_line_no!
            )
        )
        if "!_prev_group!" == "literal" (
            >> ".coderender._literal" (
                echo exit /b 0
                echo=
            )
        )
    )
    >> ".coderender._!_group!" (
        echo(!_line!
    )
    for %%g in (!_group!) do (
        endlocal
        set "_prev_group=%%g"
    )
)
if "%_prev_group%" == "literal" (
    echo exit /b 0
    echo=
) >> ".coderender._literal"
exit /b 0
#+++

:coderender._type
call :functions_range _range "%~f0" "coderender._captured.%~1" || exit /b 2
call :readline "%~f0" !_range! 1:-1 4
exit /b 0


:unittest [-f] [-p pattern] [-a target_args] [-o format] [target]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (
    target fail_fast pattern argument output_format output_cmd
) do set "unittest.%%v="
set "unittest.target=%~f0"
set "unittest.pattern=test*.test*"
set "unittest.target_args=-c"
call :argparse2 --name %0 ^
    ^ "[target]:                    set unittest.target" ^
    ^ "[-f,--failfast]:             set unittest.fail_fast=true" ^
    ^ "[-p,--pattern PATTERN]:      set unittest.pattern" ^
    ^ "[-a,--target-args ARGS]:     set unittest.target_args" ^
    ^ "[-o,--output FORMAT]:        set unittest.output_format" ^
    ^ -- %* || exit /b 2
call :unittest._init || (
    1>&2 echo%0: Failed to initialize unittest
    exit /b 4
)
call :unittest._load_tests || (
    1>&2 echo%0: Failed to load tests
    exit /b 4
)
%unittest.output_cmd% start
call :unittest._run
%unittest.output_cmd% stop
call :unittest._cleanup
if defined unittest._failed exit /b 3
exit /b 0
#+++

:unittest._init
set "unittest.start_dir=!cd!"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for %%f in ("unittest") do set "unittest.tmp_dir=%%~ff"
md "!unittest.tmp_dir!"
cd /d "!unittest.tmp_dir!" || exit /b 2
set "tmp_dir=!unittest.tmp_dir!"
rem Make sure unittest is callable from external scripts
call :functions_range _range "%~f0" "unittest" || exit /b 2
> "unittest.bat" (
    echo :entry_point
    echo call %%*
    echo exit /b
    echo=
    echo=
    call :readline "%~f0" !_range!
) || exit /b 3
for %%f in ("unittest.bat") do (
    set unittest="%%~ff" :unittest.outcome %=REQUIRED=%
)
if not defined unittest.output_format (
    set "unittest.output_cmd=echo"
) else if "!unittest.output_format!" == "raw" (
    set "unittest.output_cmd=echo"
) else if "!unittest.output_format!" == "basic" (
    set "unittest.output_cmd=call :unittest.fmt.basic"
) else if "!unittest.output_format!" == "experimental-tap" (
    set "unittest.output_cmd=call :unittest.fmt.etap"
) else if "!unittest.output_format:~0,7!" == "custom:" (
    set "unittest.output_cmd=!%unittest.output_format:~7%!"
)
if not defined unittest.output_cmd (
    1>&2 echo%0: Invalid output format '!unittest.output_format!'. Using default.
    set "unittest.output_cmd=echo"
)
exit /b 0
#+++

:unittest._load_tests
set "unittest.top_dir="
pushd "!unittest.start_dir!"
> "!unittest.tmp_dir!\.unittest_test_cases" (
    for %%f in ("!unittest.target!") do (
        if not defined unittest.top_dir set "unittest.top_dir=%%~dpf"
        call :functions_match _labels "%%~ff" "!unittest.pattern!"
        for %%l in (!_labels!) do echo %%~nf:%%l
    )
)
popd
if not exist "!unittest.top_dir!" exit /b 1
set "unittest.top_dir=!unittest.top_dir:~0,-1!"
exit /b 0
#+++

:unittest._cleanup
cd /d "!unittest.start_dir!"
rd /s /q "!unittest.tmp_dir!"
exit /b 0
#+++

:unittest._run
set "unittest._failed="
set "unittest._test_file="
setlocal EnableDelayedExpansion
for /f "usebackq tokens=1-2 delims=:" %%k in ("%unittest.tmp_dir%\.unittest_test_cases") do (
    if not "%%k" == "!unittest._test_file!" (
        if defined unittest._test_file (
            call "%unittest.top_dir%\!unittest._test_file!" ^
                ^ %unittest.target_args% :tests.teardown
            endlocal
        )
        setlocal EnableDelayedExpansion
        set "unittest._test_file=%%k"
        set "unittest._test_label="
        set "unittest._setup_outcome="
        call "%unittest.top_dir%\%%k" %unittest.target_args% :tests.setup || (
            call :unittest.outcome error ^
                ^ "Test setup did not exit correctly [exit code !errorlevel!]."
        )
    )
    set "unittest._test_label=%%l"
    set "unittest._outcome="
    %unittest.output_cmd% run "!unittest._test_file!","!unittest._test_label!"
    if defined unittest._setup_outcome (
        call :unittest.outcome !unittest._setup_outcome!
    ) else (
        setlocal EnableDelayedExpansion EnableExtensions
        call "%unittest.top_dir%\!unittest._test_file!" ^
            ^ %unittest.target_args% :!unittest._test_label!
        for %%e in (!errorlevel!) do (
            if "%%e" == "0" (
                if not defined unittest._outcome call :unittest.outcome success
            ) else (
                call :unittest.outcome error ^
                    ^ "Test function did not exit correctly [exit code %%e]."
            )
        )
        if defined unittest.fail_fast if defined unittest._failed exit /b 0
        endlocal
    )
)
if defined unittest._test_file (
    call "%unittest.top_dir%\!unittest._test_file!" %unittest.target_args% :tests.teardown
)
exit /b 0
#+++

:unittest.outcome <outcome> [message]
set "unittest._outcome=%~1"
for %%e in (fail error) do if "%~1" == "%%e" (
    set "unittest._failed=true"
)
if defined unittest._test_label (
    %unittest.output_cmd% outcome "!unittest._test_file!","!unittest._test_label!",%1,%2
) else set unittest._setup_outcome=%1,%2
exit /b 0
#+++

:unittest.fmt.basic <action> [args] ...
setlocal EnableDelayedExpansion EnableExtensions
2> nul (
    for /f "usebackq tokens=* delims= eol=#" %%v in (
        "!unittest.tmp_dir!\.unittest.fmt.basic_vars"
    ) do set %%v
)
call :unittest.fmt.basic.%*
> "!unittest.tmp_dir!\.unittest.fmt.basic_vars" (
    for %%v in (
        _start_time _stop_time
        _tests_run _test_count
        _success_count _fail_count _error_count _skip_count
    ) do echo "%%v=!%%v!"
)
exit /b 0
#+++

:unittest.fmt.basic.start
set "_start_time=!time!"
set "_tests_run=0"
set "_test_count="
for /f "usebackq" %%k in ("!unittest.tmp_dir!\.unittest_test_cases") do set /a "_test_count+=1"
for %%e in (success fail error skip) do set "_%%e_count=0"
exit /b 0
#+++

:unittest.fmt.basic.run <test_file> <test_label>
set /a "_tests_run+=1"
call :difftime _elapsed_time !time! !_start_time!
call :ftime _elapsed_time !_elapsed_time!
echo !_elapsed_time! [!_tests_run!/!_test_count!] %~1:%~2
exit /b 0
#+++

:unittest.fmt.basic.outcome <test_file> <test_label> <outcome> [message]
set /a "_%~3_count+=1"
if "%~3" == "success" exit /b 0
if "%~4" == "" echo test '%~1:%~2' %~3
if not "%~4" == "" echo test '%~1:%~2' %~3: %~4
exit /b 0
#+++

:unittest.fmt.basic.stop
set "_stop_time=!time!"
call :difftime _time_taken !_stop_time! !_start_time!
call :ftime _time_taken !_time_taken!
if "!_tests_run!" == "1" (
    set "_s="
) else set "_s=s"
echo=
echo ----------------------------------------------------------------------
echo Ran !_tests_run! test!s! in !_time_taken!
echo=

set "_status=OK"
for %%e in (fail error) do (
    if not "!_%%e_count!" == "0" set "_status=FAILED"
)
< nul set /p "=!_status! "
set "_info= "
if not "!_fail_count!" == "0" set "_info=!_info! failures=!_fail_count!"
if not "!_error_count!" == "0" set "_info=!_info! errors=!_error_count!"
if not "!_skip_count!" == "0"  set "_info=!_info! skipped=!_skip_count!"
set "_info=!_info:~2!"
if defined _info < nul set /p "=(!_info!)"
echo=
exit /b 0
#+++

:unittest.fmt.etap <action> [args] ...
rem TAP output formatter
rem Made for experimental purposes only. Probably not TAP compliant...
setlocal EnableDelayedExpansion EnableExtensions
2> nul (
    for /f "usebackq tokens=* delims= eol=#" %%v in (
        "!unittest.tmp_dir!\.experimental.fmt.tap_vars"
    ) do set %%v
)
call :unittest.fmt.etap.%*
> "!unittest.tmp_dir!\.experimental.fmt.tap_vars" (
    for %%v in (
        _test_number
        _reported
    ) do echo "%%v=!%%v!"
)
exit /b 0
#+++

:unittest.fmt.etap.start
set "_test_number=0"
set "_test_total=0"
for /f "usebackq" %%k in ("!unittest.tmp_dir!\.unittest_test_cases") do set /a "_test_total+=1"
echo 1..!_test_total!
exit /b 0
#+++

:unittest.fmt.etap.run <test_file> <test_label>
set /a "_test_number+=1"
set "_reported="
exit /b 0
#+++

:unittest.fmt.etap.outcome <test_file> <test_label> <outcome> [message]
if defined _reported exit /b 0
if "%~3" == "success" (
    echo ok !_test_number! - %~2
) else if "%~3" == "skip" (
    echo ok !_test_number! - # SKIP %~4
) else (
    echo not ok !_test_number! - %~4
)
set "_reported=true"
exit /b 0
#+++

:unittest.fmt.etap.stop
exit /b 0


:functions_match <return_var> <input_file> <pattern>
setlocal EnableDelayedExpansion EnableExtensions
set "_return_var=%~1"
set "_input_file=%~f2"
set "_pattern=%~3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions_list "!_input_file!" > ".functions_match._tokens" 2> nul || exit /b 2
for /f "usebackq tokens=*" %%l in (".functions_match._tokens") do (
    call :fnmatch "%%l" "!_pattern!" && set "_result=!_result! %%l"
)
for /f "tokens=1* delims= " %%q in ("Q !_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 3
)
exit /b 0


:functions_list <input_file>
setlocal EnableDelayedExpansion EnableExtensions
set "_input_file=%~f1"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
findstr /n /r /c:"^^[!TAB! @]*:[^^: ]" "!_input_file!" ^
    ^ > ".functions_list._tokens" 2> nul ^
    ^ || ( 1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2 )
set "_result="
for /f "usebackq tokens=*" %%o in (".functions_list._tokens") do (
    set "_label=%%o"
    set "_label=!_label:*:=!"
    for /f "tokens=* delims=@%TAB% " %%a in ("!_label!") do set "_label=%%a"
    for /f "tokens=1 delims=:%TAB% " %%a in ("!_label!") do set "_label=%%a"
    echo !_label!
)
exit /b 0


:fnmatch <string> <pattern>
@setlocal EnableDelayedExpansion EnableExtensions
set "_string=%~1"
set "_pattern=%~2"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
for %%v in (_part _pieces _first _last) do set "%%v="
set "_leftover=!_pattern!"
for /l %%n in (1,1,10) do if defined _leftover (
    for /f "tokens=1* delims=*" %%a in ("!_leftover!") do (
        if "%%n" == "1" set "_first=%%a"
        if defined _last set "_pieces=!_pieces!*!_last!!LF!"
        set "_last=%%a"
        set "_leftover=%%b"
    )
)
rem Check for literal string at first and last part
if "!_pattern:~0,1!" == "*" (
    set "_first="
) else set "_pieces=!_first!!LF!!_pieces!"
if "!_pattern:~-1,1!" == "*" (
    if defined _last set "_pieces=!_pieces!*!_last!!LF!"
)
set "_leftover=!_string!"
for /f "tokens=* delims=" %%p in ("!_pieces!") do (
    if not defined _leftover exit /b 3
    set _leftover=!_leftover:%%p=^"!
    if not "!_leftover:~0,1!" == ^"^"^" exit /b 3
    if defined _first (
        set "_leftover=!_string!"
        set "_first="
    ) else set "_leftover=!_leftover:~1!"
)
if "!_pattern:~-1,1!" == "*" exit /b 0
if not defined _last (
    if defined _leftover exit /b 3
    exit /b 0
)
call :strlen _len _last
if /i not "!_leftover:~-%_len%!" == "!_last!" exit /b 3
exit /b 0


:strlen <return_var> <input_var>
set "%~1=0"
if defined %~2 (
    for /l %%b in (12,-1,0) do (
        set /a "%~1+=(1<<%%b)"
        for %%i in (!%~1!) do if "!%~2:~%%i,1!" == "" set /a "%~1-=(1<<%%b)"
    )
    set /a "%~1+=1"
)
exit /b 0


:conemu
@(
    call :conemu.setup
    set "conemu._errorlevel=0"
    call :conemu._loop
    call :conemu.cleanup
)
@exit /b 0
#+++

:conemu._loop
@for /l %%# in (1,1,256) do @for /l %%# in (1,1,256) do @(
    call :conemu._prompt_cmd
)
@goto conemu._loop
#+++

:conemu._prompt_cmd
@call :conemu.prompt
@setlocal EnableDelayedExpansion EnableExtensions
@set "_cmd="
@for /l %%# in (1,1,16) do @for /l %%# in (1,1,16) do @(
    set "_input="
    set /p "_input=" || exit /b 0
    set "_cmd=!_cmd!!_input!"
    if not "!_input:~-1,1!" == "^" @goto conemu._exec_cmd
    set "_cmd=!_cmd:~0,-1!"
    call :conemu.prompt_more
)
exit /b 2
#+++

:conemu._exec_cmd
@(
    goto 2> nul
    set "conemu._errorlevel="
    cmd /c exit /b %conemu._errorlevel%
    %_cmd%
    call set "conemu._errorlevel=%%errorlevel%%"
)
exit /b 1
#+++

:conemu.setup
@(
    set "conemu._parent_prompt=!prompt!"
    prompt $g$s
)
@exit /b 0
#+++

:conemu.cleanup
@(
    prompt !conemu._parent_prompt!
)
exit /b 0
#+++

:conemu.prompt
@(
    setlocal EnableDelayedExpansion
    for /f "usebackq delims=" %%h in (`hostname`) do @( set "_host=%%h" )
    set "_cwd=!cd!\"
    for %%h in ("!userprofile!") do @( set "_cwd=!_cwd:%%~h\=~\!" )
    set "_cwd=!_cwd:~0,-1!"
    set "_prompt=!username!@!_host! !_cwd!"
    if not "!conemu._errorlevel!" == "0" @(
        set "_prompt=!_prompt! [!conemu._errorlevel!]"
    )
    set /p "=!_prompt!> " < nul
)
@exit /b 0
#+++

:conemu.prompt_more
@(
    set /p "=> " < nul
)
exit /b 0


:input_path [-m message] [-b base_dir] [-e|-n] [-f|-d] [-o] [-w] <return_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (
    _return_var _message _base_dir _optional _warn_overwrite
    _check_options
) do set "%%v="
call :argparse2 --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-o,--optional]:         set _optional=true" ^
    ^ "[-b,--base-dir DIR]:     set _base_dir" ^
    ^ "[-w,--warn-overwrite]:   set _warn_overwrite=true" ^
    ^ "[-e,--exist]:            list _check_options= -e" ^
    ^ "[-n,--not-exist]:        list _check_options= -n" ^
    ^ "[-f,--file]:             list _check_options= -f" ^
    ^ "[-d,--directory]:        list _check_options= -d" ^
    ^ -- %* || exit /b 2
if defined _base_dir cd /d "!_base_dir!"
if not defined _message (
    if defined _optional (
        set "_message=Input !_return_var! (optional): "
    ) else set "_message=Input !_return_var!: "
)
call :input_path._loop || exit /b 4
if not defined user_input (
    endlocal
    set "%_return_var%="
    exit /b 3
)
call :endlocal 1 user_input:!_return_var!
exit /b 0
#+++

:input_path._loop
for /l %%# in (1,1,10) do for /l %%# in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        call :check_path user_input !_check_options! && (
            if not defined _warn_overwrite exit /b 0
            if not exist "!user_input!" exit /b 0
            call :input_yesno _ --default N ^
                ^ --message "File already exist. Overwrite file? [y/N] " ^
                ^ && exit /b 0
        )
    ) else if defined _optional exit /b 0
)
echo%0: Too many invalid inputs
exit /b 1


:check_path [-e|-n] [-f|-d] <path_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_require_attrib  _require_exist) do set "%%v="
call :argparse2 --name %0 ^
    ^ "path_var:            set _path_var" ^
    ^ "[-e,--exist]:        set _require_exist=true" ^
    ^ "[-n,--not-exist]:    set _require_exist=false" ^
    ^ "[-f,--file]:         set _require_attrib=-" ^
    ^ "[-d,--directory]:    set _require_attrib=d" ^
    ^ -- %* || exit /b 2
set "_path=!%_path_var%!"
if "!_path:~0,1!!_path:~-1,1!" == ^"^"^"^" set "_path=!_path:~1,-1!"
if not defined _path ( 1>&2 echo%0: Path not defined & exit /b 4 )
set "_temp=!_path!"
if "!_path:~1,1!" == ":" set "_temp=!_path:~0,1!!_path:~2!"
for /f tokens^=1-2*^ delims^=:?^"^<^>^| %%a in ("Q?_!_temp!_") do (
    if not "%%c" == "" ( 1>&2 echo%0: Invalid path characters & exit /b 4 )
)
for /f "tokens=1-2* delims=*" %%a in ("Q*_!_temp!_") do (
    if not "%%c" == "" ( 1>&2 echo%0: Wildcards are not allowed & exit /b 4 )
)
if "!_path:~1!" == ":" set "_path=!_path!\"
set "_file_exist=false"
for %%f in ("!_path!") do (
    set "_path=%%~ff"
    set "_attrib=%%~af"
)
if defined _attrib (
    set "_attrib=!_attrib:~0,1!"
    set "_file_exist=true"
)
if "!_attrib!" == "d" (
    for %%f in ("!_path!\.") do set "_path=%%~ff"
)
if defined _require_exist if not "!_file_exist!" == "!_require_exist!" (
    if "!_require_exist!" == "true" 1>&2 echo%0: Input does not exist
    if "!_require_exist!" == "false" 1>&2 echo%0: Input already exist
    exit /b 3
)
if "!_file_exist!" == "true" if defined _require_attrib if not "!_attrib!" == "!_require_attrib!" (
    if defined _require_exist (
        if "!_require_attrib!" == "d" 1>&2 echo%0: Input is not a folder
        if "!_require_attrib!" == "-" 1>&2 echo%0: Input is not a file
    ) else (
        if "!_require_attrib!" == "d" 1>&2 echo%0: Input must be a new or existing folder, not a file
        if "!_require_attrib!" == "-" 1>&2 echo%0: Input must be a new or existing file, not a folder
    )
    exit /b 3
)
for /f "tokens=* delims=" %%c in ("!_path!") do (
    endlocal
    set "%_path_var%=%%c"
)
exit /b 0


:input_string [-m message] [-f] <return_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_return_var _message _require_filled) do set "%%v="
call :argparse2 --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-f,--filled]:           set _require_filled=true" ^
    ^ -- %* || exit /b 2
if not defined _message set "_message=Input !_return_var!: "
call :input_string._loop || exit /b 4
if not defined user_input (
    endlocal
    set "%_return_var%="
    exit /b 3
)
call :endlocal 1 user_input:!_return_var!
exit /b 0
#+++

:input_string._loop
for /l %%# in (1,1,10) do for /l %%# in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        exit /b 0
    ) else if not defined _require_filled exit /b 0
)
echo%0: Too many invalid inputs
exit /b 1


:endlocal <depth> <old[:new]> ...
setlocal EnableDelayedExpansion
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set "_depth="
set "_content=endlocal!LF!"
for %%v in (%*) do for /f "tokens=1-2 delims=:" %%a in ("%%~v:%%~v") do (
    if not defined _depth (
        set "_depth=%%~v"
    ) else (
        set "_value=#!%%a!"
        set "_value=!_value:\=\\!"
        set "_value=!_value:+=++!"
        set _value=!_value:"=\+22!
        set "_value=!_value:^=\+5E!"
        call set "_value=%%_value:^!=\+21%%"
        set "_content=!_content!%%b=!_value!!LF!"
    )
)
for /f "tokens=* delims= eol=" %%a in ("!_content!") do ^
for /f "tokens=1 delims==" %%r in ("%%a") do ^
if "%%a" == "endlocal" (
    goto 2> nul
    for /l %%i in (1,1,%_depth%) do endlocal
) else (
    set "%%a"
    if "!!" == "" (
        setlocal EnableDelayedExpansion
        set "_de=Enable"
    ) else (
        setlocal EnableDelayedExpansion
        set "_de=Disable"
    )
    for %%e in (!_de!) do (
        if "%%e" == "Enable" (
            endlocal
        )
        set "%%r=!%%r!"
        call set "%%r=%%%%r:\+21=^!%%"
        set "%%r=!%%r:\+5E=^!"
        set %%r=!%%r:\+22="!
        set "%%r=!%%r:\\=\!"
        set "%%r=!%%r:++=+!"
        set "%%r=!%%r:~1!"
        if "%%e" == "Disable" (
            for /f "tokens=* delims= eol=" %%v in ("!%%r!") do (
                endlocal
                set "%%r=%%v"
            )
        )
    )
)
exit /b 0


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
call :updater.read_metadata "!_this!" _this. || (
    1>&2 echo%0: Fail to read metadata & exit /b 3
)
if not defined _dl_url set "_dl_url=!_this.download_url!"
if not defined _dl_url (
    1>&2 echo%0: No download url found & exit /b 3
)
call :download_file "!_dl_url!" "!_other!" || (
    1>&2 echo%0: Download failed & exit /b 3
)
call :updater.read_metadata "!_other!" _other. || (
    1>&2 echo%0: Fail to read metadata & exit /b 3
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
#+++

:updater.read_metadata <script_path> [return_prefix]
call :functions_range _range %1 "metadata" || exit /b 3
call :readline %1 !_range! > ".updater.metadata.bat" || exit /b 3
call ".updater.metadata.bat" %2 || exit /b 3
exit /b 0


:download_file <url> <save_path>
if exist "%~2" del /f /q "%~2"
if not exist "%~dp2" md "%~dp2"
powershell -Command "(New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
if not exist "%~2" exit /b 1
exit /b 0


:ext_powershell
powershell -Command "$PSVersionTable.PSVersion.ToString()"
exit /b


:functions_range <return_var> <input_file> <label ...>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_input_file=%~f2"
set "_labels=%~3"
set "_=!_labels!" & set "_labels= "
for %%l in (!_!) do set "_labels=!_labels!%%l "
for %%v in (_missing _ranges) do set "%%v=!_labels!"
for %%v in (_included _current _start _end) do set "%%v="
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
for /f %%a in ('copy /z "%ComSpec%" nul') do set "CR=%%a"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set _search=^
	^ /c:"^^[!TAB! @]*exit  */b.*!CR!*!LF!!CR!*!LF!" ^
	^ /c:"^^[!TAB! @]*goto  *.*!CR!*!LF!!CR!*!LF!" ^
    ^ /c:"^^[!TAB! @]*:[^^: ]"
findstr /n /r !_search! "!_input_file!" > ".functions_range._tokens" 2> nul || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2
)
for /f "usebackq tokens=*" %%o in (".functions_range._tokens") do ( rem
) & for /f "tokens=1 delims=:" %%n in ("%%o") do (
    set "_line=%%o"
    set "_line=!_line:*:=!"
    for /f "tokens=* delims=@%TAB% " %%a in ("!_line!") do set "_line=%%a"
    if "!_line:~0,1!" == ":" (
        for /f "tokens=1 delims=:%TAB% " %%a in ("!_line!") do set "_line=%%a"
        for %%l in ("!_line!") do (
            if not "!_missing!" == "!_missing: %%~l = !" (
                if defined _current (
                    set "_ranges=!_ranges: %%~l = !"
                    set "_included=!_included! %%~l"
                ) else (
                    set "_current=%%~l"
                    set "_start=%%n"
                )
                set "_missing=!_missing: %%~l = !"
            )
        )
    ) else if defined _current for %%l in ("!_current!") do (
        set "_end=%%n"
        for %%r in (!_start!:!_end!) do set "_ranges=!_ranges: %%~l = %%r !"
        for %%v in (_current _start _end) do set "%%v="
    )
)
for %%l in (!_current!) do (
    for %%r in (!_start!:) do set "_ranges=!_ranges: %%l = %%r !"
)
if "!_missing:~1,1!" == "" (
    set "_missing="
) else (
    1>&2 echo%0: Label not found: !_missing!
    set "_missing=true"
)
for /f "tokens=1* delims=:" %%q in ("Q:!_ranges!") do (
    endlocal
    set "%_return_var%=%%r"
    if "%_missing%" == "true" exit /b 3
)
exit /b 0


:readline <input_file> <range> [offset] [substr]
setlocal EnableDelayedExpansion
set "_input_file=%~f1"
set "_range=%~2"
set "_offset=%~3"
set "_substr=%~4"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :readline._adjust_range || ( 1>&2 echo%0: Invalid arguments & exit /b 2 )
if !_start! LEQ 0 set "_start=1"
if defined _end if !_start! GTR !_end! exit /b 0
if !_start! GTR 1 (
    set /a "_skip=!_start! - 1"
    set "_skip=skip=!_skip!"
) else set "_skip="
findstr /n "^^" "!_input_file!" > ".readline._numbered" || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2
)
setlocal DisableDelayedExpansion
for /f "usebackq %_skip% tokens=*" %%o in (".readline._numbered") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    set "_line=!_line:*:=!"
    if defined _substr set "_line=!_line:~%_substr%!"
    echo(!_line!
    endlocal
    for /f "tokens=1 delims=:" %%n in ("%%o") do if "%%n" == "%_end%" exit /b 0
)
exit /b 0
#+++

:readline._adjust_range
if not defined _range exit /b 2
set "_start="
set "_end="
for /f "tokens=1-2 delims=:" %%a in ("!_range!") do (
    if %%a LSS 1 exit /b 2
    if %%a GTR 2147483647 exit /b 2
    set /a "_start=%%a" || exit /b 2
    if not "%%b" == "" (
        if %%b LSS 1 exit /b 2
        if %%b GTR 2147483647 exit /b 2
        set /a "_end=%%b" || exit /b 2
    )
)
for /f "tokens=1-2 delims=:" %%a in ("!_offset!") do (
    set /a "_start+=%%a" || exit /b 2
    if defined _end if not "%%b" == "" set /a "_end+=%%b" || exit /b 2
)
exit /b 0


:version_parse <return_var> <version>
set "%~1="
setlocal EnableDelayedExpansion
set "_version=%~2"
for /f "tokens=1-3" %%a in ("a !_version!") do (
    if not "%%c" == "" ( 1>&2 echo%0: Version cannot contain whitespaces & exit /b 2 )
    set "_version=%%b"
)
if /i "!_version:~0,1!" == "v" set "_version=!_version:~1!"
call :version_parse._validate_syntax || exit /b
for /f "tokens=1 delims=+" %%a in ("v!_version!") do set "_public=%%a"
set "_public=!_public:~1!"
set "_tmp=!_version!+"
set "_local=!_tmp:*+=!"
if defined _local set "_local=!_local:~0,-1!"
if defined _local if not "!_local:+=!" == "!_local!" (
    1>&2 echo%0: Invalid local version label & exit /b 2
)
if not defined _public (
    1>&2 echo%0: Public version identifier cannot be empty & exit /b 2
)
call :version_parse._transform_public
call :version_parse._transform_local
set "_schemes=Y R E P D L F"
set "_possible_scheme=!_schemes!"
set "_recurring_scheme=R L"
set "_tmp=Y_x_0 !_public! !_local!"
for %%s in (!_possible_scheme!) do set "_tokens_%%s="
for %%p in (!_tmp!) do for /f "tokens=1-2* delims=_" %%s in ("%%p") do (
    set "_type=%%t"
    if "!_possible_scheme:%%s=!" == "!_possible_scheme!" (
        1>&2 echo%0: Invalid segment pattern & exit /b 2
    )
    if "!_recurring_scheme:%%s=!" == "!_recurring_scheme!" (
        set "_possible_scheme=!_possible_scheme:*%%s=!"
    ) else set "_possible_scheme=!_possible_scheme:*%%s=%%s!"
    set "_value=%%u"
    set "_digits=na"
    for /f "tokens=1* delims=0123456789" %%a in ("#0%%u#") do (
        if "%%a,%%b" == "#,#" (
            if "%%s" == "L" set "_type=n"
            for /f "tokens=1* delims=0" %%a in ("#0%%u") do set "_value=%%b"
            if not defined _value set "_value=0"
            for /l %%n in (14,-1,1) do if "!_value:~%%n!" == "" set "_digits=%%n"
            if "!_digits!" == "na" (
                1>&2 echo%0: Digits too long: %%u & exit /b 2
            )
            set "_digits=00!_digits!"
            set "_digits=!_digits:~-2,2!"
        ) else if not "%%s" == "L" (
            1>&2 echo%0: Invalid number: %%p & exit /b 2
        )
    )
    set "_tokens_%%s=!_tokens_%%s! %%s_!_type!_!_digits!_!_value!"
)
set "_tmp="
for %%p in (!_tokens_R!) do set "_tmp=%%p !_tmp!"
set "_tokens_R="
set "_remove=true"
for %%p in (!_tmp!) do (
    if defined _remove (
        if not "%%p" == "R_x_01_0" set "_remove="
    )
    if not defined _remove (
        set "_tokens_R= %%p!_tokens_R!"
    )
)
if not defined _tokens_R set "_tokens_R= R_x_01_0"
set "_result="
for %%s in (!_schemes!) do (
    set "_result=!_result!!_tokens_%%s!"
)
set "_result=!_result! F"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0
#+++

:version_parse._validate_syntax
set "_tmp=.!_version!."
for %%c in (- _ .) do set "_tmp=!_tmp:%%c=.!"
set "_tmp=!_tmp:+=+.!"
if not "!_tmp:..=!" == "!_tmp!" (
    1>&2 echo%0: Invalid version syntax & exit /b 2
)
for %%c in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
    0 1 2 3 4 5 6 7 8 9 +
) do set "_tmp=!_tmp:%%c=.!"
set "_tmp=!_tmp:.=!"
if defined _tmp (
    1>&2 echo%0: Version contains invalid characters & exit /b 2
)
exit /b 0
#+++

:version_parse._transform_public
for %%t in (
    "E_\3: preview pre rc c"
    "E_\2: beta b"
    "E_\1: alpha a"
    "P_x: post rev r"
    "D_x: dev"
) do for /f "tokens=1-2 delims=:" %%r in (%%t) do (
    for %%a in (%%s) do set "_public=!_public:%%a={%%r}!"
)
for %%c in (- _ .) do (
    set "_public=!_public:%%c{={!"
    set "_public=!_public:}%%c=}!"
)
set "_public=.!_public!"
for %%a in (
    "\1=a" "\2=b" "\3=c"
    "{= " "}=_"
    ".= R_x_"
    "-= P_x_"
) do set "_public=!_public:%%~a!"
exit /b 0
#+++

:version_parse._transform_local
if not defined _local exit /b 0
for %%c in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) do set "_local=!_local:%%c=%%c!"
for %%c in (- _ .) do set "_local=!_local:%%c=.!"
set "_local=.!_local!"
set "_local=!_local:.= L_l_!"
exit /b 0


:input_yesno [-m message] [-y value] [-n value] [-d value] [return_var]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_return_var _message) do set "%%v="
set "_yes_value=Y"
set "_no_value=N"
call :argparse2 --name %0 ^
    ^ "return_var:              set _return_var" ^
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
for /f "tokens=* delims=" %%r in ("!_result!") do (
    endlocal
    set "%_return_var%=%%r"
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


:argparse2 [-h] [-d] [-s] [-n NAME] <spec> ... -- %*
setlocal EnableDelayedExpansion
for %%v in (
    _stop_on_extra _help_syntax _dry_run _stop_nonopt _new_name
) do set "%%v="
set "_name=%0"
set "_name=!_name:~1!"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :argparse2._parse_opts %* || exit /b
if "!_new_name:~0,1!" == ":" set "_new_name=!_new_name:~1!"
if defined _help_syntax (
    echo usage: !_name! !_help_syntax! spec ... -- %%*
    echo=
    echo Spec syntax:
    echo     [flags] [name [...]]: ^<action^> ^<dest^>[=const]
    echo=
    echo Actions: set, list, help, end
    exit /b 0
)
call :argparse2._parse_specs %* || exit /b 3
if defined _dry_run exit /b 0
if defined _new_name set "_name=!_new_name!"
call :argparse2._parse_args %* || exit /b 4
call :argparse2._capture_args || exit /b 4
exit /b 0
#+++

:argparse2._parse_opts %*
::  -> _position + options
setlocal EnableDelayedExpansion
call :argparse2._read_opt_spec || exit /b 2
set "_position=0"
set "_stop_on_extra=true"
call :argparse2._parse_args %* || exit /b 3
set _actions=!_actions! "store_const:_position=!_position!"
call :argparse2._capture_args || exit /b 3
exit /b 0
#+++

:argparse2._parse_opt_spec
set "_position=0"
call :argparse2._parse_specs ^
    ^ "[-h,--help]:             help _help_syntax" ^
    ^ "[-d,--dry-run]:          set _dry_run=true" ^
    ^ "[-s,--stop-nonopt]:      set _stop_nonopt=true" ^
    ^ "[-n,--name NAME]:        set _new_name" ^
    ^ -- || exit /b 2
exit /b 0
#+++

:argparse2._read_opt_spec [return_prefix]
set "%~1_position=5"
set "%~1_spec_names="
set "%~1_spec_flags="
set "%~1_spec_flags=!%~1_spec_flags!-1|--| | |stop-opt-parse| | | | !LF!"
set "%~1_spec_flags=!%~1_spec_flags!0|-h,--help| | |help| |true| |_help_syntax!LF!"
set "%~1_spec_flags=!%~1_spec_flags!1|-d,--dry-run| | |set| |true|true|_dry_run=true!LF!"
set "%~1_spec_flags=!%~1_spec_flags!2|-s,--stop-nonopt| | |set| |true|true|_stop_nonopt=true!LF!"
set "%~1_spec_flags=!%~1_spec_flags!3|-n,--name|NAME| |set| |true| |_new_name!LF!"
set "%~1_spec_required= "
set "%~1_known_flags= -- -h --help -d --dry-run -s --stop-nonopt -n --name "
exit /b 0
#+++

:argparse2._parse_specs %*
::  _position
::  -> _position _spec_names _spec_flags _spec_required _known_flags
set "_spec_names="
set "_spec_flags="
set "_spec_required= "
set "_known_flags= "
set "_spec_flags=!_spec_flags!-1|--| | |stop-opt-parse| | | | !LF!"
set "_known_flags=!_known_flags!-- "
call :argparse2._parse_spec_loop %* || (
    call :argparse2._error read_spec "!errorlevel!" >&2
    exit /b 3
)
exit /b 0
#+++

:argparse2._parse_spec_loop %*
for /l %%n in (1,1,!_position!) do shift /1
set _value=%%1
for /l %%# in (1,1,20) do for /l %%# in (1,1,20) do (
    call set _value=%%1
    if not defined _value exit /b 2
    if "!_value!" == "--" (
        set /a "_position+=1"
        exit /b 0
    )
    call set _value=%%~1

    set "_argument="
    set "_action="
    set "_dest="
    for /f "tokens=1* delims=:" %%a in ("!_value!") do (
        set "_argument=%%a"
        for /f "tokens=1*" %%b in ("%%b") do (
            set "_action=%%b"
            set "_dest=%%c"
        )
    )
    set "_has_const="
    for /f "tokens=2 delims==" %%e in ("!_dest!.") do set "_has_const=true"

    if "!_argument:~0,1!!_argument:~-1,1!" == "[]" (
        set "_required="
        set "_argument=!_argument:~1,-1!"
    ) else set "_required=true"

    set "_flags="
    set "_consume_required=true"
    if "!_argument:~0,1!" == "-" (
        for /f "tokens=1*" %%f in ("!_argument!") do (
            set "_flags=%%f"
            set "_argument=%%g"
        )

        if "!_argument:~0,1!!_argument:~-1,1!" == "[]" (
            set "_consume_required="
            set "_argument=!_argument:~1,-1!"
        )
    )
    for /f "tokens=*" %%a in ("!_argument!") do set "_argument=%%a"

    if "!_argument:~-4,4!" == " ..." (
        set "_consume_many=true"
        set "_argument=!_argument:~0,-4!"
    ) else set "_consume_many="

    set "_metavar=!_argument!"

    call :argparse2._validate_spec || exit /b

    if defined _required set "_spec_required=!_spec_required!!_position! "

    for %%v in (_flags _metavar _required _consume_many _consume_required _has_const) do (
        if not defined %%v set "%%v= "
    )

    set "_spec=!_position!|!_flags!|!_metavar!|!_required!|!_action!|!_consume_many!"
    set "_spec=!_spec!|!_consume_required!|!_has_const!|!_dest!"
    if "!_flags!" == " " (
        set "_spec_names=!_spec_names!!_spec!!LF!"
    ) else (
        set "_spec_flags=!_spec_flags!!_spec!!LF!"
    )
    set /a "_position+=1"
    shift /1
)
exit /b 1
#+++

:argparse2._validate_spec
if not defined _flags (
    if not defined _metavar exit /b 4
)
if defined _metavar (
    if "!_metavar:~0,1!" == "[" exit /b 11
    if "!_metavar:~-1,1!" == "]" exit /b 11
    if "!_metavar:~0,1!" == "-" exit /b 12
    if "!_metavar:~-3,3!" == "..." exit /b 13
)
for %%f in (!_flags!) do (
    set "_flag=%%f"
    if not "!_flag:~0,1!" == "-" exit /b 21
    if not "!_flag:~0,2!" == "--" (
        if not "!_flag:~2!" == "" exit /b 24
        if not "!_flag:~1!" == "" (
            for /f "tokens=1* delims=0123456789" %%a in ("!_flag!") do (
                if "%%a%%b" == "-" exit /b 22
            )
        )
    )
    if not "!_known_flags: %%f = !" == "!_known_flags!" exit /b 23
    set "_known_flags=!_known_flags!%%f "
)

set "_valid_actions="
if defined _metavar (
    if defined _flags (
        if defined _consume_many (
            rem Pattern: "--flag METAVAR ..."
            set "_valid_actions=list"
        ) else (
            rem Pattern: "--flag METAVAR"
            set "_valid_actions=set list"
        )
    ) else (
        if defined _consume_many (
            rem Pattern: "METAVAR ..."
            set "_valid_actions=list"
            rem append + const
        ) else (
            rem Pattern: "METAVAR"
            set "_valid_actions=set"
            rem store + const
        )
    )
) else (
    rem Pattern: "--flag"
    set "_valid_actions=set list help end"
)
set "_action_valid="
for %%a in (!_valid_actions!) do (
    if "%%a" == "!_action!" set "_action_valid=true"
)
if not defined _action_valid exit /b 40

if not defined _dest exit /b 50
if defined _has_const (
    if defined _metavar if defined _consume_required exit /b 52
    if "!_action!" == "help" exit /b 52
) else (
    if not defined _metavar if not "!_action!" == "help" exit /b 51
)
exit /b 0
#+++

:argparse2._parse_args %*
::  _position _spec_names _spec_flags _spec_required _stop_on_extra
::  -> _position _actions
set "_arg_start_pos=!_position!"
set "_actions="
set "_parse_opt=true"
set "_consume_action="
set "_new_spec="
set "_surpress_validation="
set "_spec_names_remaining=!_spec_names!"
call :argparse2._parse_arg_loop %* || (
    set "_exit_code=!errorlevel!"
    call :argparse2._error parse_args "!errorlevel!" >&2
    exit /b !_exit_code!
)
if defined _no_consume_action (
    set _actions=!_actions! !_no_consume_action!
)
if defined _surpress_validation (
    exit /b 0
)
for /f "tokens=*" %%a in ("!_spec_required!") do set "_spec_required=%%a"
if defined _spec_required (
    set "_exit_code=5"
    call :argparse2._error parse_args "!_exit_code!" >&2
    exit /b !_exit_code!
)
exit /b 0
#+++

:argparse2._parse_arg_loop %*
for /l %%i in (1,1,!_position!) do shift /1
for /l %%# in (1,1,32) do for /l %%# in (1,1,32) do (
    call set _value=%%1
    if not defined _value (
        if defined _consume_action (
            if defined _consume_required exit /b 4
        )
        exit /b 0
    )
    set "_is_flag="
    if defined _parse_opt (
        if "!_value:~0,1!" == "-" (
            if "!_value!" == "-" set "_is_flag=true"
            for /f "tokens=* delims=0123456789" %%l in ("!_value:~1!.") do if not "%%l" == "." (
                set "_is_flag=true"
            )
        )
    )
    if defined _is_flag (
        set "_new_spec="
        for /f "tokens=* delims=" %%s in ("!_spec_flags!") do if not defined _new_spec (
            for /f "tokens=2 delims=|" %%b in ("%%s") do (
                for %%f in (%%b) do (
                    if "%%f" == "!_value!" set "_new_spec=%%s"
                )
            )
        )
        if not defined _new_spec exit /b 2
    ) else (
        if not defined _consume_action (
            if defined _stop_nonopt (
                if defined _parse_opt set "_parse_opt="
            )
            for /f "tokens=* delims=" %%s in ("!_spec_names_remaining!") do if not defined _new_spec (
                set "_new_spec=%%s"
            )
            if not defined _new_spec (
                if defined _stop_on_extra exit /b 0
                exit /b 3
            )
            set _spec_names_remaining=!_spec_names_remaining:*^%LF%%LF%=!
        )
    )
    if defined _new_spec (
        if defined _consume_action (
            if defined _consume_required exit /b 4
            if defined _no_consume_action (
                set _actions=!_actions! !_no_consume_action!
            )
        )
        if defined _is_flag (
            set "_flag_used=!_value!"
        ) else set "_flag_used="

        for /f "tokens=1-8* delims=|" %%a in ("!_new_spec!") do (
            set "_spec_id=%%a"
            set "_flags=%%b"
            set "_metavar=%%c"
            set "_required=%%d"
            set "_action=%%e"
            set "_consume_many=%%f"
            set "_consume_required=%%g"
            set "_has_const=%%h"
            set "_dest=%%i"
        )
        for %%v in (_flags _metavar _required _consume_required _consume_many _has_const) do (
            if "!%%v!" == " " set "%%v="
        )
        set "_new_spec="

        set "_consume_action="
        set "_no_consume_action="
        for %%a in (set list) do if "!_action!" == "%%a" (
            if defined _metavar (
                if defined _has_const (
                    set _no_consume_action="store_const:!_dest!"
                    for /f "tokens=1 delims==" %%a in ("!_dest!") do (
                        set "_dest=%%a"
                    )
                )
                if defined _flags (
                    set _actions=!_actions! shift
                )
            )
        )
        if "!_action!" == "set" (
            if defined _metavar (
                set _consume_action="store:!_dest!" shift
            ) else (
                set _actions=!_actions! "store_const:!_dest!" shift
            )
        )
        if "!_action!" == "list" (
            if defined _metavar (
                set _consume_action="append:!_dest!" shift
            ) else (
                set _actions=!_actions! "append_const:!_dest!" shift
            )
        )
        if "!_action!" == "help" (
            call :argparse2._generate_help _syntax
            set _actions="store_const:!_dest!=!_syntax!"
            set "_surpress_validation=true"
            exit /b 0
        )
        if "!_action!" == "end" (
            set _actions="store_const:!_dest!"
            set "_surpress_validation=true"
            exit /b 0
        )
        if "!_action!" == "stop-opt-parse" (
            set _actions=!_actions! shift
            set "_parse_opt="
        )

        if defined _required (
            for %%i in (!_spec_id!) do (
                set "_spec_required=!_spec_required: %%i = !"
            )
        )
    )

    if not defined _is_flag if defined _consume_action (
        set _actions=!_actions! !_consume_action!
        if defined _consume_required set "_consume_required="
        if defined _no_consume_action set "_no_consume_action="
        if not defined _consume_many set "_consume_action="
    )
    shift /1
    set /a "_position+=1"
)
exit /b 1
#+++

:argparse2._capture_args $_actions
(
    for /l %%i in (1,1,2) do goto 2> nul
    for %%i in (%_actions%) do ( rem
    ) & for /f "tokens=1* delims=:" %%c in ("%%~i") do (
        if /i "%%c" == "append" (
            call set %%d=^!%%d^!%%1 %=END=%
            set "%%d=!%%d:^^=^!"
        )
        if /i "%%c" == "store" (
            call set "%%d=.%%~1"
            set "%%d=!%%d:^^=^!"
            set "%%d=!%%d:~1!"
        )
        if /i "%%c" == "append_const" (
            for /f "tokens=1* delims==" %%v in ("%%d") do set "%%v=!%%v!%%w "
        )
        if /i "%%c" == "store_const" set "%%d"
        if /i "%%c" == "shift" shift /1
    )
    ( call )
)
exit /b 2
#+++

:argparse2._generate_help <return_var>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_result="
for /f "tokens=1-6* delims=|" %%a in ("!_spec_flags!!_spec_names!") do (
    if %%a GEQ 0 (
        call :argparse2._get_spec "%%a"
        set "_result=!_result! !_full_syntax!"
    )
)
set "_result=!_result:~1!"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0
#+++

:argparse2._error   <context> <exit_code>
setlocal EnableDelayedExpansion
set "_context=%~1"
set "_exit_code=%~2"
set _e=) else if "!_exit_code!" == "$n" (
if "!_context!" == "read_spec" (
    echo !_name!: Invalid spec: "!_value!"
    if "!_exit_code!" == "0" ( rem No error
    %_e:$n=1% echo Unexpected error occurred
    %_e:$n=2% echo Missing -- seperator
    %_e:$n=3% echo No specs were provided
    %_e:$n=4% echo Missing name or flag
    %_e:$n=11% echo Incorrect use of '[]' ^(e.g. usage: '[-u]', '[-u [NAME ...]]'^)
    %_e:$n=12% echo Flags should be seperated by coma, not space ^(e.g.: -u,--user^)
    %_e:$n=13% echo Unexpected use of '...'. It should only be used after the argument name.
    %_e:$n=21%
        if "!_flag:~1!" == "" (
            echo Flag '!_flag!' must start with '-'
        ) else echo Flag '!_flag!' must start with '--'
    %_e:$n=22% echo Number short flags are not supported
    %_e:$n=23% echo Duplicate flag: '!_flag!'
    %_e:$n=24%
        echo Short flag must contain only 1 character ^(e.g.: use '!_flag:~0,2!' or '-!_flag!'^)
    %_e:$n=40% echo Expected action {!_valid_actions!}, got: '!_action!'
    %_e:$n=50% echo Missing destination variable
    %_e:$n=51% echo Missing const
    %_e:$n=52% echo Unexpected const
    ) else echo Got error code !_exit_code!
) else if "!_context!" == "parse_args" (
    set /a "_arg_pos=!_position! - !_arg_start_pos!"
    if "!_exit_code!" == "0" ( rem No error
    %_e:$n=1% echo !_name!: Unexpected error occurred at argument !_arg_pos!: !_value!
    %_e:$n=2% echo !_name!: Unknown flag: !_value!
    %_e:$n=3% echo !_name!: Unexpected positional argument: !_value!
    %_e:$n=4% echo !_name!: Flag '!_flag_used!' requires argument '!_metavar!'
    %_e:$n=5%
        set "_missing_specs="
        for %%i in (!_spec_required!) do (
            call :argparse2._get_spec %%i
            set "_missing_specs=!_missing_specs!, !_display!"
        )
        set "_missing_specs=!_missing_specs:~2!"
        echo !_name!: Missing required arguments: !_missing_specs!
    ) else echo !_name!: Error !_exit_code! at argument !_arg_pos!: !_value!
) else (
    echo !_name!: At '!_context!', got error code !_exit_code! at position !_position!: !_value!
)
exit /b 0
#+++

:argparse2._get_spec <spec_id>
set "_spec_id="
for /f "tokens=1-7* delims=|" %%a in ("!_spec_names!!_spec_flags!") do (
    if "%~1" == "%%a" (
        set "_spec_id=%%a"
        set "_flags=%%b"
        set "_metavar=%%c"
        set "_required=%%d"
        set "_action=%%e"
        set "_consume_many=%%f"
        set "_consume_required=%%g"
        set "_dest=%%h"
        for %%v in (_flags _metavar _required _consume_required _consume_many) do (
            if "!%%v!" == " " set "%%v="
        )

        set "_full_syntax="
        if defined _metavar (
            set "_full_syntax=!_metavar!"
            if defined _consume_many set "_full_syntax=!_full_syntax! ..."
        )
        if defined _flags (
            set "_flag_count=0"
            set "_flags_choice="
            for %%f in (!_flags!) do (
                set "_flags_choice=!_flags_choice!|%%f"
                set /a "_flag_count+=1"
            )
            set "_flags_choice=!_flags_choice:~1!"
            set "_need_parenthesis="
            if !_flag_count! GTR 1 (
                if defined _metavar set "_need_parenthesis=true"
                if defined _required set "_need_parenthesis=true"
            )
            set "_flags_syntax=!_flags_choice!"
            if defined _need_parenthesis (
                set "_flags_syntax=(!_flags_syntax!)"
            )
            if defined _metavar (
                if not defined _consume_required (
                    set "_full_syntax=[!_full_syntax!]"
                )
                set "_full_syntax=!_flags_syntax! !_full_syntax!"
            ) else set "_full_syntax=!_flags_syntax!"
        )
        if not defined _required set "_full_syntax=[!_full_syntax!]"

        set "_display="
        if defined _flags (
            for %%f in (!_flags!) do (
                if not defined _display set "_display=%%f"
            )
        ) else set "_display=!_metavar!"
    )
)
if not defined _spec_id exit /b 2
exit /b 0


:difftime <return_var> <end_time> [start_time] [--no-fix]
set "%~1=0"
for %%t in ("%~2.0" "%~3.0") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t.0.0.0.0") do (
    set /a "%~1+=(1%%a*2-2%%a)*360000 + (1%%b*2-2%%b)*6000 + (1%%c*2-2%%c)*100 + (1%%d*2-2%%d)*100/(2%%d-1%%d)"
    set /a "%~1*=-1"
)
if /i not "%4" == "--no-fix" if "!%~1:~0,1!" == "-" set /a "%~1+=8640000"
exit /b 0


:ftime <return_var> <centiseconds>
setlocal EnableDelayedExpansion
set "_result="
set /a "_remainder=%~2"
for %%s in (360000 6000 100 1) do (
    set /a "_digits=!_remainder! / %%s + 100"
    set /a "_remainder%%= %%s"
    set "_result=!_result!!_digits:~-2,2!:"
)
set "_result=!_result:~0,-4!.!_result:~-3,2!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


