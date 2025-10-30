      $SET ans85
       IDENTIFICATION DIVISION.
       PROGRAM-ID. OCED1201.


       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *copy \dados1\book\selc-01.
       copy D:\MeuDiscoCobol\dados1\book\selc-01.
       DATA DIVISION.

       copy D:\MeuDiscoCobol\dados1\bookfd-01.

       WORKING-STORAGE SECTION.
       01  MENS-FS.
           05 CODMENFS    PIC X(08) VALUE SPACES.
           05 FILLER      PIC X(01) VALUE "-".
           05 ARQFS       PIC X(08) VALUE SPACES.
           05 FILLER      PIC X(01) VALUE "-".
           05 MENFS       PIC X(45) VALUE SPACES.
           05 FILLER      PIC X(01) VALUE "-".
           05 FSMENS      PIC XX.
      *******************************************

       01  FS.
           03 FS1         PIC X(01).
           03 FS2         PIC X(01).
      *    03 FS2-BIN REDEFINES FS2 PIC 9(02) COMP-X.
       01  FS-T.
           03 FS1-T       PIC X(01).
           03 FILLER      PIC X(01).
           03 FS2-T       PIC 9(03).


       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "TCED1201.CPB".


       PROCEDURE DIVISION.

      *---------------------------------------------------------------*

       Main-Process SECTION.
          PERFORM Program-Initialize
          PERFORM Program-Body UNTIL EXIT-FLAG-TRUE
          PERFORM Program-Terminate
          .

      *---------------------------------------------------------------*

       Program-Initialize SECTION.

          INITIALIZE Ds-Control-Block
          INITIALIZE Data-block
          MOVE Data-block-version-no
                                   TO Ds-Data-Block-Version-No
          MOVE Version-no TO Ds-Version-No

          MOVE Ds-New-Set TO Ds-Control
          MOVE "TCED1201" TO Ds-Set-Name
          open input ACE01.
          IF FS NOT = "00"
              MOVE FS TO FSMENS
              MOVE "MCE1301B" TO CODMENFS
              MOVE "ACE01" TO ARQFS
              PERFORM TESTA-FS THRU SAI-TESTA-FS
              MOVE MENS-FS TO MENS-ERRO
              move "EAACE" to ds-procedure
              PERFORM Call-Dialog-System
              move 1 to EXIT-FLAG
              CLOSE ACE01.

      *   PERFORM L-S

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.
           EVALUATE TRUE
      *        WHEN customer-del-flg-true
      *            PERFORM Delete-Record
               WHEN P-FLAG-TRUE
                   PERFORM P
      *        WHEN customer-save-flg-true
      *            PERFORM Save-Record
      *        WHEN customer-clr-flg-true
      *            PERFORM Clear-Record
                .
      *   PERFORM Call-Dialog-System
          PERFORM L-S

          .

      *---------------------------------------------------------------*

       Program-Terminate SECTION.

          STOP RUN
          .
      *---------------------------------------------------------------*

       P SECTION.

           INITIALIZE REG-01
           MOVE COD-01CPB TO COD-01
           IF COD-01 NOT = ZEROS
               READ ACE01
                   INVALID KEY
                       INITIALIZE REG-01CPB
                       MOVE COD-01 TO COD-01CPB
                   NOT INVALID KEY
                       PERFORM F-S-F-R
               END-READ
           ELSE
               INITIALIZE REG-01CPB
           END-IF
           .
      *---------------------------------------------------------------*
       L-S SECTION.

           MOVE ds-new-set TO ds-control
           MOVE "TCED1201" TO ds-set-name
           PERFORM Call-Dialog-System.



      *---------------------------------------------------------------*

      *---------------------------------------------------------------*

       F-S-F-R SECTION.

           MOVE COD-01  TO COD-01CPB
           MOVE DESC-01 TO DESC-01CPB

           .
      *---------------------------------------------------------------*

       Call-Dialog-System SECTION.

          CALL dialog-system USING Ds-Control-Block,
                                   Data-Block
          IF NOT Ds-No-Error
              MOVE Ds-System-Error TO Display-error
              DISPLAY "DS ERROR NO:   "  Display-error-no
              DISPLAY "Error Details(1) :   "  Display-Details-1
              DISPLAY "Error Details(2) :   "  Display-Details-2
              PERFORM Program-Terminate
          END-IF
          .
       COPY "/dados1/book/CPYPDFS".



