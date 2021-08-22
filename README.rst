Batchlib
########
Collections of reusable functions/snippets for Batch Script.

These functions can be used by simply copy, paste it and CALL the function.
Concept of the script have been refined over the years to allow easier
development in Batch Script.

Features
--------
* Easy to use, suitable for beginners
* Powerful, suitable for hardcore batch script users
* Does not use global variables (otherwise specified in documentation)
* Extensive documentation and demo
* Functions have unittest and demo so functionality can be tested before use
* Library dependency management for scripts

First Time Use
--------------
For first time use, run ``setup.bat`` to do the setups. If the setup is
successful, running ``setup.bat`` again will build libraries and run unittests.

A good way to get stated with batchlib is to explore the features and libraries
first. After you are somehow familiar with them, generate a `Template For New
Scripts`_, read the documentations inside, and try to make something out of it.

Template For New Scripts
------------------------
To take full advantage of batchlib, there are some structures to follow.
Use the template script ``template.bat`` as your starting point. It has all
the recommended structures to work flawlessly with batchlib.
There are guides inside to help you get started.

Dependency Management
-------------------------------
Batchlib have an automated way of adding libraries into a script. Use the
`Template For New Scripts`_ and specify the dependencies in this section of
the script:
::

    :lib.dependencies
    set "%~1install_requires=<your_dependencies_here>"
    exit /b 0

And run:
::

    # Add dependencies to file
    cmd /c batchlib.bat build your_script_name.bat

    # Or build with backup
    cmd /c batchlib.bat build your_script_name.bat backup_name.bat

And batchlib will magically add the libraries into your script! Backup file can
be specified if necessary. When you have changed the dependency list, you can
run the same code again to update the libraries.

Adding Your Own Functions To Library
------------------------------------
You can use the template for new library as the starting point.
Copying the library template and rename it:
::

    copy lib\new_lib_template.bat lib\your_library_name.bat

This template contains all the structures you need for your function to work
correctly with Batchlib. There are documentations inside to help you.

Minified Batchlib
-----------------
Minified Batchlib is a stripped down and packed version of Batchlib.

The differences are:

* All library functions (only the function) are compiled into the file.
* No library docs, demo, or tests included.
* Command line interface instead of menu interface.

To generate it, type:
::

    cmd /c batchlib.bat template minified > batchlib-min.bat

Unit Testing Your Script
------------------------
There are 2 unit testing frameworks: unittest() and quicktest(). Unittest() is
the powerful one (supports test suite), and quicktest() is the expressive one.
Both have the same syntax so compatibility is not a problem.

For more information, you can read the documentation of unittest().

TAP Compliance
^^^^^^^^^^^^^^
Neither unittest() or quicktest() are `TAP <http://testanything.org/>`_
compliant. However, after skimming through the specs, I think the output of
unittest() can be easily formatted to TAP.
