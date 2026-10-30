      *---------------------------------------------------------------
      * CALLCOB.CBL - Microsoft COBOL 5 (DOS)
      * Calls C function calllib_func with three integers:
      *   WS-IN-REF  : passed BY REFERENCE (C receives a far pointer)
      *   WS-IN-VAL  : passed BY VALUE     (C receives a copy)
      *   WS-OUT-REF : passed BY REFERENCE and filled in by C
      *                (the value coming back from C to COBOL)
      * C int under Microsoft C for DOS is 16 bits -> PIC S9(4) COMP-5
      *---------------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALLCOB.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-IN-REF            PIC S9(4) COMP-5 VALUE 10.
       01  WS-IN-VAL            PIC S9(4) COMP-5 VALUE 20.
       01  WS-OUT-REF           PIC S9(4) COMP-5 VALUE 0.
       01  WS-DISPLAY           PIC -(5)9.

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE WS-IN-REF TO WS-DISPLAY
           DISPLAY "Before call - ref in : " WS-DISPLAY
           MOVE WS-IN-VAL TO WS-DISPLAY
           DISPLAY "Before call - val in : " WS-DISPLAY

           CALL "_calllib_func"
                USING BY REFERENCE WS-IN-REF
                      BY VALUE     WS-IN-VAL
                      BY REFERENCE WS-OUT-REF
           END-CALL

           MOVE WS-IN-REF TO WS-DISPLAY
           DISPLAY "After call  - ref in : " WS-DISPLAY
           MOVE WS-IN-VAL TO WS-DISPLAY
           DISPLAY "After call  - val in : " WS-DISPLAY
           MOVE WS-OUT-REF TO WS-DISPLAY
           DISPLAY "After call  - out    : " WS-DISPLAY

           STOP RUN.
