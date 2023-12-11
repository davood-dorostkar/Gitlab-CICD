cmake_minimum_required(VERSION 3.5)

project(RunAllTests LANGUAGES CXX)

# Set C++ standard (change as needed)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Download and include Google Test
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

include_directories(${CMAKE_SOURCE_DIR}/src)

# Use globbing to collect C++ source files
file(GLOB SRC_COMMON ${CMAKE_SOURCE_DIR}/src/*.cpp)
list(REMOVE_ITEM SRC_COMMON ${CMAKE_SOURCE_DIR}/src/main.cpp ${CMAKE_SOURCE_DIR}/src/main_test.cpp)

file(GLOB SRC_TEST ${CMAKE_SOURCE_DIR}/test/*.cpp)



# Add the target for the tests
add_executable(${PROJECT_NAME} ${SRC_TEST} ${SRC_COMMON})

# Link against Google Test libraries
target_link_libraries(${PROJECT_NAME} gtest gtest_main)

# Set compiler flags for coverage (modify as needed)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -g -I${CMAKE_PREFIX_PATH}/include/ --coverage")

# Link against the necessary libraries
#target_link_libraries(${PROJECT_NAME} ipceng threadMgmt -llogger -lutil -lsqlite3 -ljansson mm)

# Enable testing
enable_testing()

# Add a test target
# add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})

# Use gtest_discover_tests after adding the test executable
include(GoogleTest)
gtest_discover_tests(${PROJECT_NAME} WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

add_custom_target(coverage
  COMMAND lcov --capture --directory ${CMAKE_SOURCE_DIR}/src --directory ${CMAKE_BINARY_DIR}/CMakeFiles/RunAllTests.dir --output-file coverage.info
  COMMAND lcov --remove coverage.info '/usr/*' --output-file coverage.info
  COMMAND lcov --remove coverage.info ${SRC_TEST} --output-file coverage.info
  COMMAND lcov --remove coverage.info '${CMAKE_BINARY_DIR}/_deps/*' --output-file coverage.info
  COMMAND lcov --remove coverage.info '${CMAKE_BINARY_DIR}/src/main_test.cpp' --output-file coverage.info
  COMMAND lcov --remove coverage.info '${CMAKE_BINARY_DIR}/src/main.cpp' --output-file coverage.info
  # COMMAND ${CMAKE_COMMAND} -E env required_coverage=70 ${CMAKE_SOURCE_DIR}/check_coverage.cmake
 # COMMAND genhtml coverage.info --output-directory coverage-report
 # COMMAND cutycapt --url=file://${CMAKE_BINARY_DIR}/coverage-report/index.html --out=${CMAKE_BINARY_DIR}/coverage-screenshot.png
 # COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/coverage-screenshot.png ${CMAKE_SOURCE_DIR}/coverage-screenshot.png
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

add_custom_target(run_tests_with_coverage
  COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
  COMMAND make coverage
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/coverage-report ${CMAKE_SOURCE_DIR}/coverage-report
  DEPENDS ${PROJECT_NAME} coverage
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

