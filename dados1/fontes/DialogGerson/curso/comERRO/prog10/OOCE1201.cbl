       Identification Division.

       Class-Id. ooce1201
                 inherits from Base with data.

      ********************** Metodos de Classe ************************
       CLASS-CONTROL.
      * para criar a clase dados
           OCEACE01              is class "oceace01" .

       Class-Object.
       Object-Storage Section.

       End Class-object.

      ********************** Metodos de Instancia *********************

       Object.
       Environment Division.
       input-output section.
       file-control.

       data division.
       file section.

       working-storage section.
       01  a-oceace01        object reference.
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

       object-storage section.

       Method-id. manut.
       Data Division.
       linkage Section.
       01  status-ls      pic x(02).
       Procedure Division returning status-ls.
           invoke oceace01       "new" returning a-oceace01.


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
          MOVE "TCED1201" TO Ds-Set-Name .

          invoke a-oceace01     "abrir" returning fs
          if fs not = "00" and "05"
              MOVE FS TO FSMENS
              MOVE "MCE1301B" TO CODMENFS
              MOVE "ACE01" TO ARQFS
              PERFORM TESTA-FS THRU SAI-TESTA-FS
              MOVE MENS-FS TO MENS-ERRO
              move "EAACE" to ds-procedure
              PERFORM Call-Dialog-System
              move 1 to EXIT-FLAG .


      *   PERFORM L-S

       Program-Body SECTION.
           EVALUATE TRUE
               WHEN E-FLAG-TRUE
                   PERFORM E
               WHEN P-FLAG-TRUE
                   PERFORM P
               WHEN I-FLAG-TRUE
                   PERFORM I
               WHEN R-FLAG-TRUE
                   PERFORM R

      *            PERFORM Save-Record
      *        WHEN customer-clr-flg-true
      *            PERFORM Clear-Record
                .
      *   PERFORM Call-Dialog-System
          PERFORM C-F
          PERFORM L-S .
       P SECTION.
           invoke a-oceace01 "ler" using  cod-01cpb returning fs.
           IF FS = 23
              move "nleu" to ds-procedure
           .

           invoke a-oceace01 "retornaDados"         returning reg-01cpb.
           .
       I SECTION.
           invoke a-oceace01 "ler" using  cod-01cpb returning fs.
           if fs = 23
             invoke a-oceace01 "gravar"  using reg-01cpb
           else
             move "rewrite" to ds-procedure
           .
       R SECTION.
           invoke a-oceace01 "regravar"   using reg-01cpb returning fs
           initialize reg-01cpb
           .
       E SECTION.
           invoke a-oceace01 "ler" using  cod-01cpb returning fs.
           if fs = 00
              invoke a-oceace01 "excluir"   using reg-01cpb returning fs
           else
              move "nleu" to ds-procedure.
           .
       F-S-F-R SECTION.

      *    MOVE COD-01  TO COD-01CPB
      *    MOVE DESC-01 TO DESC-01CPB

           .
      *---------------------------------------------------------------*
       L-S SECTION.

           MOVE ds-new-set TO ds-control
           MOVE "TCED1201" TO ds-set-name
           PERFORM Call-Dialog-System.

      *---------------------------------------------------------------*
       C-F section.
          initialize flags
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
       Program-Terminate SECTION.

          STOP RUN
          .

       copy C:\Repo2024\cobol\dados1\book\CPYPDFS.

       End Method manut.
       End Object.
       End Class ooce1201.

