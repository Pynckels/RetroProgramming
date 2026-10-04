       IDENTIFICATION DIVISION.
       PROGRAM-ID. CRCDEMO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT INPUT-FILE
               ASSIGN TO "CRCDEMO.DAT"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  INPUT-FILE
           RECORD IS VARYING IN SIZE
           FROM 1 TO 4096 CHARACTERS
           DEPENDING ON FILE-LENGTH
           RECORDING MODE IS U.

       01  INPUT-RECORD                  PIC X(4096).

       WORKING-STORAGE SECTION.

       01  FILE-STATUS                   PIC XX.
       01  FILE-LENGTH                   PIC S9(4) COMP-5.
       01  CRC-VALUE                     PIC 9(10) COMP-5.
       01  RESULT                        PIC S9(4) COMP-5.
       01  RECORD-NUMBER                 PIC 9(4)  VALUE 0.
       01  END-OF-FILE                   PIC X VALUE "N".

       PROCEDURE DIVISION.

           OPEN INPUT INPUT-FILE

           IF FILE-STATUS NOT = "00"
               DISPLAY "Unable to open file. Status = "
                       FILE-STATUS
               STOP RUN
           END-IF

           PERFORM UNTIL END-OF-FILE = "Y"

               READ INPUT-FILE
                   AT END
                       MOVE "Y" TO END-OF-FILE
               END-READ

               IF END-OF-FILE NOT = "Y"

                   ADD 1 TO RECORD-NUMBER

                   IF FILE-LENGTH > 4096
                       MOVE 4096 TO FILE-LENGTH
                   END-IF

                   MOVE 0 TO CRC-VALUE
                   MOVE 0 TO RESULT

                   CALL "_crc32_buffer"
                       USING BY REFERENCE INPUT-RECORD
                             BY REFERENCE FILE-LENGTH
                             BY REFERENCE CRC-VALUE
                       RETURNING RESULT

                   IF RESULT NOT = 0
                       DISPLAY "CRC error on record "
                               RECORD-NUMBER
                       DISPLAY "C routine returned "
                               RESULT
                       DISPLAY "Expected "
                               FILE-LENGTH
                       CLOSE INPUT-FILE
                       STOP RUN
                   END-IF

                   DISPLAY "[" RECORD-NUMBER "] " CRC-VALUE

               END-IF

           END-PERFORM

           CLOSE INPUT-FILE

           STOP RUN.
