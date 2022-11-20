add_library(soa bitmap_soa.cpp)
find_package(OpenMP REQUIRED)
target_link_libraries(soa common OpenMP::OpenMP_CXX)
target_include_directories(soa PUBLIC ..)
