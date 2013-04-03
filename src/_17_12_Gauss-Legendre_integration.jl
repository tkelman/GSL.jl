#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
####################################
# 17.12 Gauss-Legendre integration #
####################################
export gsl_integration_glfixed_table_alloc, gsl_integration_glfixed,
       gsl_integration_glfixed_point, gsl_integration_glfixed_table_free


# This function determines the Gauss-Legendre abscissae and weights necessary
# for an n-point fixed order integration scheme.  If possible, high precision
# precomputed coefficients are used.  If precomputed weights are not available,
# lower precision coefficients are computed on the fly.
# 
#   Returns: Ptr{Void}
#XXX Unknown output type Ptr{gsl_integration_glfixed_table}
#XXX Coerced type for output Ptr{Void}
function gsl_integration_glfixed_table_alloc{gsl_int<:Integer}(n::gsl_int)
    ccall( (:gsl_integration_glfixed_table_alloc, :libgsl), Ptr{Void},
        (Csize_t, ), n )
end


# This function applies the Gauss-Legendre integration rule contained in table
# t and returns the result.
# 
#   Returns: Cdouble
#XXX Unknown input type t::Ptr{gsl_integration_glfixed_table}
#XXX Coerced type for t::Ptr{Void}
function gsl_integration_glfixed(f::Ptr{gsl_function}, a::Cdouble, b::Cdouble, t::Ptr{Void})
    ccall( (:gsl_integration_glfixed, :libgsl), Cdouble,
        (Ptr{gsl_function}, Cdouble, Cdouble, Ptr{Void}), f, a, b, t )
end


# For i in [0, ..., t->n - 1], this function obtains the i-th Gauss-Legendre
# point xi and weight wi on the interval [a,b].  The points and weights are
# ordered by increasing point value.  A function f may be integrated on [a,b]
# by summing wi * f(xi) over i.
# 
#   Returns: Cint
#XXX Unknown input type t::Ptr{gsl_integration_glfixed_table}
#XXX Coerced type for t::Ptr{Void}
function gsl_integration_glfixed_point{gsl_int<:Integer}(a::Cdouble, b::Cdouble, i::gsl_int, t::Ptr{Void})
    xi = convert(Ptr{Cdouble}, Array(Cdouble, 1))
    wi = convert(Ptr{Cdouble}, Array(Cdouble, 1))
    gsl_errno = ccall( (:gsl_integration_glfixed_point, :libgsl), Cint,
        (Cdouble, Cdouble, Csize_t, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Void}), a,
        b, i, xi, wi, t )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
    return unsafe_ref(xi) ,unsafe_ref(wi)
end


# This function frees the memory associated with the table t.
# 
#   Returns: Void
#XXX Unknown input type t::Ptr{gsl_integration_glfixed_table}
#XXX Coerced type for t::Ptr{Void}
function gsl_integration_glfixed_table_free(t::Ptr{Void})
    ccall( (:gsl_integration_glfixed_table_free, :libgsl), Void,
        (Ptr{Void}, ), t )
end