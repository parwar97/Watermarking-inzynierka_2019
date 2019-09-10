/* Finite Radon Transform
 *
 * Author: Minh N. Do
 *
 * Version history:
 *	November 1999:	First running version
 *	June 2000:	Modified variable name to conform with the paper
 *			Changed the way the mean value is processed
 *	September 2000:	Added best slopes ordering for FRAT coefficients
 *
 * To compile:
 *	mex -O -v fratc.c
 */

#include <math.h>
#include "mex.h"

/*
 * Check if P is a prime number.
 *   Return 1 when p is a prime number and return 0 when it is not.
 *      int isprime(int p);
 */
#include "isprime.c"


/*
  function [r, m] = fratc(f, s)
  % FRATC	Finite Radon Transform
  %
  %	[r, m] = fratc(f, s)
  %
  % Input:
  %	f:	a P by P matrix.  P is a prime.
  %	s:	a 2 by P matrix the contains the best set of directions
  %
  % Output:
  %	r:	a P by (P+1) matrix.  One projection per each column.
  %	m:	(optional), normalized mean of the input matrix.
  %		In this case, the mean is subtracted from each column of r.
*/

void
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *f, *pf;		/* image matrix and pointer */
    double *s;			/* pointer to input s */
    double *r, *pr;		/* result matrix and pointer */
    double norm;		/* norm normalization */
    double m;			/* mean value */

    int i, j, a, b, d, n, t, p;

    /* Input */
    if (nrhs != 2)
	mexErrMsgTxt("There must be two inputs.");

    f = mxGetPr(prhs[0]);
    p = mxGetM(prhs[0]);

    if (mxGetN(prhs[0]) != p || !isprime(p))
	mexErrMsgTxt("First input must be a square matrix of prime size.");

    s = mxGetPr(prhs[1]);

    if (mxGetM(prhs[1]) != 2 || mxGetN(prhs[1]) != (p+1))
	mexErrMsgTxt("Second input has invalid size.");

    /* Normalized factor */
    norm = 1.0 / sqrt(p);  

    /* Create and initialize output */
    plhs[0] = mxCreateDoubleMatrix(p, p + 1, mxREAL);
    r = mxGetPr(plhs[0]);

    /* Algorithm */
    pr = r;
    for (d = 0; d <= p; d++)
    {
	/* Retrieved the normal vector (a, b) */
	a = (int) s[2*d];
	b = (int) s[2*d+1];

	/* Convert a and b to F_p elements if needed */
	if (a < 0)
	    a += p;

	if (b < 0)
	    b += p;

	pf = f;
	n = 0;	
	for (j = 0; j < p; j++)
	{
	    if (n >= p)
		n -= p;
	    	    
	    t = n;	/* t = b*j (mod p) */

	    for (i = 0; i < p; i++)
	    {
		if (t >= p)
		    t -= p;

		/* The critical line! */		
		pr[t] += pf[i];

		t += a;	/* t = a*i + b*j (mod p) */
	    }
	    
	    n += b;	/* n = b*j (mod p) */
	    pf += p;	/* Advance pf to the next column of f */
	}

	/* Normalize l2-norm */
	for (t = 0; t < p; t++)
	    pr[t] *= norm;

	pr += p;	/* Advance pr to the next column of r */
    }

    /* If 2 output are required then subtract the mean from r
       and save the normalized mean in the second output */
    if (nlhs == 2)
    {	
	/* Compute the mean of each column of r (all equal) */
	m = 0.0;
	for (t = 0; t < p; t++)
	    m += r[t];

	m /= p;

	/* Subtract the mean out from r */
	n = p * (p + 1);
	for (t = 0; t < n; t++)
	    r[t] -= m;

	/* Output the normalized mean of the input matrix */
	plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*mxGetPr(plhs[1]) = m / norm;	
    }
}
