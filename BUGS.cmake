* VTK does not build correctly when VTK_USE_SYSTEM_HDF5 is ON and HDF5 was built
  with HL enabled (which is needed for NetCDF). To solution currently  is to
  manually edit the CMake variable HDF5_C_LIBRARY to be
  <INSTALL_DIR>/lib/libhdf5.so;<INSTALL_DIR>/lib/libhdf5_hl.so
  It cannot be set in paraview.cmake file, unfortunately.

