       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN IS INITIAL PROGRAM.
       AUTHOR. ISAAC GARCIA PEVERI.
      /
      * A BBS FOR EVERY TERMINAL
      * WRITTEN ENTYRELY IN COBOL
      * C. 2026 IGP TECH BLOG
      /
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      /
       COPY "WPARMS.CPY".
      /
       01 WS-IGP-LOGO-TABLE.
      *> --- RIGA 01 ---
          05 FILLER PIC X(19)
             VALUE X'20972097209720972097209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720972097209720972097209720972097'.
      *> --- RIGA 02 ---
          05 FILLER PIC X(19)
             VALUE X'20972097209720972097209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720972097209720972097209720972097'.
      *> --- RIGA 03 ---
          05 FILLER PIC X(19)
             VALUE X'20972097209720972097209720962096209720'.
          05 FILLER PIC X(19)
             VALUE X'97209620962097209720962096209720972097'.
      *> --- RIGA 04 ---
          05 FILLER PIC X(19)
             VALUE X'20962096209720972096209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'9F209F20972097209A209A209720972097209E'.
      *> --- RIGA 05 ---
          05 FILLER PIC X(19)
             VALUE X'209E2097209720972097209720972096209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720962097209720962097209620972096'.
      *> --- RIGA 06 ---
          05 FILLER PIC X(19)
             VALUE X'20972096209720972096209720962097209720'.
          05 FILLER PIC X(19)
             VALUE X'972097209F2097209F2097209A2097209A2097'.
      *> --- RIGA 07 ---
          05 FILLER PIC X(19)
             VALUE X'209E2097209720972097209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'96209720972097209620972097209620972096'.
      *> --- RIGA 08 ---
          05 FILLER PIC X(19)
             VALUE X'20962097209720962097209720962097209620'.
          05 FILLER PIC X(19)
             VALUE X'97209720972097209F209F20972097209A209A'.
      *> --- RIGA 09 ---
          05 FILLER PIC X(19)
             VALUE X'209720972097209E2097209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720962097209720972096209720972096'.
      *> --- RIGA 10 ---
          05 FILLER PIC X(19)
             VALUE X'20972096209720962097209620972097209620'.
          05 FILLER PIC X(19)
             VALUE X'9720962097209720972097209F2097209F2097'.
      *> --- RIGA 11 ---
          05 FILLER PIC X(19)
             VALUE X'209A2097209A209720972097209E2097209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720972097209720962096209720972096'.
      *> --- RIGA 12 ---
          05 FILLER PIC X(19)
             VALUE X'20962097209720962096209720972097209620'.
          05 FILLER PIC X(19)
             VALUE X'962097209720962096209620972097209F209F'.
      *> --- RIGA 13 ---
          05 FILLER PIC X(19)
             VALUE X'20972097209A209A20972097209E209E209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720972097209720972097209720972097'.
      *> --- RIGA 14 ---
          05 FILLER PIC X(19)
             VALUE X'20972097209720972097209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'97209720972097209720972097209720972097'.
      *> --- RIGA 15 ---
          05 FILLER PIC X(19)
             VALUE X'20972097209720972097209720972097209720'.
          05 FILLER PIC X(19)
             VALUE X'972097209720972097'.

       01 WS-IGP-LOGO REDEFINES WS-IGP-LOGO-TABLE.
          05 WS-LOGO-ROW OCCURS 15 TIMES.
             10 WS-ROW-PART1 PIC X(19).
             10 WS-ROW-PART2 PIC X(19).
             
       77 IDX PIC S9(4) COMP VALUE 0.
      /
       PROCEDURE DIVISION.
      /*---------------------------------------------------------------*
       MAIN-LOGIC.
           DISPLAY 'DEBUG> MAIN-LOGIC - Avvio Server BBS...'

           SET OP-BUILD-LISTENER TO TRUE
           CALL "WSERV" USING W-PARMS

           PERFORM UNTIL 1 = 2
              DISPLAY 'DEBUG> In attesa di un nuovo client...'
              
              SET OP-BUILD-SOCKET TO TRUE
              CALL "WSERV" USING W-PARMS

              PERFORM HANDLE-CLIENT-SESSION

              SET OP-CLOSE-SOCKET TO TRUE
              CALL "WSERV" USING W-PARMS
           END-PERFORM
           .

      *---------------------------------------------------------------*
       HANDLE-CLIENT-SESSION.
           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-CLRHOME TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-RVSON TO TRUE
           CALL "WSERV" USING W-PARMS

           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 15
              SET OP-SEND TO TRUE
              CALL "C$SLEEP" USING 0.2
              MOVE WS-LOGO-ROW(IDX) TO W-DATA
              CALL "WSERV" USING W-PARMS
           END-PERFORM

           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-RVSOFF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-WHITE TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-SEND TO TRUE
           MOVE '     WELCOME TO igp test bbs IN cobol' TO W-DATA
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-YELLOW TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-SEND TO TRUE
           MOVE '     WITH THIS COBOL FRAMEWORK' TO W-DATA
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-SEND TO TRUE
           MOVE '     YOU CAN BUILD YOUR OWN bbs!' TO W-DATA
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-LIGHTBLUE TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-SEND TO TRUE
           MOVE '            --- question --- ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-SEND TO TRUE
           MOVE '     PLEASE TELL US YOUR NAME: ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-CRSR-LIGHTGREEN TO TRUE
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-SEND TO TRUE
           MOVE ' >  ' TO W-DATA
           CALL "WSERV" USING W-PARMS

           CALL "C$SLEEP" USING 0.2
           SET OP-WAIT-USER TO TRUE
           CALL "WSERV" USING W-PARMS

           IF W-RESPONSE-YES
              CALL "C$SLEEP" USING 0.2
              SET OP-CRLF TO TRUE
              CALL "WSERV" USING W-PARMS

              CALL "C$SLEEP" USING 0.2
              SET OP-CRLF TO TRUE
              CALL "WSERV" USING W-PARMS

              CALL "C$SLEEP" USING 0.2
              SET OP-CRSR-YELLOW TO TRUE
              CALL "WSERV" USING W-PARMS

              MOVE SPACES TO W-DATA
              
              STRING 'HELLO ' DELIMITED BY SIZE
                     W-RETURNED-ANSWER DELIMITED BY SPACES
                     ' WELCOME TO COBOL BBS' DELIMITED BY SIZE
                INTO W-DATA
              
      *        CALL "C$SLEEP" USING 0.2
      *        SET OP-SEND TO TRUE
      *        CALL "WSERV" USING W-PARMS\
               CALL "MMENU" USING W-PARMS
           END-IF

           CALL "C$SLEEP" USING 0.2
           SET OP-FLUSH-SOCKET TO TRUE
           CALL "WSERV" USING W-PARMS
           .