       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 I       PIC S9(9) VALUE 1.
       01 J       PIC S9(9) VALUE 2.
       01 K       PIC S9(9) VALUE 3.
       01 RESULT  PIC S9(9).

       PROCEDURE DIVISION.

           CALL "FUNC" USING I J K RESULT

           DISPLAY "Result: " RESULT

           STOP RUN.
