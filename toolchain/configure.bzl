_links = {
    "7-2018-q2-update": {
        "linux": "https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2",
        "mac os x": "https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-mac.tar.bz2",
    },
}

_sha256 = {
    # 7-2018-q2-update
    "gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2": "bb17109f0ee697254a5d4ae6e5e01440e3ea8f0277f2e8169bf95d07c7d5fe69",
    "gcc-arm-none-eabi-7-2018-q2-update-mac.tar.bz2": "c1c4af5226d52bd1b688cf1bd78f60eeea53b19fb337ef1df4380d752ba88759",
}

_strip_prefix = {
    "7-2018-q2-update": "gcc-arm-none-eabi-7-2018-q2-update",
}

def _gcc_arm_none_eabi_toolchain(rctx):
    substitutions = {
        "%{path_prefix}": (str(rctx.path("")) + "/"),
    }

    # Generate files from templates
    rctx.template(
        "CROSSTOOL",
        Label("@gcc_arm_none_eabi//toolchain:tpl/CROSSTOOL.tpl"),
        substitutions,
    )
    rctx.template(
        "BUILD",
        Label("@gcc_arm_none_eabi//toolchain:tpl/BUILD.tpl"),
        substitutions,
    )

    link = _links[rctx.attr.gcc_version][rctx.os.name]
    rctx.download_and_extract(
        link,
        sha256 = _sha256[link.rpartition("/")[-1]],
        stripPrefix = _strip_prefix[rctx.attr.gcc_version],
    )

gcc_arm_none_eabi_toolchain = repository_rule(
    attrs = {
        "gcc_version": attr.string(
            default = "7-2018-q2-update",
            doc = "The GCC arm-none-eabi version to use",
        ),
        "absolute_paths": attr.bool(
            default = False,
            doc = "Use absolute paths to avoid sandbox overhead",
        ),
    },
    local = False,
    implementation = _gcc_arm_none_eabi_toolchain,
)
