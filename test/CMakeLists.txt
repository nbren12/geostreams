add_executable(test_send test_send.f90 redis_mod.f90)
target_link_libraries(test_send geostreams hiredis gfortran)
