set(PROGRAM_UPDATE_COMMAND "") # found http://www.cmake.org/pipermail/cmake/2014-February/056988.html
ExternalProject_Add(	googletest
						SVN_REPOSITORY http://googletest.googlecode.com/svn/trunk
						# Force separate output paths for debug and release builds to allow easy
						# identification of correct lib in subsequent TARGET_LINK_LIBRARIES commands
						CMAKE_ARGS -DCMAKE_CXX_FLAGS='-D_VARIADIC_MAX=10'
							-Dgtest_force_shared_crt=ON
							-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
						# Disable install step
						INSTALL_COMMAND ""
						UPDATE_COMMAND ${PROGRAM_UPDATE_COMMAND}
					)