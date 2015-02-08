#cmake-tools

A set of simple **cmake** functions (based on *gtest* project from Google) automatizing tasks such as library creating, managing tests, etc. under **cmake** build system. Assumes the following root-project tree:
   
    /
    | - include
    |      | - module1
    |      | - module2
    |      | - module3
    |
    | - src
    |     | - module1
    |     | - module2
    |     | - module3
    |
    | - tests 
    |     | - module1
    |     | - module2
    |     | - module3
    |
    | - Externals

Every module must contain direct call of `project(${LOCAL_PROJECT_NAME})` where *${LOCAL_PROJECT_NAME}* is unique for every module within the whole project and agree with directory name that the module exists in. Folder *Externals* contains external projects that main project depends on. External projects are assumed to be projects controlled by `ExternalProject_Add` macro (in contrary to `git submodules`).

##Usage

Clone this repository to root of your project. Add configuration in main `CMakeLists.txt`:

  * `set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-tools/cmake-modules)`
  * `include(cmake-tools/tools.cmake)`

##Available functions

####getPathToExternals()
Collects paths for external projects (managed by `ExternalProject_Add`). Returns to caller two variables:
  * `ALL_EXTERNAL_INCS`
  * `ALL_EXTERNAL_INCS`
that contain paths to includes and libraries respectively. These variables are not added to *cmake* cache globally.

----
####addSubirectories(curdir)
Adds all sub-directories in current directory for processing by *cmake*. `CMakeLists.txt` is expected to be present in every sub-directory.

#####Example
```
addSubirectories(${CMAKE_CURRENT_LIST_DIR})
```

----
####addTest(LOCAL_PROJECT_NAME libs dependencies)
Creates test case form current source directory. Assumes that all files (*.h*, *.cpp*, *.rc*, *.hpp*) present in current directory are the part of test case target. Files are added to target by `file(GLOB ... )` therefore changes in this directory may not be noticed by *cmake* without re-run. 
The `addTest` function guarantee that include files and compiled targets from all external projects will be found due to internal call of the function `getPathToExternals`. 

#####Parameters:

  * `libs` - list of libriaries to link to test
  * `dependencies` - list of targets that current test depend on
 
#####Example

```
set(LOCAL_PROJECT_NAME lib_test)
project(${LOCAL_PROJECT_NAME})
set(dependencies PBToolset)
set(libs lib_test_static MatlabExchange)
addTest(${LOCAL_PROJECT_NAME} "${libs}" "${dependencies}")
```

#####Remarks
It assumed that all project include files resist in *${CMAKE_SOURCE_DIR}/include* sub-directory. This folder is added to *cmake* include search path as well.

---------
####addLibrary(type LOCAL_PROJECT_NAME LIBRARY_NAME libs dependencies sources)
Builds static or shared library from `sources`. Adds also paths for external dependencies (targets and includes) and for *${CMAKE_SOURCE_DIR}/include* (see *Remarks* for `addTest`). 

#####Parameters:

  * `type` - type of target: *SHARED* or *STATIC*
  * `LOCAL_PROJECT_NAME` - name of the local project (the same as in `project(${LOCAL_PROJECT_NAME})` function
  * `LIBRARY_NAME ` - name of the target
  * `libs` - list of libriaries to link to target
  * `dependencies` - list of targets that current test depend on
  * `sources` - list of source files to build as well as includes and resources if needed. It is not necessary to put here includes but if it done they will be visible under Visual Studio project. If includes are stored in *${CMAKE_SOURCE_DIR}/include/ ${LOCAL_PROJECT_NAME}* it is not necessary to provide full path.

#####Example

```
project(${LOCAL_PROJECT_NAME})
# extra definitions can be passed here
add_definitions("-D_VARIADIC_MAX=10")
set(lib Geom levmar${CMAKE_FIND_LIBRARY_SUFFIXES} f2c blas tmglib lapack)
set(dep setError PBToolset levmar clapack)
addLibrary(	STATIC 							# type
			${LOCAL_PROJECT_NAME}			# name of the project
			${LOCAL_PROJECT_NAME}_static	# name of the LIBRARY
			"${lib}"						# libs to link (if any)
			"${dep}"						# dependencies (if any)
			C_LineInterp.cpp C_LineInterp.h
			) # files to build

set(libs setError ${LOCAL_PROJECT_NAME}_static)
set(dep setError PBToolset)
addLibrary(	SHARED 							# type
			${LOCAL_PROJECT_NAME}			# name of the project
			${LOCAL_PROJECT_NAME}			# name of the LIBRARY
			"${libs}"						# libs to link
			"${dep}"						# dependencies
			dllmain.cpp LV_WeldDetectApprox_DLL_Wrapper.cpp) # files to build
```

##External projects

Folder *cmake-externals* contains ready to use snippets for some external projects such as Google Testing Framework, Boost and others.  They can be easily added to main project juts by including the following lines in *CMakeLists.txt* resisting by default in *Externals* sub-directory :

```
project("Externals")
include(${CMAKE_SOURCE_DIR}/cmake-tools/cmake-externals/googletest.cmake)
```
Such snippets are linked and developed together with `getPathToExternals()` function.

####List of external project snippets

| Project		|	*cmake* name|
| ------------- |:-------------:|
| Goolge Testing|googletest		|

