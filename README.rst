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
successful, running ``setup.bat`` again will only run unittests.

A good way to get stated with batchlib is to explore the features and libraries
first. After you are somehow familiar with them, generate a `Template For New
Scripts`_, read the documentations inside, and try to make something out of it.

Template For New Scripts
------------------------
To take full advantage of batchlib, there are some structures to follow.
Batchlib can generate a template that have all the recommended structures
for you. To generate it, type:
::

    cmd /c batchlib.bat template new_script > your_script_name.bat

Now you can use this newly generated script as your starting point.
There are guides inside to help you get started.

Dependency Management
-------------------------------
Your script might use some library functions of batchlib and you decided to copy
them into your script. But some library have dependencies, and its dependencies
might have dependencies too. You might not know which to copy.

To make things easier, use the `Template For New Scripts`_ and specify the
dependencies in this section of the script:
::

    :lib.build_system
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
run the same code again to reinstall the libraries.

Adding Your Own Functions To Library
------------------------------------
First, we need to generate a template for the library. To generate it, type:
::

    cmd /c batchlib.bat template new_library > lib\your_library_name.bat

This template contains all the structures you need for your function to work
correctly with Batchlib. Now you can start adding your own library function.

Minified Batchlib
-----------------
Minified Batchlib is a stripped down version of Batchlib. The differences are:

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

In this project, unittests are placed inside the script to be tested (not in a
seperate file, but could be seperate if you want to).
For more information, you can read the documentation of unittest().

TAP Compliance
^^^^^^^^^^^^^^
Neither unittest() or quicktest() are `TAP <http://testanything.org/>`_
compliant. However, after skimming through the specs, I think the output of
unittest() can be easily formatted to TAP.
