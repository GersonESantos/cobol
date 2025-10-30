000020$ set osvs ms(2) nowarning
       IDENTIFICATION DIVISION.
000060 PROGRAM-ID. PRODUTOS.
000070 COPY "C:\Repo2024\cobol\dados1\book\SELCE".
000080 COPY "C:\Repo2024\cobol\dados1\book\SELC-01".
000090 COPY "C:\Repo2024\cobol\dados1\book\SELC-02".
000100 COPY "C:\Repo2024\cobol\dados1\book\SELC-05".
000110     SELECT RELATO  ASSIGN TO PRINTER
000120                    FILE STATUS IS FS.


000130 COPY "C:\Repo2024\cobol\dados1\book\FDCE".
000140 COPY "C:\Repo2024\cobol\dados1\book\FD-01".
000150 COPY "C:\Repo2024\cobol\dados1\book\FD-02".
000160 COPY "C:\Repo2024\cobol\dados1\book\FD-05".
000170 COPY "C:\Repo2024\cobol\dados1\book\FDREL80".
000180 COPY "C:\Repo2024\cobol\dados1\book\TAB-W".
000180 COPY "C:\Repo2024\cobol\dados1\book\cpywsds".

       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "PRODUTO.CPB".
001910 COPY "C:\Repo2024\cobol\dados1\book\CPYPDCE".
00193
           move 01 to comp-01 comp-02 comp-05.

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
      ****************************************************************


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
          MOVE "produto" TO Ds-Set-Name
          MOVE "ABRIR-ARQ" TO OPERACAO.

          .
          MOVE "ABRIR-ARQ" TO OPERACAO.
       ABRIR-ARQUIVOS SECTION.
           OPEN I-O ACE01.
001990     IF FS NOT = "00"
                MOVE "ERRO-ABERT" TO OPERACAO.

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
       LER-PRODUTOS SECTION.
          MOVE CODCPB   TO COD-01
          READ ACE01 INVALID KEY
            MOVE "NAO ENCONTRADO" TO DESC-01
            MOVE "PROD-NAO-E" TO OPERACAO.
          IF OPERACAO NOT = "PROD-NAO-E"
            MOVE DESC-01    TO DESCCPB
            MOVE PRATAC-01R TO PRATACCPB
            MOVE UND-01     TO UNDCPB.
          MOVE DESC-01    TO DESCCPB.
          MOVE PRATAC-01R TO PRATACCPB.
          MOVE UND-01     TO UNDCPB.

001920 COPY "C:\Repo2024\cobol\dados1\book\CPYPDFS".



