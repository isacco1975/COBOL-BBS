       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUB1 IS RESIDENT PROGRAM.
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
           PERFORM HANDLE-CLIENT-SESSION
           GOBACK
           .
      /*---------------------------------------------------------------*
       HANDLE-CLIENT-SESSION.
           SET OP-CRSR-CLRHOME TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-CRSR-RVSON TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-CRSR-WHITE TO TRUE
           CALL "WSERV" USING W-PARMS

           SET OP-SEND TO TRUE
           MOVE ' THIS IS PAGE SUB 1 ' TO W-DATA
           CALL "WSERV" USING W-PARMS
           .