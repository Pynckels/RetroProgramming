       IDENTIFICATION DIVISION.
       PROGRAM-ID. FUNC.

       DATA DIVISION.
       LINKAGE SECTION.

       01 A       PIC S9(9).
       01 B       PIC S9(9).
       01 C       PIC S9(9).
       01 RESULT  PIC S9(9).

       PROCEDURE DIVISION USING A B C RESULT.

           COMPUTE RESULT = A + B - C

           GOBACK.
