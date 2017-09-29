set(REDIS_MOD ../src/redis_mod.f90)

foreach(exe test_connect test_redis_push test_getuniq test_pub game_of_life)

  add_executable(${exe} ${exe}.f90 ${REDIS_MOD})
  target_link_libraries(${exe} geostreams hiredis gfortran)

endforeach(exe)
