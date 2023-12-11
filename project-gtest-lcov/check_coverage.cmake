if (NOT DEFINED required_coverage)
  message(FATAL_ERROR "required_coverage is not defined.")
endif()

# Read coverage information
execute_process(
  COMMAND lcov --summary coverage.info
  OUTPUT_VARIABLE coverage_summary
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

# Extract the coverage percentage
string(REGEX MATCH "Lines\\s*:\\s*([0-9]+\\.[0-9]+)%" coverage_match "${coverage_summary}")
set(coverage_percentage "${CMAKE_MATCH_1}")

message("Coverage: ${coverage_percentage}%")

# Check if coverage meets the required threshold
if (coverage_percentage LESS required_coverage)
  message(FATAL_ERROR "Error: Coverage is below the required threshold of ${required_coverage}%")
endif()
