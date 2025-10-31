000020********************************************
000010****** ALTERTADO POR CLAUDIO (10\02\96)
000030*OCE1201-MANUTENCAO DE PRODUTOS NA EMPRESA  COMPILDO 01\08\2005*
000040********************************************
000020$ set osvs ms(2) nowarning

000050 IDENTIFICATION DIVISION.
000060 PROGRAM-ID. PRODUTOS.
000070 COPY "\dados1\book\SELCE".
000080 COPY "\dados1\book\SELC-01".
000090 COPY "\dados1\book\SELC-02".
000100 COPY "\dados1\book\SELC-05".
000110     SELECT RELATO  ASSIGN TO PRINTER
000120                    FILE STATUS IS FS.
000130 COPY "\dados1\book\FDCE".
000140 COPY "\dados1\book\FD-01".
000150 COPY "\dados1\book\FD-02".
000160 COPY "\dados1\book\FD-05".
000170 COPY "\dados1\book\FDREL80".
000180 COPY "\dados1\book\TAB-W".
       COPY "\dados1\book\cpywsds".


       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "TEXT.CPB".
001910 COPY "\dados1\book\CPYPDCE".

001930 R-0000.
001970     move 01 to COMP-01 comp-02 comp-05.
002040     OPEN I-O ACE02.
002050     IF FS NOT = "00"
002060        MOVE "MCE1201B" TO CODMENFS
002070        MOVE "ACE02"     TO ARQFS
002080        PERFORM TESTA-FS THRU SAI-TESTA-FS
002090        CLOSE ACE02 ACE01 STOP RUN.
002100     OPEN INPUT ACE05.
002110     IF FS NOT = "00"
002120        MOVE "MCE1201D" TO CODMENFS
002130        MOVE "ACE05"     TO ARQFS
002140        PERFORM TESTA-FS THRU SAI-TESTA-FS
002150        CLOSE ACE05 ACE01 ACE02 STOP RUN.


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
          MOVE "TEXT" TO Ds-Set-Name
          .

      *---------------------------------------------------------------*

       Program-Body SECTION.
          EVALUATE TRUE

              WHEN OPERACAO = "ABRIR-ARQ"
                  PERFORM ABRIR-ARQUIVOS

              WHEN OPERACAO = "LER-PROD"

                  PERFORM LER-PRODUTOS.



          PERFORM Call-Dialog-System
          .

      *---------------------------------------------------------------*

       Program-Terminate SECTION.

          STOP RUN
          .

       LER-PRODUTOS SECTION.

          MOVE CODCPB-01 TO COD-01.
          READ ACE01 INVALID KEY
            MOVE "NAO ENCONTRADO" TO DESC-01
            MOVE ALL ZEROS        TO PRATAC-01R
            MOVE SPACES           TO UND-01
            MOVE "PROD-NAO-E"     TO OPERACAO.
          MOVE DESC-01      TO DESCCPB-01
          MOVE PRATAC-01R   TO PRATACCPB-01R
          MOVE UND-01       TO UNDCPB-01.
          MOVE PRVAR-01R    TO PRVARCPB-01R.
          MOVE EST-01R      TO ESTCPB-01R
          .
      *

      *---------------------------------------------------------------*
       ABRIR-ARQUIVOS SECTION.

          OPEN INPUT ACE01.
          IF FS NOT = 00
             MOVE "ERRO-ABRIR" TO OPERACAO.


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
001920 COPY "\dados1\book\CPYPDFS".

