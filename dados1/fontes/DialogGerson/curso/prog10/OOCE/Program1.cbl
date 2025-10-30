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
          open input ACE01
          PERFORM L-S

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
      *                PERFORM Derivations
               END-READ
           ELSE
               INITIALIZE REG-01CPB
           END-IF
      *    PERFORM Set-Up-For-Refresh-Screen.
           .
      *---------------------------------------------------------------*
       L-S SECTION.

           MOVE ds-new-set TO ds-control
           MOVE "TCED1201" TO ds-set-name
           PERFORM Call-Dialog-System.



      *---------------------------------------------------------------*

      *Set-Up-For-Refresh-Screen SECTION.

      *    MOVE refresh-text-and-data-proc TO ds-proc-no.

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
      *
       End Object.
       End Class ooce1201.




       .


