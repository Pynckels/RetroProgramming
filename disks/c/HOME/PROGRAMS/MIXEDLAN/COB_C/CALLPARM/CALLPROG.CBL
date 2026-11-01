      *---------------------------------------------------------------
      * CALLPROG.CBL - Microsoft COBOL 5 (DOS)
      * Calls C function calllib_func with three integers, each passed
      * in a different way. The C function adds 100 to each of them.
      *   WS-REF : BY REFERENCE -> C changes it, COBOL sees the change
      *   WS-CON : BY CONTENT   -> C changes a copy, COBOL unchanged
      *   WS-VAL : BY VALUE     -> C changes its local, COBOL unchanged
      * C int under Microsoft C for DOS is 16 bits -> PIC S9(4) COMP-5
      *---------------------------------------------------------------

       IDENTIFICATION DIVISION.

       PROGRAM-ID. CALLPROG.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  WS-REF               PIC S9(4) COMP-5 VALUE 10.
       01  WS-CON               PIC S9(4) COMP-5 VALUE 20.
       01  WS-VAL               PIC S9(4) COMP-5 VALUE 30.
       01  WS-DISPLAY           PIC -(5)9.

       PROCEDURE DIVISION.

       MAIN-PARA.

           DISPLAY "Before call:"
           PERFORM SHOW-VALUES

           CALL "_calllib_func"
                USING BY REFERENCE WS-REF
                      BY CONTENT   WS-CON
                      BY VALUE     WS-VAL
           END-CALL

           DISPLAY "After call (C added 100 to each):"
           PERFORM SHOW-VALUES

           STOP RUN.

       SHOW-VALUES.

           MOVE WS-REF TO WS-DISPLAY
           DISPLAY "  BY REFERENCE : " WS-DISPLAY
           MOVE WS-CON TO WS-DISPLAY
           DISPLAY "  BY CONTENT   : " WS-DISPLAY
           MOVE WS-VAL TO WS-DISPLAY
           DISPLAY "  BY VALUE     : " WS-DISPLAY.
