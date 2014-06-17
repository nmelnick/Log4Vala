set (BINNAME test-log4vala)

include(ValaPrecompile)

SET( TLOG4VALA_VALA_PACKAGES
	${DEFAULT_PACKAGES}
	posix
)

vala_precompile(TLOG4VALA_VALA_C 
	AbstractTestCase.vala
	TestRunner.vala
	Level.test.vala
	Logger.test.vala
	Layout.SimpleLayout.test.vala
PACKAGES
	${TLOG4VALA_VALA_PACKAGES}
	${PKGNAME}-${PKGVERSION}
OPTIONS
	${DEFAULT_VALA_OPTIONS}
	--vapidir ${CMAKE_BINARY_DIR}/src)

set(TLOG4VALA_CFLAGS
	${CORE_DEPS_CFLAGS_ALL}
	-I${CMAKE_BINARY_DIR}/src
	-w
)
set(TLOG4VALA_LIB_PATHS
	${CORE_DEPS_LIBRARY_DIRS}
	${CMAKE_BINARY_DIR}/src
)
add_definitions(${TLOG4VALA_CFLAGS})
link_directories(${TLOG4VALA_LIB_PATHS})

add_executable(${BINNAME} ${TLOG4VALA_VALA_C})
add_dependencies(${BINNAME} ${PKGNAME}-${PKGVERSION})
target_link_libraries(${BINNAME} ${CORE_DEPS_LIBRARIES} ${PKGNAME}-${PKGVERSION})

include_directories(${CMAKE_BINARY_DIR}/src)
include(Tests)
add_test_executable(${BINNAME})
set(ENV{LD_LIBRARY_PATH} "${CMAKE_BINARY_DIR}/src:$ENV{LD_LIBRARY_PATH}")
