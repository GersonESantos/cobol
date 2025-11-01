       $set ans85 comp
       identification division.
       program-id.cidade.
       environment division.
       input-output section.
       file-control.
           select  Ace01
                  assign to "\dados2\arquivos\ace\ACE0101"
                  organization is indexed
                  access mode  is dynamic
                  lock mode    is automatic with lock on record
                  record key   is cod-01
                  alternate record key is desc-01 with duplicates
                  file status  is FS.
       data division.
       file section.
      *File FD's here

000210 COPY "/dados1/book/FD-01".


       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".
       77 FS                         PIC XX.
       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "TCED1101.CPB".


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
          MOVE "TCED1101" TO Ds-Set-Name

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.

          PERFORM Call-Dialog-System
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
