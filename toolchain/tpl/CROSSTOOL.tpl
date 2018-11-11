major_version: "local"
minor_version: ""
default_target_cpu: "cortex-m4"

default_toolchain {
  cpu: "cortex-m4"
  toolchain_identifier: "cortex-m4-none"
}

toolchain {
  abi_version: "arm-none-eabi"
  abi_libc_version: "arm-none-eabi"
  builtin_sysroot: ""
  compiler: "compiler"
  host_system_name: "local"
  needsPic: false
  supports_gold_linker: false
  supports_incremental_linker: false
  supports_fission: false
  supports_interface_shared_objects: false
  supports_normalizing_ar: false
  supports_start_end_lib: false
  supports_thin_archives: false
  target_libc: "cortex-m4-none"
  target_cpu: "cortex-m4"
  target_system_name: "cortex-m4-none"
  toolchain_identifier: "cortex-m4-none"

  # Tool paths
  tool_path { name: "ar" path: "%{path_prefix}bin/arm-none-eabi-ar" }
  tool_path { name: "compat-ld" path: "bin/arm-none-eabi-ld" }
  tool_path { name: "cpp" path: "%{path_prefix}bin/arm-none-eabi-cpp" }
  tool_path { name: "gcc" path: "%{path_prefix}bin/arm-none-eabi-gcc" }
  tool_path { name: "gcov" path: "%{path_prefix}bin/arm-none-eabi-gcov" }
  tool_path { name: "ld" path: "%{path_prefix}bin/arm-none-eabi-ld" }
  tool_path { name: "nm" path: "%{path_prefix}bin/arm-none-eabi-nm" }
  tool_path { name: "objcopy" path: "%{path_prefix}bin/arm-none-eabi-objcopy" }
  tool_path { name: "objdump" path: "%{path_prefix}bin/arm-none-eabi-objdump" }
  tool_path { name: "strip" path: "%{path_prefix}bin/arm-none-eabi-strip" }

  compiler_flag: "-mcpu=cortex-m4"
  compiler_flag: "-mthumb"
  linker_flag: "-mcpu=cortex-m4"
  linker_flag: "-mthumb"

  cxx_flag: "-std=c99"
  linker_flag: "-lc"
  linker_flag: "-lm"

  # Utilize "nano" libc and libstdc++. These are included in the Debian
  # libstdc++-arm-none-eabi package. They are built with no exceptions and
  # short wchar to reduce code and data size.
  compiler_flag: "-specs=nano.specs"
  compiler_flag: "-specs=nosys.specs"
  linker_flag: "-specs=nano.specs"
  linker_flag: "-specs=nosys.specs"

  compiler_flag: "-fno-exceptions"
  compiler_flag: "-fshort-wchar"
  # crtbegin.o is unfortunately not built with -fshort-wchar, so the linker
  # complains, but we know it doesn't actually use wchar_t.
  linker_flag: "-Wl,--no-wchar-size-warning"

  # TODO(bazel-team): In theory, the path here ought to exactly match the path
  # used by gcc. That works because bazel currently doesn't track files at
  # absolute locations and has no remote execution, yet. However, this will need
  # to be fixed, maybe with auto-detection?
  cxx_builtin_include_directory: "%{path_prefix}lib/gcc/"
  cxx_builtin_include_directory: "%{path_prefix}include"
  cxx_builtin_include_directory: "%{path_prefix}arm-none-eabi/include"
  # cxx_builtin_include_directory: "%{path_prefix}include"

  # C(++) compiles invoke the compiler (as that is the one knowing where
  # to find libraries), but we provide LD so other rules can invoke the linker.
  objcopy_embed_flag: "-I"
  objcopy_embed_flag: "binary"

  # Always enable debug symbols, since only raw binaries will be deployed
  # anyways.
  compiler_flag: "-g"

  compilation_mode_flags {
    mode: OPT
    # Optimize for size.
    compiler_flag: "-Os"

    # Removal of unused code and data at link time.
    compiler_flag: "-ffunction-sections"
    compiler_flag: "-fdata-sections"
    linker_flag: "-Wl,--gc-sections"
  }
}
