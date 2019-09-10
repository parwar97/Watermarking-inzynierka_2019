/* Inverse Finite Radon Transform
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
 *	mex -O -v ifratc.c
 */

#include <math.h>
#include "mex.h"

/*
 * Check if P is a prime number.
 *   Return 1 when p is a prime number and return 0 when it is not.
 *      int isprime(int p);
 */
#include "isprime.c"


/* function f = ifratc(r, s, m)
   % IFRATC  Inverse Finite Radon Transform.
   %	   f = ifratc(r, s, [m])
   %
   % Input:
   %	r:	Radon coefficients in P by (P+1) matrix.
   %		One projection per each column.  P is a prime.
   %	s:	a 2 by P matrix the contains the best set of directions
   %	m:	(optional), normalized mean of the recontructed matrix.
   %		In this case, r is supposed to has zero-mean in each column.
   %
   % Output:
   %
   % 	f:	reconstructed matrix (of size P by P).
   %
   % See also:	FRATC
*/

void
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *f, *pf;		/* image matrix and pointer */
    double *s;			/* pointer to input s */
    double *r, *pr;		/* result matrix and pointer */
    double m;			/* corrected mean */
    double norm;		/* norm normalization */

    int i, j, a, b, d, n, t, p;

    /* Input */
    if (nrhs < 2)
	mexErrMsgTxt("There must be at least two inputs.");

    r = mxGetPr(prhs[0]);    
    p = mxGetM(prhs[0]);

    if (mxGetN(prhs[0]) != (p + 1) || !isprime(p))
	mexErrMsgTxt("First input must be a P by (P+1) matrix, P is prime.");

    s = mxGetPr(prhs[1]);

    if (mxGetM(prhs[1]) != 2 || mxGetN(prhs[1]) != (p+1))
	mexErrMsgTxt("Second input has invalid size.");

    /* Normalized factor */
    norm = 1.0 / sqrt(p);

    /* Compute the corrected mean value.
       Two ways, depend on the number of input */
    if (nrhs == 3)
    {
	/* Mean is given, r is supported to have zero mean */
	m = (*mxGetPr(prhs[2])) / p;
    }
    else
    {	
	/* Corrected mean value is computed from the whole matrix r
	   (rather than from just one single column) so that it is 
	   more robust again possible noise */
	m = 0.0;
	n = p * (p + 1);

	for (t = 0; t < n; t++)
	    m += r[t];

	m = -m / (p + 1) * norm;
    }

    /* Create and initialize output */
    plhs[0] = mxCreateDoubleMatrix(p, p, mxREAL);
    f = mxGetPr(plhs[0]);

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
		pf[i] += pr[t];

		t += a;	/* t = a*i + b*j (mod p) */
	    }
	    
	    n += b;	/* n = b*j (mod p) */
	    pf += p;	/* Advance pf to the next column of f */
	}

	pr += p;	/* Advance pr to the next column of r */
    }
    
    /* Normalize l2-norm and correct the mean value */
    pf = f;
    for (j = 0; j < p; j++)
    {
	for (i = 0; i < p; i++)	
	    pf[i] = pf[i] * norm + m;
	
	pf += p;	/* Advance pf to the next column of f */
    }
}
