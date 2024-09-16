# compile_chroma_etc

These scripts work as of 2024-09-16

make an `env_machine.sh` file, then `cp env_machine.sh env.sh` and the build should work following the order in `build_all.sh`.

The `env.sh` is set up to accept `CPU` or NO ARGUMENT to help build the `CPU` of `GPU` version of the code.  Note - the `LD_LIBRARY_PATH` and modules loaded depend if it is `CPU` or `GPU` type build.
