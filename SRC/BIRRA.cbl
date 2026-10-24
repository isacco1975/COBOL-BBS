       IDENTIFICATION DIVISION.
       PROGRAM-ID. BIRRA IS RESIDENT PROGRAM.
       AUTHOR. ISAAC GARCIA PEVERI.
      /
      * GIOCO DELLA BIRRA (BEER GAME) CONVERTITO DA VB.NET
      * C. 2026 IGP TECH BLOG
      /
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      /
       COPY "WPARMS.CPY".
      /
      * STATI DEL GIOCO
       77 WS-STATE             PIC 9 VALUE 1.
          88 STATE-MENU        VALUE 1.
          88 STATE-REGOLE      VALUE 2.
          88 STATE-INGIOCO     VALUE 3.
          88 STATE-TURNO-G     VALUE 4.
          88 STATE-TURNO-C     VALUE 5.
          88 STATE-FINE        VALUE 6.

      * VARIABILI DI GIOCO
       77 D-BOCK               PIC S9(4) VALUE 0.
       77 WS-A-VAL             PIC S9(4) COMP VALUE 0.
       77 WS-HALF              PIC S9(4) COMP VALUE 0.
       77 WS-MAX-CONS          PIC S9(4) COMP VALUE 0.
       77 WS-BEVUTA            PIC S9(4) VALUE 0.
       77 WS-POT               PIC S9(4) COMP VALUE 0.
       77 WS-B-LOOP            PIC S9(4) COMP VALUE 0.
       77 WS-RAND-VAL          PIC S9(9) COMP VALUE 0.
       77 WS-MIN-R             PIC S9(4) COMP VALUE 0.
       77 WS-MAX-R             PIC S9(4) COMP VALUE 0.

      * CIFRE EDITATE PER LA STAMPA PULITA
       77 D-BOCK-ED            PIC ZZZ9.
       77 WS-BEVUTA-ED         PIC ZZZ9.

      * SUPPORTO INPUT / BUFFER
       77 IDX                  PIC S9(4) COMP VALUE 0.
       77 WS-IDX               PIC S9(4) COMP VALUE 1.
       77 WS-TEMP-STR          PIC X(40) VALUE SPACES.
       77 LANG-PAGE            PIC X     VALUE '1'.
       77 WS-TEMP-VAL          PIC S9(4) COMP VALUE 0.
       77 WS-MOD-RES           PIC S9(4) COMP VALUE 0.
      /
       PROCEDURE DIVISION.
      *---------------------------------------------------------------*
       MAIN-LOGIC.
           DISPLAY 'DEBUG> BIRRA - Avvio Gioco...'
           MOVE '1' TO LANG-PAGE
           MOVE 1   TO WS-STATE

           SET OP-CRSR-CLRHOME TO TRUE
           CALL "WSERV" USING W-PARMS

           PERFORM GESTISCI-MENU-DISPLAY

           PERFORM UNTIL 1 = 2
              SET OP-WAIT-USER TO TRUE
              CALL "WSERV" USING W-PARMS

              IF W-RESPONSE-YES
                 SET OP-CRLF TO TRUE
                 CALL "WSERV" USING W-PARMS

                 EVALUATE TRUE
                    WHEN STATE-MENU
                       PERFORM ROUTINE-MENU
                    WHEN STATE-REGOLE
                       MOVE 1 TO WS-STATE
                       PERFORM GESTISCI-MENU-DISPLAY
                    WHEN STATE-TURNO-G
                       PERFORM GESTISCI-TURNO-GIOCATORE
                    WHEN STATE-FINE
                       MOVE 1 TO WS-STATE
                       PERFORM GESTISCI-MENU-DISPLAY
                 END-EVALUATE
                 
                 MOVE SPACES TO W-RETURNED-ANSWER
              END-IF
           END-PERFORM
           .

      *---------------------------------------------------------------*
      * ROUTINE SUPPORTO: INVIA MESSAGGIO CON CRLF AUTOMATICO
      *---------------------------------------------------------------*
       SEND-MSG.
           SET OP-SEND TO TRUE
           CALL "WSERV" USING W-PARMS
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS
           .

      *---------------------------------------------------------------*
       GESTISCI-MENU-DISPLAY.
           SET OP-CRSR-WHITE TO TRUE
           CALL "WSERV" USING W-PARMS

           EVALUATE LANG-PAGE
              WHEN '1'
                 MOVE 'PREMI I PER INIZIARE' TO W-DATA
                 PERFORM SEND-MSG

                 MOVE 'PREMI R PER LE REGOLE' TO W-DATA
                 PERFORM SEND-MSG

                 MOVE 'PREMI F PER USCIRE' TO W-DATA
                 PERFORM SEND-MSG
                 SET OP-CRLF TO TRUE
                 CALL "WSERV" USING W-PARMS

              WHEN '2'
                 MOVE 'PRESS I TO START GAME' TO W-DATA
                 PERFORM SEND-MSG

                 MOVE 'PRESS R TO SEE RULES' TO W-DATA
                 PERFORM SEND-MSG

                 MOVE 'PRESS F TO EXIT' TO W-DATA
                 PERFORM SEND-MSG
                 SET OP-CRLF TO TRUE
                 CALL "WSERV" USING W-PARMS

              WHEN '3'
                 MOVE 'PRESIONE I PARA INICIAR EL JUEGO' TO W-DATA
                 PERFORM SEND-MSG

                 MOVE 'PRESIONE R PARA LEER LAS REGLAS' TO W-DATA
                 PERFORM SEND-MSG

                 MOVE 'PRESIONE F PARA TERMINAR' TO W-DATA
                 PERFORM SEND-MSG
                 SET OP-CRLF TO TRUE
                 CALL "WSERV" USING W-PARMS
           END-EVALUATE

           SET OP-SEND TO TRUE
           MOVE ' > ' TO W-DATA
           CALL "WSERV" USING W-PARMS
           .

      *---------------------------------------------------------------*
       ROUTINE-MENU.
           IF W-RETURNED-ANSWER(1:1) = 'I' OR 'i'
              MOVE 3 TO WS-STATE
              PERFORM INIZIA-PARTITA
           ELSE IF W-RETURNED-ANSWER(1:1) = 'R' OR 'r'
              MOVE 2 TO WS-STATE
              PERFORM MOSTRA-REGOLE
           ELSE IF W-RETURNED-ANSWER(1:1) = 'F' OR 'f'
              SET OP-CRSR-ORANGE TO TRUE
              CALL "WSERV" USING W-PARMS
              SET OP-CRSR-BLACK TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'LOGOUT DAL GIOCO. PREMI RETURN' TO W-DATA
              PERFORM SEND-MSG
              MOVE 6 TO WS-STATE
           ELSE
              SET OP-CRSR-PURPLE TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'COMANDO NON VALIDO. USA I, R O F.' TO W-DATA
              PERFORM SEND-MSG
              PERFORM GESTISCI-MENU-DISPLAY
           END-IF
           .

      *---------------------------------------------------------------*
       MOSTRA-REGOLE.
           SET OP-CRSR-WHITE TO TRUE
           CALL "WSERV" USING W-PARMS
           
           MOVE 'REGOLE DEL GIOCO:' TO W-DATA
           PERFORM SEND-MSG

           MOVE 'LO SCOPO E'' LASCIARE ALL''AVVERSARIO' TO W-DATA
           PERFORM SEND-MSG

           MOVE '1 SOLO MILLIMETRO DI BIRRA.' TO W-DATA
           PERFORM SEND-MSG

           MOVE 'AL TUO TURNO PUOI BERE UNA QUANTITA'' INTERA' TO W-DATA
           PERFORM SEND-MSG

           MOVE 'NON SUPERIORE ALLA META'' DI QUELLA RIMASTA.' TO W-DATA
           PERFORM SEND-MSG
           SET OP-CRLF TO TRUE
           CALL "WSERV" USING W-PARMS

           PERFORM GESTISCI-MENU-DISPLAY
           .

      *---------------------------------------------------------------*
       INIZIA-PARTITA.
           PERFORM UNTIL WS-RAND-VAL > 30
              MOVE FUNCTION CURRENT-DATE(15:2) TO WS-RAND-VAL
           END-PERFORM
   
           COMPUTE D-BOCK = FUNCTION MOD(WS-RAND-VAL, 99) + 1
           MOVE 4 TO WS-STATE

           SET OP-CRSR-YELLOW TO TRUE
           CALL "WSERV" USING W-PARMS

           MOVE 'INIZIA LA PARTITA!' TO W-DATA
           PERFORM SEND-MSG

           MOVE SPACES TO W-DATA
           MOVE D-BOCK TO D-BOCK-ED
           STRING 'NEL BOCCALE CI SONO ' D-BOCK-ED ' MM DI BIRRA.'
             DELIMITED BY SIZE INTO W-DATA
           PERFORM SEND-MSG

           SET OP-SEND TO TRUE
           MOVE 'QUANTA NE BEVI? > ' TO W-DATA
           CALL "WSERV" USING W-PARMS
           MOVE SPACES TO W-RETURNED-ANSWER
           .

      *---------------------------------------------------------------*
       GESTISCI-TURNO-GIOCATORE.
           SET OP-CRSR-WHITE TO TRUE
           CALL "WSERV" USING W-PARMS

           MOVE SPACES TO WS-TEMP-STR
           INSPECT W-RETURNED-ANSWER
                   REPLACING TRAILING SPACES BY LOW-VALUES
           STRING W-RETURNED-ANSWER
                  DELIMITED BY LOW-VALUES INTO WS-TEMP-STR

           IF FUNCTION UPPER-CASE(WS-TEMP-STR(1:4)) = 'FINE'
              SET OP-CRSR-LIGHTBLUE TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'PARTITA RESETTATA!' TO W-DATA
              PERFORM SEND-MSG
              MOVE 1 TO WS-STATE
              PERFORM GESTISCI-MENU-DISPLAY
              EXIT PARAGRAPH
           END-IF

           COMPUTE WS-A-VAL = FUNCTION NUMVAL(WS-TEMP-STR)
           IF WS-A-VAL < 1
              SET OP-CRSR-PURPLE TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'ASTEMIO! BEVINE UN PO''. QUANTA NE BEVI? ' TO W-DATA
              CALL "WSERV" USING W-PARMS
              EXIT PARAGRAPH
           END-IF

           COMPUTE WS-HALF = D-BOCK / 2
           IF WS-A-VAL > WS-HALF
              SET OP-CRSR-PURPLE TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'MA LE SAI LE REGOLE? QUANTA NE BEVI? ' TO W-DATA
              CALL "WSERV" USING W-PARMS
              EXIT PARAGRAPH
           END-IF

      * Bevuta valida
           COMPUTE D-BOCK = D-BOCK - WS-A-VAL
           MOVE SPACES TO W-RETURNED-ANSWER

           IF D-BOCK = 1
              SET OP-CRSR-LIGHTGREEN TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'HAI VINTO! RIMANE 1 SOLO MM DI BIRRA.' TO W-DATA
              PERFORM SEND-MSG
              MOVE 6 TO WS-STATE
              MOVE 'PREMI RETURN PER USCIRE' TO W-DATA
              CALL "WSERV" USING W-PARMS
              EXIT PARAGRAPH
           END-IF

           SET OP-CRSR-YELLOW TO TRUE
           CALL "WSERV" USING W-PARMS
           MOVE SPACES TO W-DATA
           MOVE D-BOCK TO D-BOCK-ED
           STRING 'NEL BOCCALE ORA CI SONO ' D-BOCK-ED ' MM.'
             DELIMITED BY SIZE INTO W-DATA
           PERFORM SEND-MSG

      * Turno Computer
           PERFORM ESEGUI-TURNO-COMPUTER
           .

      *---------------------------------------------------------------*
       ESEGUI-TURNO-COMPUTER.
           MOVE 0 TO WS-A-VAL

           IF D-BOCK > 63 AND WS-A-VAL = 0
              MOVE 63 TO WS-A-VAL
           END-IF
           IF D-BOCK > 31 AND WS-A-VAL = 0
              MOVE 31 TO WS-A-VAL
           END-IF
           IF D-BOCK > 15 AND WS-A-VAL = 0
              MOVE 15 TO WS-A-VAL
           END-IF
           IF D-BOCK > 7 AND WS-A-VAL = 0
              MOVE 7 TO WS-A-VAL
           END-IF
           IF D-BOCK > 3 AND WS-A-VAL = 0
              MOVE 3 TO WS-A-VAL
           END-IF
           IF D-BOCK > 1 AND WS-A-VAL = 0
              MOVE 1 TO WS-A-VAL
           END-IF

           COMPUTE WS-HALF = D-BOCK / 2
           IF WS-A-VAL < WS-HALF
              COMPUTE WS-MIN-R = WS-HALF + 1
              COMPUTE WS-MAX-R = D-BOCK - 1
              IF WS-MAX-R > WS-MIN-R
                 CALL "C$RANDOM" GIVING WS-RAND-VAL
                 COMPUTE WS-TEMP-VAL = (WS-MAX-R - WS-MIN-R) + 1
                 COMPUTE WS-MOD-RES  = 
                         FUNCTION MOD(WS-RAND-VAL, WS-TEMP-VAL)
                 COMPUTE WS-A-VAL    = WS-MIN-R + WS-MOD-RES
              ELSE
                 MOVE WS-HALF TO WS-A-VAL
              END-IF
           END-IF
           
           COMPUTE WS-BEVUTA = D-BOCK - WS-A-VAL
           COMPUTE WS-MAX-CONS = D-BOCK / 2
           IF WS-BEVUTA > WS-MAX-CONS
              MOVE WS-MAX-CONS TO WS-BEVUTA
           END-IF
           IF WS-BEVUTA < 1
              MOVE 1 TO WS-BEVUTA
           END-IF

           COMPUTE D-BOCK = D-BOCK - WS-BEVUTA

           SET OP-CRSR-LIGHTBLUE TO TRUE
           CALL "WSERV" USING W-PARMS
           MOVE SPACES TO W-DATA
           MOVE WS-BEVUTA TO WS-BEVUTA-ED
           STRING 'IO BEVO: ' WS-BEVUTA-ED ' MM.'
             DELIMITED BY SIZE INTO W-DATA
           PERFORM SEND-MSG

           IF D-BOCK = 1
              SET OP-CRSR-PURPLE TO TRUE
              CALL "WSERV" USING W-PARMS
              MOVE 'COME ERA CHIARO... HO VINTO IO!' TO W-DATA
              PERFORM SEND-MSG
              MOVE 6 TO WS-STATE
              MOVE 'PREMI RETURN PER USCIRE' TO W-DATA
              CALL "WSERV" USING W-PARMS
              EXIT PARAGRAPH
           END-IF

           SET OP-CRSR-YELLOW TO TRUE
           CALL "WSERV" USING W-PARMS
           MOVE SPACES TO W-DATA
           MOVE D-BOCK TO D-BOCK-ED
           STRING 'NEL BOCCALE ORA CI SONO ' D-BOCK-ED ' MM.'
             DELIMITED BY SIZE INTO W-DATA
           PERFORM SEND-MSG
           
           SET OP-SEND TO TRUE
           MOVE 'QUANTA NE BEVI? > ' TO W-DATA
           CALL "WSERV" USING W-PARMS
           MOVE 4 TO WS-STATE
           .
           