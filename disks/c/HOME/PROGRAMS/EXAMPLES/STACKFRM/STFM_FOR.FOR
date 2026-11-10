      PROGRAM STFM_FOR

      IMPLICIT NONE

      INTEGER I, J, K
      INTEGER RESULT
      INTEGER FUNC

      PARAMETER (I = 1)
      PARAMETER (J = 2)
      PARAMETER (K = 3)

      RESULT = FUNC(I, J, K)
!
! First character is an ASA cariage control character
!
      WRITE (*,'(A1,A,I2)') ' ', 'Result: ', RESULT

      END


      INTEGER FUNCTION FUNC(A, B, C)

      IMPLICIT NONE

      INTEGER A, B, C

      FUNC = A + B - C

      RETURN
      END
