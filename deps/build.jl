@static if VERSION < v"1.3.0"

using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, "libsqlite3", :libsqlite),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/SQLite_jll.jl/releases/download/SQLite-v3.31.1+0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/SQLite.v3.31.1.aarch64-linux-gnu.tar.gz", "4988c1adca1eefca51738138ba102b4f841e737f68177610746b6a1bc47026b1"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/SQLite.v3.31.1.aarch64-linux-musl.tar.gz", "ff0618c4f01b219dc1767ec86d3845e0d47cd7969f721d52085db10789a605f0"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/SQLite.v3.31.1.armv7l-linux-gnueabihf.tar.gz", "c9c66119e24d83ee440a79668657b54f0398cb2ebf186cd2cc1774e160f43de7"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/SQLite.v3.31.1.armv7l-linux-musleabihf.tar.gz", "3cb9654a11b8888b128a7f1e28cb7f585bf2f39121b1b4625c29b9ff4a3912d1"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/SQLite.v3.31.1.i686-linux-gnu.tar.gz", "02f29a2b9ebdd8300c513e39c49e6d5c1b1dee46ff7a3df3c31e30fc4c3f4728"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/SQLite.v3.31.1.i686-linux-musl.tar.gz", "0b211226e2d969e23876cf5a0975dc5a9abc05848349c18e92c6fa4b3147a946"),
    Windows(:i686) => ("$bin_prefix/SQLite.v3.31.1.i686-w64-mingw32.tar.gz", "e3db972094bcb86c6d3a7a845f14f328999ad380e6bcad53db104a1a48fa05fa"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/SQLite.v3.31.1.powerpc64le-linux-gnu.tar.gz", "88c191f00c801a5701fe00f55db968d9e609de6b19d112721f990e24aabf9334"),
    MacOS(:x86_64) => ("$bin_prefix/SQLite.v3.31.1.x86_64-apple-darwin14.tar.gz", "3cefd1e9d7c775936aa131515b83ea4cb754af5a4a5a872b4e1a53f1f5c472c1"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/SQLite.v3.31.1.x86_64-linux-gnu.tar.gz", "ad27dfd75aa8e7d3822d6d7c58a6f0daf94e8e995427a877084cbb4dd466f91a"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/SQLite.v3.31.1.x86_64-linux-musl.tar.gz", "d333808f3437e8d46ef9ea5dcabaa3eb7a101da18064c2bf95f82b8a2a6b4921"),
    FreeBSD(:x86_64) => ("$bin_prefix/SQLite.v3.31.1.x86_64-unknown-freebsd11.1.tar.gz", "a4c4e34da8cf80047a4ad4764e728541ea9d00274bc59be802b2e567cc871ea7"),
    Windows(:x86_64) => ("$bin_prefix/SQLite.v3.31.1.x86_64-w64-mingw32.tar.gz", "a3e1fd2ade228a62ca0969632a50a5528e294086ebf515cdc59e384ffb87cfc2"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)

end # VERSION