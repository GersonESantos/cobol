      ****************************************************************
      * PROGRAMA 6   * validacao
      *    -no data block criar dec-01bd e relaciona master filds
      *    -screenset error mensages incluir save a mensagen
      *    -nao equecer de mover o arquivo dserro.err para
      *       dentro do release
      *    -criar mens.erro no data block
      *    *  no data block  clicar em options error messagen field
      *    -criar object menssage box Name     MCE1101box2
      *                               Heading  ERRO DE DIGITAÇAO  *
      *                               text     A Descriçao nao pode ser espaço
      *                               Parent   $window
      *    - screnn section globol dialog no finalcdigitar             *
      *                 val-error                                      *
      *                   invoked-menssagee-box mce1101box2 mens-erro
      *                   $register
      *                   set-focus $Event-data
      *      no data block  selecionar desc-01db
      *                                validation
      *                                disallow nulls
      *                                2
      *      p/ validar opçao 1 no pb dialag
      *                        BUTtOn-selected
      *                           validate $window
      *                 opçao 2 no ef dialag
      *                        lost-focus
      *                        validate $control
      ****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".

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
      *   move all zeros to cod-01cpb
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
