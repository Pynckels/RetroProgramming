      PROGRAM KEYDEMO


      CHARACTER*79 LINE

      INTEGER*2    IH, IM, IS, IHS
      INTEGER*2    KEY
      INTEGER*2    COL

      REAL         R

      INTEGER*2 KEYHIT
      EXTERNAL  KEYHIT


      WRITE (*,'(/,1X,A,/)') 'Press Q to quit'

      CALL GETTIM(IH, IM, IS, IHS)
      CALL SEED(IS * 100 + IHS)

      DELAY = 500
      KEY = 0

      DO WHILE (KEY .NE. ICHAR('Q') .AND. KEY .NE. ICHAR('q'))

        DO COL = 1, 79

          CALL RANDOM(R)

          IF (R .LT. 0.5) THEN
            LINE(COL:COL) = CHAR(47)
          ELSE
            LINE(COL:COL) = CHAR(92)
          END IF

        END DO

        WRITE (*,'(1X,A)') LINE

        CALL WAITMS(500)
        KEY = KEYHIT()
      END DO

      END
