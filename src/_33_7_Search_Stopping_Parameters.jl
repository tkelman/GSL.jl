#!/usr/bin/env julia
#GSL Julia wrapper
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
###################################
# 33.7 Search Stopping Parameters #
###################################
export gsl_root_test_interval, gsl_root_test_delta, gsl_root_test_residual










# This function tests for the convergence of the interval [x_lower, x_upper]
# with absolute error epsabs and relative error epsrel.  The test returns
# GSL_SUCCESS if the following condition is achieved,                 |a - b| <
# epsabs + epsrel min(|a|,|b|)  when the interval x = [a,b] does not include
# the origin.  If the interval includes the origin then \min(|a|,|b|) is
# replaced by zero (which is the minimum value of |x| over the interval).  This
# ensures that the relative error is accurately estimated for roots close to
# the origin.          This condition on the interval also implies that any
# estimate of the root r in the interval satisfies the same condition with
# respect to the true root r^*,                 |r - r^*| < epsabs + epsrel r^*
# assuming that the true root r^* is contained within the interval.
# 
#   Returns: Cint
function gsl_root_test_interval(x_lower::Cdouble, x_upper::Cdouble, epsabs::Cdouble, epsrel::Cdouble)
    gsl_errno = ccall( (:gsl_root_test_interval, :libgsl), Cint, (Cdouble,
        Cdouble, Cdouble, Cdouble), x_lower, x_upper, epsabs, epsrel )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
end


# This function tests for the convergence of the sequence ..., x0, x1 with
# absolute error epsabs and relative error epsrel.  The test returns
# GSL_SUCCESS if the following condition is achieved,                 |x_1 -
# x_0| < epsabs + epsrel |x_1|  and returns GSL_CONTINUE otherwise.
# 
#   Returns: Cint
function gsl_root_test_delta(x1::Cdouble, x0::Cdouble, epsabs::Cdouble, epsrel::Cdouble)
    gsl_errno = ccall( (:gsl_root_test_delta, :libgsl), Cint, (Cdouble,
        Cdouble, Cdouble, Cdouble), x1, x0, epsabs, epsrel )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
end


# This function tests the residual value f against the absolute error bound
# epsabs.  The test returns GSL_SUCCESS if the following condition is achieved,
# |f| < epsabs  and returns GSL_CONTINUE otherwise.  This criterion is suitable
# for situations where the precise location of the root, x, is unimportant
# provided a value can be found where the residual, |f(x)|, is small enough.
# 
#   Returns: Cint
function gsl_root_test_residual(f::Cdouble, epsabs::Cdouble)
    gsl_errno = ccall( (:gsl_root_test_residual, :libgsl), Cint, (Cdouble,
        Cdouble), f, epsabs )
    if gsl_errno!= 0 throw(GSL_ERROR(gsl_errno)) end
end