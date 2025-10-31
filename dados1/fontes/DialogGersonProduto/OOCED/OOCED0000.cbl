       PROGRAM-ID.OOCED0000.

       CLASS-CONTROL.
      * para criar a clase dados
           ooced1201              is class "ooced1201" .

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  a-ooce1201         object reference.
       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.
       01 status-ws                       pic xx.
       COPY "DS-CNTRL.MF".
       COPY "OOCED0000.CPB".


       PROCEDURE DIVISION.

      *---------------------------------------------------------------*
      *    invoke oceace01       "new" returning a-oceace01.
           invoke ooced1201       "new" returning a-ooce1201.

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
          MOVE "OOCE0000" TO Ds-Set-Name

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.

          PERFORM Call-Dialog-System
          if OPCAO  = "OOCE1201"
               invoke a-ooce1201 "manut" returning opcao
               move 1 to EXIT-FLAG.



          .

      *---------------------------------------------------------------*

       Program-Terminate SECTION.

          STOP RUN
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
