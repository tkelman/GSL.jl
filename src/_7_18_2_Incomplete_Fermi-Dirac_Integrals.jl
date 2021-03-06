#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
###########################################
# 7.18.2 Incomplete Fermi-Dirac Integrals #
###########################################
export sf_fermi_dirac_inc_0, sf_fermi_dirac_inc_0_e




# These routines compute the incomplete Fermi-Dirac integral with an index of
# zero,  F_0(x,b) = \ln(1 + e^{b-x}) - (b-x).
# 
#   Returns: Cdouble
function sf_fermi_dirac_inc_0(x::Real, b::Real)
    ccall( (:gsl_sf_fermi_dirac_inc_0, :libgsl), Cdouble, (Cdouble,
        Cdouble), x, b )
end
@vectorize_2arg Number sf_fermi_dirac_inc_0


# These routines compute the incomplete Fermi-Dirac integral with an index of
# zero,  F_0(x,b) = \ln(1 + e^{b-x}) - (b-x).
# 
#   Returns: Cint
function sf_fermi_dirac_inc_0_e(x::Real, b::Real)
    result = convert(Ptr{gsl_sf_result}, Array(gsl_sf_result, 1))
    errno = ccall( (:gsl_sf_fermi_dirac_inc_0_e, :libgsl), Cint, (Cdouble,
        Cdouble, Ptr{gsl_sf_result}), x, b, result )
    if errno!= 0 throw(GSL_ERROR(errno)) end
    return unsafe_load(result)
end
@vectorize_2arg Number sf_fermi_dirac_inc_0_e
