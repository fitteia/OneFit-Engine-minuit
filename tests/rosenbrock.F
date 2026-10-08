* Smoke test for libminuit.a: MIGRAD on the Rosenbrock function from
* (-1.2, 1), whose minimum is F = 0 at (1, 1). Exits non-zero unless
* MIGRAD converges there (to its default EDM < 1E-4: within 0.01 of
* (1, 1), F < 1E-4, full accurate covariance matrix).
      PROGRAM ROSEN
      IMPLICIT NONE
      EXTERNAL FCN
      DOUBLE PRECISION ARGLIS(1), VAL, ERR, BND1, BND2, X(2)
      DOUBLE PRECISION FMIN, FEDM, ERRDEF
      INTEGER IERFLG, I, IVARBL, NPARI, NPARX, ISTAT
      CHARACTER*10 CHNAM
      CALL MNINIT(5, 6, 7)
      CALL MNPARM(1, 'x', -1.2D0, 0.1D0, 0D0, 0D0, IERFLG)
      IF (IERFLG .NE. 0) STOP 2
      CALL MNPARM(2, 'y', 1.0D0, 0.1D0, 0D0, 0D0, IERFLG)
      IF (IERFLG .NE. 0) STOP 2
      CALL MNEXCM(FCN, 'MIGRAD', ARGLIS, 0, IERFLG, 0)
      IF (IERFLG .NE. 0) STOP 3
      DO 10 I = 1, 2
         CALL MNPOUT(I, CHNAM, VAL, ERR, BND1, BND2, IVARBL)
         X(I) = VAL
   10 CONTINUE
      CALL MNSTAT(FMIN, FEDM, ERRDEF, NPARI, NPARX, ISTAT)
      WRITE (*, '(A,2F12.8,A,E12.4,A,I2)') ' minimum at', X(1), X(2),
     +      '  F =', FMIN, '  status', ISTAT
      IF (ABS(X(1) - 1D0) .GT. 1D-2 .OR. ABS(X(2) - 1D0) .GT. 1D-2
     +    .OR. FMIN .GT. 1D-4 .OR. ISTAT .NE. 3) THEN
         WRITE (*, *) 'FAIL: MIGRAD did not reach (1, 1)'
         STOP 1
      ENDIF
      WRITE (*, *) 'PASS: MIGRAD found the Rosenbrock minimum'
      END

      SUBROUTINE FCN(NPAR, GRAD, FVAL, XVAL, IFLAG, FUTIL)
      IMPLICIT NONE
      INTEGER NPAR, IFLAG
      DOUBLE PRECISION GRAD(*), FVAL, XVAL(*)
      EXTERNAL FUTIL
      FVAL = 100D0*(XVAL(2) - XVAL(1)**2)**2 + (1D0 - XVAL(1))**2
      END
