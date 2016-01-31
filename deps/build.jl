using BinDeps
using Compat

@BinDeps.setup

libgsl = library_dependency("libgsl", aliases="libgsl-0")

# package managers
provides(AptGet, @compat Dict("libgsl0ldbl"=>libgsl, "libgsl0-dev" =>libgsl, "gsl-bin"=>libgsl))
provides(Yum, "gsl-devel", libgsl)
provides(Pacman, "gsl", libgsl)

@osx_only begin
    if Pkg.installed("Homebrew") === nothing
        error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
    end
    using Homebrew
    provides(Homebrew.HB, "gsl", libgsl, os = :Darwin)
end

@windows_only begin
     using WinRPM
     provides(WinRPM.RPM, "gsl", libgsl, os = :Windows)
end

# build from source
provides(Sources, URI("http://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"), libgsl)
provides(BuildProcess, Autotools(libtarget = "libgsl.la"), libgsl)

#@show macroexpand(:(@BinDeps.install Dict(:libgsl => :libgsl)))
#eval(macroexpand(:(@BinDeps.install Dict(:libgsl => :libgsl))))
load_cache = Dict() # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 781:
        pre_hooks = Set{AbstractString}() # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 782:
        load_hooks = Set{AbstractString}() # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 783:
        if bindeps_context.do_install # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 784:
            for d = bindeps_context.deps # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 785:
                p = BinDeps.satisfy!(d) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 786:
                libs = BinDeps._find_library(d; provider=p) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 787:
                if isa(d,BinDeps.LibraryGroup) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 788:
                    if !(isempty(libs)) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 789:
                        for dep = d.deps # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 790:
                            !(BinDeps.applicable(dep)) && continue # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 791:
                            if !(haskey(load_cache,dep.name)) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 792:
                                load_cache[dep.name] = (libs[dep])[2] # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 793:
                                opts = ((libs[dep])[1])[2] # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 794:
                                haskey(opts,:preload) && push!(pre_hooks,opts[:preload]) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 795:
                                haskey(opts,:onload) && push!(load_hooks,opts[:onload])
                            end
                        end
                    end
                else  # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 800:
                    for (k,v) = libs # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 801:
                        if !(haskey(load_cache,d.name)) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 802:
                            load_cache[d.name] = v # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 803:
                            opts = k[2] # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 804:
                            haskey(opts,:preload) && push!(pre_hooks,opts[:preload]) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 805:
                            haskey(opts,:onload) && push!(load_hooks,opts[:onload])
                        end
                    end
                end
            end # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 812:
            depsfile = open(joinpath((splitdir(Base.source_path()))[1],"deps.jl"),"w") # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 813:
            println(depsfile,"# This is an auto-generated file; do not edit\n") # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 817:
            println(depsfile,"# Pre-hooks") # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 818:
            println(depsfile,join(pre_hooks,"\n")) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 819:
            println(depsfile,"# Macro to load a library\nmacro checked_lib(libname, path)\n    ((VERSION >= v\"0.4.0-dev+3844\" ? Base.Libdl.dlopen_e : Base.dlopen_e)(path) == C_NULL) && error(\"Unable to load \\n\\n\$libname (\$path)\\n\\nPlease re-run Pkg.build(package), and restart Julia.\")\n    quote const \$(esc(libname)) = \$path end\nend\n") # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 827:
            println(depsfile,"# Load dependencies") # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 828:
            for libkey = keys(Dict(:libgsl=>:libgsl)) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 829:
                (cached = get(load_cache,string(libkey),nothing)) === nothing && continue # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 830:
                println(depsfile,"@checked_lib ",(Dict(:libgsl=>:libgsl))[libkey]," \"",escape_string(cached),"\"")
            end # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 832:
            println(depsfile) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 833:
            println(depsfile,"# Load-hooks") # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 834:
            println(depsfile,join(load_hooks,"\n")) # /home/travis/.julia/v0.4/BinDeps/src/dependencies.jl, line 835:
            close(depsfile)
        end
        
