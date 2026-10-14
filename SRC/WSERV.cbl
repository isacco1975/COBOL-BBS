       IDENTIFICATION DIVISION.
       PROGRAM-ID. SOCKET-SERVER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       78  CSOCKET-CREATE-SERVER    VALUE 1.
       78  CSOCKET-ACCEPT           VALUE 2.
       78  CSOCKET-CLOSE            VALUE 4.
       78  CSOCKET-CREATE-CLIENT    VALUE 3.
       78  CSOCKET-WRITE            VALUE 5.
       78  CSOCKET-READ             VALUE 6.
       78  CSOCKET-FLUSH            VALUE 8.

       77  SERVER-PORT              PIC 9(5)    COMP-5 VALUE 64000.
       77  SERVER-SOCKET            PIC S9(9)   COMP-5 VALUE 0.
       77  CLIENT-SOCKET            PIC S9(9)   COMP-5 VALUE 0.
       77  RETURN-CODE-SOCKET       PIC S9(9)   COMP-5 VALUE 0.
       77  BUFFER-IN                PIC X(1024)        VALUE SPACES.
       77  BYTES-READ               PIC S9(9)   COMP-5 VALUE 0.
       77  BUFFER-OUT               PIC X(80)          VALUE SPACES.
       77  BUFFER-OUT2              PIC X(80)          VALUE SPACES.
       77  FINAL-BUFFER             PIC X(100)         VALUE SPACES.
       77  BYTES-SENT               PIC S9(9)   COMP-5 VALUE 0.
       77  MSG-LEN                  PIC S9(9)   COMP-5 VALUE 0.

       01 IDX       PIC 9(4) COMP.
       
      * Tabella ufficiale CP437 (00H - FFH)
       01 CP437-TABLE.
          05 PIC X VALUE X'00'.
          05 PIC X VALUE X'01'.
          05 PIC X VALUE X'02'.
          05 PIC X VALUE X'03'.
          05 PIC X VALUE X'04'.
          05 PIC X VALUE X'05'.
          05 PIC X VALUE X'06'.
          05 PIC X VALUE X'07'.
          05 PIC X VALUE X'08'.
          05 PIC X VALUE X'09'.
          05 PIC X VALUE X'0A'.
          05 PIC X VALUE X'0B'.
          05 PIC X VALUE X'0C'.
          05 PIC X VALUE X'0D'.
          05 PIC X VALUE X'0E'.
          05 PIC X VALUE X'0F'.
          05 PIC X VALUE X'10'.
          05 PIC X VALUE X'11'.
          05 PIC X VALUE X'12'.
          05 PIC X VALUE X'13'.
          05 PIC X VALUE X'14'.
          05 PIC X VALUE X'15'.
          05 PIC X VALUE X'16'.
          05 PIC X VALUE X'17'.
          05 PIC X VALUE X'18'.
          05 PIC X VALUE X'19'.
          05 PIC X VALUE X'1A'.
          05 PIC X VALUE X'1B'.
          05 PIC X VALUE X'1C'.
          05 PIC X VALUE X'1D'.
          05 PIC X VALUE X'1E'.
          05 PIC X VALUE X'1F'.
          05 PIC X VALUE X'20'.
          05 PIC X VALUE X'21'.
          05 PIC X VALUE X'22'.
          05 PIC X VALUE X'23'.
          05 PIC X VALUE X'24'.
          05 PIC X VALUE X'25'.
          05 PIC X VALUE X'26'.
          05 PIC X VALUE X'27'.
          05 PIC X VALUE X'28'.
          05 PIC X VALUE X'29'.
          05 PIC X VALUE X'2A'.
          05 PIC X VALUE X'2B'.
          05 PIC X VALUE X'2C'.
          05 PIC X VALUE X'2D'.
          05 PIC X VALUE X'2E'.
          05 PIC X VALUE X'2F'.
          05 PIC X VALUE X'30'.
          05 PIC X VALUE X'31'.
          05 PIC X VALUE X'32'.
          05 PIC X VALUE X'33'.
          05 PIC X VALUE X'34'.
          05 PIC X VALUE X'35'.
          05 PIC X VALUE X'36'.
          05 PIC X VALUE X'37'.
          05 PIC X VALUE X'38'.
          05 PIC X VALUE X'39'.
          05 PIC X VALUE X'3A'.
          05 PIC X VALUE X'3B'.
          05 PIC X VALUE X'3C'.
          05 PIC X VALUE X'3D'.
          05 PIC X VALUE X'3E'.
          05 PIC X VALUE X'3F'.
          05 PIC X VALUE X'40'.
          05 PIC X VALUE X'41'.
          05 PIC X VALUE X'42'.
          05 PIC X VALUE X'43'.
          05 PIC X VALUE X'44'.
          05 PIC X VALUE X'45'.
          05 PIC X VALUE X'46'.
          05 PIC X VALUE X'47'.
          05 PIC X VALUE X'48'.
          05 PIC X VALUE X'49'.
          05 PIC X VALUE X'4A'.
          05 PIC X VALUE X'4B'.
          05 PIC X VALUE X'4C'.
          05 PIC X VALUE X'4D'.
          05 PIC X VALUE X'4E'.
          05 PIC X VALUE X'4F'.
          05 PIC X VALUE X'50'.
          05 PIC X VALUE X'51'.
          05 PIC X VALUE X'52'.
          05 PIC X VALUE X'53'.
          05 PIC X VALUE X'54'.
          05 PIC X VALUE X'55'.
          05 PIC X VALUE X'56'.
          05 PIC X VALUE X'57'.
          05 PIC X VALUE X'58'.
          05 PIC X VALUE X'59'.
          05 PIC X VALUE X'5A'.
          05 PIC X VALUE X'5B'.
          05 PIC X VALUE X'5C'.
          05 PIC X VALUE X'5D'.
          05 PIC X VALUE X'5E'.
          05 PIC X VALUE X'5F'.
          05 PIC X VALUE X'60'.
          05 PIC X VALUE X'61'.
          05 PIC X VALUE X'62'.
          05 PIC X VALUE X'63'.
          05 PIC X VALUE X'64'.
          05 PIC X VALUE X'65'.
          05 PIC X VALUE X'66'.
          05 PIC X VALUE X'67'.
          05 PIC X VALUE X'68'.
          05 PIC X VALUE X'69'.
          05 PIC X VALUE X'6A'.
          05 PIC X VALUE X'6B'.
          05 PIC X VALUE X'6C'.
          05 PIC X VALUE X'6D'.
          05 PIC X VALUE X'6E'.
          05 PIC X VALUE X'6F'.
          05 PIC X VALUE X'70'.
          05 PIC X VALUE X'71'.
          05 PIC X VALUE X'72'.
          05 PIC X VALUE X'73'.
          05 PIC X VALUE X'74'.
          05 PIC X VALUE X'75'.
          05 PIC X VALUE X'76'.
          05 PIC X VALUE X'77'.
          05 PIC X VALUE X'78'.
          05 PIC X VALUE X'79'.
          05 PIC X VALUE X'7A'.
          05 PIC X VALUE X'7B'.
          05 PIC X VALUE X'7C'.
          05 PIC X VALUE X'7D'.
          05 PIC X VALUE X'7E'.
          05 PIC X VALUE X'7F'.
          05 PIC X VALUE X'80'.
          05 PIC X VALUE X'81'.
          05 PIC X VALUE X'82'.
          05 PIC X VALUE X'83'.
          05 PIC X VALUE X'84'.
          05 PIC X VALUE X'85'.
          05 PIC X VALUE X'86'.
          05 PIC X VALUE X'87'.
          05 PIC X VALUE X'88'.
          05 PIC X VALUE X'89'.
          05 PIC X VALUE X'8A'.
          05 PIC X VALUE X'8B'.
          05 PIC X VALUE X'8C'.
          05 PIC X VALUE X'8D'.
          05 PIC X VALUE X'8E'.
          05 PIC X VALUE X'8F'.
          05 PIC X VALUE X'90'.
          05 PIC X VALUE X'91'.
          05 PIC X VALUE X'92'.
          05 PIC X VALUE X'93'.
          05 PIC X VALUE X'94'.
          05 PIC X VALUE X'95'.
          05 PIC X VALUE X'96'.
          05 PIC X VALUE X'97'.
          05 PIC X VALUE X'98'.
          05 PIC X VALUE X'99'.
          05 PIC X VALUE X'9A'.
          05 PIC X VALUE X'9B'.
          05 PIC X VALUE X'9C'.
          05 PIC X VALUE X'9D'.
          05 PIC X VALUE X'9E'.
          05 PIC X VALUE X'9F'.
          05 PIC X VALUE X'A0'.
          05 PIC X VALUE X'A1'.
          05 PIC X VALUE X'A2'.
          05 PIC X VALUE X'A3'.
          05 PIC X VALUE X'A4'.
          05 PIC X VALUE X'A5'.
          05 PIC X VALUE X'A6'.
          05 PIC X VALUE X'A7'.
          05 PIC X VALUE X'A8'.
          05 PIC X VALUE X'A9'.
          05 PIC X VALUE X'AA'.
          05 PIC X VALUE X'AB'.
          05 PIC X VALUE X'AC'.
          05 PIC X VALUE X'AD'.
          05 PIC X VALUE X'AE'.
          05 PIC X VALUE X'AF'.
          05 PIC X VALUE X'B0'.
          05 PIC X VALUE X'B1'.
          05 PIC X VALUE X'B2'.
          05 PIC X VALUE X'B3'.
          05 PIC X VALUE X'B4'.
          05 PIC X VALUE X'B5'.
          05 PIC X VALUE X'B6'.
          05 PIC X VALUE X'B7'.
          05 PIC X VALUE X'B8'.
          05 PIC X VALUE X'B9'.
          05 PIC X VALUE X'BA'.
          05 PIC X VALUE X'BB'.
          05 PIC X VALUE X'BC'.
          05 PIC X VALUE X'BD'.
          05 PIC X VALUE X'BE'.
          05 PIC X VALUE X'BF'.
          05 PIC X VALUE X'C0'.
          05 PIC X VALUE X'C1'.
          05 PIC X VALUE X'C2'.
          05 PIC X VALUE X'C3'.
          05 PIC X VALUE X'C4'.
          05 PIC X VALUE X'C5'.
          05 PIC X VALUE X'C6'.
          05 PIC X VALUE X'C7'.
          05 PIC X VALUE X'C8'.
          05 PIC X VALUE X'C9'.
          05 PIC X VALUE X'CA'.
          05 PIC X VALUE X'CB'.
          05 PIC X VALUE X'CC'.
          05 PIC X VALUE X'CD'.
          05 PIC X VALUE X'CE'.
          05 PIC X VALUE X'CF'.
          05 PIC X VALUE X'D0'.
          05 PIC X VALUE X'D1'.
          05 PIC X VALUE X'D2'.
          05 PIC X VALUE X'D3'.
          05 PIC X VALUE X'D4'.
          05 PIC X VALUE X'D5'.
          05 PIC X VALUE X'D6'.
          05 PIC X VALUE X'D7'.
          05 PIC X VALUE X'D8'.
          05 PIC X VALUE X'D9'.
          05 PIC X VALUE X'DA'.
          05 PIC X VALUE X'DB'.
          05 PIC X VALUE X'DC'.
          05 PIC X VALUE X'DD'.
          05 PIC X VALUE X'DE'.
          05 PIC X VALUE X'DF'.
          05 PIC X VALUE X'E0'.
          05 PIC X VALUE X'E1'.
          05 PIC X VALUE X'E2'.
          05 PIC X VALUE X'E3'.
          05 PIC X VALUE X'E4'.
          05 PIC X VALUE X'E5'.
          05 PIC X VALUE X'E6'.
          05 PIC X VALUE X'E7'.
          05 PIC X VALUE X'E8'.
          05 PIC X VALUE X'E9'.
          05 PIC X VALUE X'EA'.
          05 PIC X VALUE X'EB'.
          05 PIC X VALUE X'EC'.
          05 PIC X VALUE X'ED'.
          05 PIC X VALUE X'EE'.
          05 PIC X VALUE X'EF'.
          05 PIC X VALUE X'F0'.
          05 PIC X VALUE X'F1'.
          05 PIC X VALUE X'F2'.
          05 PIC X VALUE X'F3'.
          05 PIC X VALUE X'F4'.
          05 PIC X VALUE X'F5'.
          05 PIC X VALUE X'F6'.
          05 PIC X VALUE X'F7'.
          05 PIC X VALUE X'F8'.
          05 PIC X VALUE X'F9'.
          05 PIC X VALUE X'FA'.
          05 PIC X VALUE X'FB'.
          05 PIC X VALUE X'FC'.
          05 PIC X VALUE X'FD'.
          05 PIC X VALUE X'FE'.
          05 PIC X VALUE X'FF'.

       01 CP437-CHAR REDEFINES CP437-TABLE.
          03 CP437-BYTE OCCURS 256 TIMES PIC X.
          
       01 INPUT-TEXT  PIC X(80)
          VALUE "hELLO wOLRD - cp437 test".
       01 INPUT-TEXT2 PIC X(80)
          VALUE "WELCOME TO  igp tech bbs cobol TEST".

       01  WS-CODE-PAGE         PIC 9(4) VALUE 437.
       01  CHAR-CODE            PIC 9(4) COMP-5.
       
       PROCEDURE DIVISION.
       
       MAIN-LOGIC.
            DISPLAY 'DEBUG> MAIN-LOGIC'

            PERFORM CONVERT-TO-CP437
      *      DISPLAY "Original: " INPUT-TEXT
      *      DISPLAY "CP437 Encoded: " BUFFER-OUT

      * 1. Create the listener
            CALL "C$SOCKET" USING CSOCKET-CREATE-SERVER,
                                  SERVER-PORT,
                            GIVING SERVER-SOCKET.

            IF SERVER-SOCKET < 0
               DISPLAY "Error creating server socket."
               STOP RUN
            END-IF

            DISPLAY "Server listening on port: " SERVER-PORT "..."

      * 2. Waiting client connections
            CALL "C$SOCKET" USING CSOCKET-ACCEPT,
                                  SERVER-SOCKET,
                            GIVING CLIENT-SOCKET.

            IF CLIENT-SOCKET < 0
               DISPLAY "Client connect error."
            END-IF

            DISPLAY "Client CONNECTED! Socket ID: " CLIENT-SOCKET.

            PERFORM SEND-DATA

            ACCEPT OMITTED
            STOP RUN
            .

       CONVERT-TO-CP437.
            PERFORM VARYING IDX FROM 1 BY 1
             UNTIL IDX > LENGTH OF INPUT-TEXT
              MOVE FUNCTION ORD(INPUT-TEXT(IDX:1)) TO CHAR-CODE
              IF CHAR-CODE >= 1 AND CHAR-CODE <= 256
                  MOVE CP437-BYTE(CHAR-CODE)
                      TO BUFFER-OUT(IDX:1)
              ELSE
                  MOVE "?" TO BUFFER-OUT(IDX:1)
              END-IF
            END-PERFORM

            PERFORM VARYING IDX FROM 1 BY 1
             UNTIL IDX > LENGTH OF INPUT-TEXT2
              MOVE FUNCTION ORD(INPUT-TEXT2(IDX:1)) TO CHAR-CODE
              IF CHAR-CODE >= 1 AND CHAR-CODE <= 256
                  MOVE CP437-BYTE(CHAR-CODE)
                      TO BUFFER-OUT2(IDX:1)
              ELSE
                  MOVE "?" TO BUFFER-OUT2(IDX:1)
              END-IF
            END-PERFORM
            .
       /
       READ-DATA.
            DISPLAY 'DEBUG> READ-DATA'
            PERFORM
               CALL "C$SLEEP" USING 0.5

               MOVE SPACES TO BUFFER-IN
               CALL "C$SOCKET" USING CSOCKET-READ,
                                    CLIENT-SOCKET,
                                    BUFFER-IN,
                                    LENGTH OF BUFFER-IN,
                             GIVING BYTES-READ

               IF BYTES-READ > 0
                   DISPLAY "Received MSG from client: "
                           BUFFER-IN(1:BYTES-READ)
               END-IF
            END-PERFORM
            .
       /
       SEND-DATA.
            DISPLAY 'DEBUG> SEND-DATA'
            CALL "C$SLEEP" USING 1

            MOVE SPACES TO FINAL-BUFFER
            MOVE X'93'    TO FINAL-BUFFER(1:1)
            MOVE BUFFER-OUT(1:24) TO FINAL-BUFFER(2:24)
            MOVE X'0D'    TO FINAL-BUFFER(26:1)
            MOVE X'0A'    TO FINAL-BUFFER(27:1)
            MOVE 27       TO MSG-LEN

            CALL "C$SOCKET" USING CSOCKET-WRITE,
                                 CLIENT-SOCKET,
                                 FINAL-BUFFER,
                                 MSG-LEN
                          GIVING BYTES-SENT

            IF BYTES-SENT > 0
                DISPLAY "Bytes SENT: " BYTES-SENT
                CALL "C$SLEEP" USING 2
      *          CALL "C$SOCKET" USING CSOCKET-CLOSE, CLIENT-SOCKET
            END-IF


            CALL "C$SLEEP" USING 1

            MOVE SPACES TO FINAL-BUFFER
            MOVE BUFFER-OUT2 TO FINAL-BUFFER
            MOVE X'0D'    TO FINAL-BUFFER(36:1)
            MOVE X'0A'    TO FINAL-BUFFER(36:1)
            MOVE 37       TO MSG-LEN

            CALL "C$SOCKET" USING CSOCKET-WRITE,
                                 CLIENT-SOCKET,
                                 FINAL-BUFFER,
                                 MSG-LEN
                          GIVING BYTES-SENT

            IF BYTES-SENT > 0
                DISPLAY "Bytes SENT: " BYTES-SENT
                CALL "C$SLEEP" USING 2
                CALL "C$SOCKET" USING CSOCKET-CLOSE, CLIENT-SOCKET
            END-IF
            .