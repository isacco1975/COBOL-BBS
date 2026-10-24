       IDENTIFICATION DIVISION.
       PROGRAM-ID. MMENU IS RESIDENT PROGRAM.
       AUTHOR. ISAAC GARCIA PEVERI.
      /
      * A BBS FOR EVERY TERMINAL
      * WRITTEN ENTYRELY IN COBOL
      * C. 2026 IGP TECH BLOG
      /
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      /
       77 IDX PIC S9(4) COMP VALUE 0.
      /
       LINKAGE SECTION.
          COPY "WPARMS.CPY".
      /
       PROCEDURE DIVISION USING WPARMS.
      /*---------------------------------------------------------------*
       MAIN-LOGIC.
           PERFORM UNTIL W-RETURNED-ANSWER(1:1) = 'X' 
              OR W-RETURNED-ANSWER(1:1) = 'x' 
                 PERFORM HANDLE-CLIENT-SESSION
           END-PERFORM
                 
           GOBACK
           .
      /*---------------------------------------------------------------*
       HANDLE-CLIENT-SESSION.
           SET OP-CRSR-CLRHOME TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-CRSR-RVSON TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-SEND TO TRUE
           STRING ' WELCOME '
                  W-RETURNED-ANSWER INTO W-DATA
           CALL "WSERV" USING W-PARMS

           SET OP-CRSR-RVSOFF TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-CRSR-PINK TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-SEND TO TRUE
           MOVE '     PLEASE SELECT AN OPTION: ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-CRSR-LIGHTBLUE TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-SEND TO TRUE
           MOVE ' 1. gioco della BIRRA ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-SEND TO TRUE
           MOVE ' 2. PAGE b ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-SEND TO TRUE
           MOVE ' > ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           SET OP-WAIT-USER TO TRUE
           CALL "WSERV" USING W-PARMS

           IF W-RESPONSE-YES
              SET OP-CRLF TO TRUE
              CALL "WSERV" USING W-PARMS

              SET OP-CRLF TO TRUE
              CALL "WSERV" USING W-PARMS

              SET OP-CRSR-YELLOW TO TRUE
              CALL "WSERV" USING W-PARMS

              IF W-RETURNED-ANSWER(1:1) = '1'
                 CALL "BIRRA" USING W-PARMS
              END-IF

              IF W-RETURNED-ANSWER(1:1) = '2'
                 CALL "SUB2" USING W-PARMS
              END-IF
           END-IF
           .