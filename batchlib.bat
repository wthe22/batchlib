:entry_point
@goto main


rem ############################################################################
rem License
rem ############################################################################

:license
echo MIT No Attribution
echo=
echo Copyright 2017-2025 wthe22
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
::  - New functions: list_lf2set, ini_edit, get_net_iface
::  - Bug fixes: color_print, endlocal, quicktest, strip, input_yesno
::  - Behavior changes: quicktest, check_path, strip
::  - Global variable usage changes: functions_list, functions_range, macroify,
::    strip
::  - Breaking changes: argparse, coderender, unittest, endlocal
::  - Deprecated / removed: ut_fmt_basic, argparse
::  - License: Remove attribution requirement (MIT No Attribution)
::
::  Core
::  - Include unittest() to library in debug mode
::  - Remove '-c' subcommand requirement to build script
::  - Add build script warning when ':entry_point' is not at line 1
::
::  Library
::  - Functions now initialize required constants and macros, then saving them as
::    shared global variables
::  - Recategorize functions
::  - list_lf2set(): New! Similar to list2set() but with Line Feed seperator
::  - ini_edit(): New! INI configuration file editor
::  - get_net_iface(): NEW! Get network interface data (experimental)
::
::  - argparse():
::      - Reworked spec syntax
::      - Help flag detection and auto-generated usage syntax
::      - Required/optional spec detection
::      - A single flag can now capture multiple arguments
::  - check_path(): Adjust exit status so invalid argument
::                  errors are distinguishable
::  - coderender():
::      - Add option to generate codes to render
::      - Changed the way arguments are passed to template
::  - combi_wcdir(): Simplify code by using list_lf2set()
::  - endlocal():
::      - Fix string gets executed when it contains ampersand
::      - Add ability to quit multiple stacks of setlocal
::      - Add ability to exit to access parent context
::      - Function signature change
::      - Add support for returning LF characters in EnableDelayedExpansion
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
::      - Special characters in variable can now be safely processed
::      - Double quotes can now be stripped
::      - Support stripping multiple characters at the same time
::      - Function can now be converted to macro by using macroify()
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
::  - Fix argument syntax of: quicktest, hexlify, argparse
::  - Fix demo of: unittest
::  - Improve some documentations
::  - macroify(): Add details on creating and using macros
::  - Template subcommand will list available template when no name is given
::  - Mark functions as required or optional in template.bat
::  - Add new subcommand to view documentation of a script
exit /b 0


:changelog.dev
::  - ini_parse():
::      - Rename from ini_parse()
::      - Leave value as-is
::      - Add command to get sections and keys
::      - Use variables and macro to improve performance
::  - coderender():
::      - Add option to generate codes to render
::      - Changed the way arguments are passed to template
::  - endlocal():
::      - Add ability to exit to access parent context
::      - Add support for returning LF characters in EnableDelayedExpansion
::  - strip():
::      - Support stripping multiple characters at the same time
::  - input_string(), input_path(): Use new syntax of endlocal()
::  - macroify()
::      - Add a dot in front of global variables
::  - color_print(): Reduce chances of overwriting other temp files
::  - diffbin(), hexlify(), wait(), watchvar():
::      - Add prefix to temporary files
::  - functions_list(), functions_range(), ini_parse(), macroify(), strip():
::      - Use shared global variables for constants and macros
exit /b 0

rem ############################################################################
rem Metadata
rem ############################################################################

:metadata [return_prefix]
set "%~1name=batchlib"
set "%~1version=3.2b"
set "%~1authors=wthe22"
set "%~1license=MIT No Attribution"
set "%~1description=Batch Script Library"
set "%~1release_date=01/29/2025"   :: mm/dd/YYYY
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
echo Copyright (C) 2017-2025 by !authors!
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
    "cli: Command Line Interface"
    "debug: Debugging Tools"
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
