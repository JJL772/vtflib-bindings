cmake_minimum_required(VERSION 3.16)
project(vtflib-bindings C CXX)

find_package(SWIG 4.0 COMPONENTS csharp)
include(${SWIG_USE_FILE})

add_subdirectory(external/vtflib)

set_property(SOURCE "src/vtflib.i" PROPERTY CPLUSPLUS ON)

swig_add_library(VTFLibCS 
	TYPE SHARED
	LANGUAGE csharp 
	OUTPUT_DIR "${CMAKE_CURRENT_LIST_DIR}/src/csharp"
	SOURCES "src/vtflib.i"
)

swig_link_libraries(
	VTFLibCS vtflib_static
)

set_property(TARGET VTFLibCS PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES TRUE)

target_include_directories(
	VTFLibCS PUBLIC

	external/vtflib/VTFLib
)

# TODO: Probably should check if dotnet is even installed!
add_custom_command(
	TARGET VTFLibCS
	
	POST_BUILD
	COMMAND dotnet build -c Release "${CMAKE_CURRENT_LIST_DIR}/src/csharp/VTFLibCS.csproj" -o "${CMAKE_BINARY_DIR}"
)