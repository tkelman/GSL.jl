#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
###########################################
# 39.5 Evaluation of B-spline derivatives #
###########################################
export gsl_bspline_deriv_eval, gsl_bspline_deriv_eval_nonzero


# This function evaluates all B-spline basis function derivatives of orders 0
# through nderiv (inclusive) at the position x and stores them in the matrix
# dB.  The (i,j)-th element of dB is d^jB_i(x)/dx^j.  The matrix dB must be of
# size n = nbreak + k - 2 by nderiv + 1.  The value n may also be obtained by
# calling gsl_bspline_ncoeffs.  Note that function evaluations are included as
# the zeroth order derivatives in dB.  Computing all the basis function
# derivatives at once is more efficient than computing them individually, due
# to the nature of the defining recurrence relation.
# 
#   Returns: Cint
#XXX Unknown input type w::Ptr{gsl_bspline_workspace}
#XXX Coerced type for w::Ptr{Void}
#XXX Unknown input type dw::Ptr{gsl_bspline_deriv_workspace}
#XXX Coerced type for dw::Ptr{Void}
function gsl_bspline_deriv_eval{gsl_int<:Integer}(x::Cdouble, nderiv::gsl_int, w::Ptr{Void}, dw::Ptr{Void})
    dB = convert(Ptr{gsl_matrix}, Array(gsl_matrix, 1))
    gsl_errno = ccall( (:gsl_bspline_deriv_eval, :libgsl), Cint, (Cdouble,
        Csize_t, Ptr{gsl_matrix}, Ptr{Void}, Ptr{Void}), x, nderiv, dB, w, dw )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
    return unsafe_ref(dB)
end


# This function evaluates all potentially nonzero B-spline basis function
# derivatives of orders 0 through nderiv (inclusive) at the position x and
# stores them in the matrix dB.  The (i,j)-th element of dB is  d^j/dx^j
# B_(istart+i)(x).  The last row of dB contains  d^j/dx^j B_(iend)(x).  The
# matrix dB must be of size k by at least nderiv + 1.  Note that function
# evaluations are included as the zeroth order derivatives in dB.  By returning
# only the nonzero basis functions, this function allows quantities involving
# linear combinations of the B_i(x) and their derivatives to be computed
# without unnecessary terms.
# 
#   Returns: Cint
#XXX Unknown input type w::Ptr{gsl_bspline_workspace}
#XXX Coerced type for w::Ptr{Void}
#XXX Unknown input type dw::Ptr{gsl_bspline_deriv_workspace}
#XXX Coerced type for dw::Ptr{Void}
function gsl_bspline_deriv_eval_nonzero{gsl_int<:Integer}(x::Cdouble, nderiv::gsl_int, w::Ptr{Void}, dw::Ptr{Void})
    dB = convert(Ptr{gsl_matrix}, Array(gsl_matrix, 1))
    istart = convert(Ptr{Csize_t}, Array(Csize_t, 1))
    iend = convert(Ptr{Csize_t}, Array(Csize_t, 1))
    gsl_errno = ccall( (:gsl_bspline_deriv_eval_nonzero, :libgsl), Cint,
        (Cdouble, Csize_t, Ptr{gsl_matrix}, Ptr{Csize_t}, Ptr{Csize_t},
        Ptr{Void}, Ptr{Void}), x, nderiv, dB, istart, iend, w, dw )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
    return unsafe_ref(dB) ,unsafe_ref(istart) ,unsafe_ref(iend)
end