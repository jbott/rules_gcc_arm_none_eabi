load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

def _impl(ctx):
    output = ctx.outputs.out
    input = ctx.file.src
    cc_toolchain = find_cpp_toolchain(ctx)
    objcopy = cc_toolchain.objcopy_executable()

    ctx.action(
        inputs=[input],
        outputs=[output],
        progress_message="Creating ihex binary from %s" % input.short_path,
        command="%s -O ihex %s %s" % (objcopy, input.path, output.path))

ihex_binary = rule(
    implementation = _impl,
    fragments = ["cpp"],
    attrs = {
        "src": attr.label(mandatory=True, allow_files=True, single_file=True),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")
        ),
    },
    outputs = {
        "out": "%{src}.hex"
    },
)
