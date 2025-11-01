       Identification Division.
       Class-Id. Interface
                 inherits from Base with data.
       environment division.
       Object Section.
       Class-Control.
           Interface      is class "intergra".
       data division.
       working-storage section.
       78  Dialog-System   value "DSRUN".
 
           Copy "dssysinf.cpy".
           Copy "ds-cntrl.mf".
           Copy "intergra.cpb".
 
       Class-Object.
       Object-Storage Section.
       End Class-Object.
 
       Object.
       Data Division.
       Object-Storage Section.
       01  valor-edit      pic -------9.99.
       01  data-edit       pic 99/99/9999.
       01  a-produto       object reference.
       01  a-clientes      object reference.
       01  a-contasReceber object reference.
       01  status-ws        pic x(02).
       01  stop-ws          pic x(01).
       01  primvez-ws       pic x(01) value "S".
       01  situacao-ant     pic x(01).
       01  valor-ant        pic 9(07)v99.
 
       01  reg-cli.
           03 codigo-cli          pic x(04).
           03 nome-cli            pic x(30).
           03 endereco-cli        pic x(40).
           03 saldo-cli           pic s9(07)v99 comp-3.
           03 observ-cli          pic x(50).
 
       01  reg-cont.
           03 codigo-cli-cont     pic x(4).
           03 num-titulo-cont     pic x(10).
           03 descricao-cont      pic x(30).
           03 valor-cont          pic s9(7)v9(2) comp-3.
           03 data-venc-cont      pic 9(8).
           03 situacao-cont       pic x.
 
       Method-id. recebeOpcao.


       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "MENU.CPB".

       linkage section.
       01  opcao-ls    pic 9.
       procedure division returning opcao-ls.

       Main-Process SECTION.
          PERFORM Program-Initialize
          PERFORM Program-Body UNTIL EXIT-FLAG-TRUE
          go to Program-Terminate
          .

      *---------------------------------------------------------------*

       Program-Initialize SECTION.

          INITIALIZE Ds-Control-Block
          INITIALIZE Data-block
          MOVE Data-block-version-no
                                   TO Ds-Data-Block-Version-No
          MOVE Version-no TO Ds-Version-No

          MOVE Ds-New-Set TO Ds-Control
          MOVE "MENU" TO Ds-Set-Name

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.
          PERFORM Call-Dialog-System
          if flag = "p"
             move 7 to opcao-ls
             move 1 to EXIT-FLAG.

          .

      *---------------------------------------------------------------*
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

       End Method recebeOpcao.


       Method-id. recebeproduto.

       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "TCED1201.CPB".

       linkage section.
       01  cod-ls    pic 9(06).
       procedure division returning cod-ls.

      *---------------------------------------------------------------*

       Main-Process SECTION.
          PERFORM Program-Initialize
          PERFORM Program-Body UNTIL EXIT-FLAG-TRUE
      *   PERFORM Program-Terminate
          go to Program-Terminate

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
          PERFORM L-S

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.
          move cod-01cpb to cod-ls
          move 1 to EXIT-FLAG.
          .

       L-S SECTION.

           MOVE ds-new-set TO ds-control
           MOVE "TCED1201" TO ds-set-name
           PERFORM Call-Dialog-System.



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
       exit.
          .
       Program-Terminate SECTION.
        exit.
       End Method recebeproduto.

       Method-id. mostraproduto.

       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".

       01 Display-Error.
          03 Display-Error-No             PIC 9(4) comp-5.
          03 Display-Details-1            PIC 9(4) comp-5.
          03 Display-Details-2            PIC 9(4) comp-5.

       COPY "DS-CNTRL.MF".
       COPY "TCED1201.CPB".

       linkage section.
000060 01  REG-01.
000070     05  CHAVE-01.
000080        07 COD-01     PIC X(06).
000090        07 COD-01R REDEFINES COD-01 PIC 9(06).
000100*CODIGO DO PRODUTO
000110     05  DESC-01       PIC X(40).
000110     05  FILLER REDEFINES DESC-01.
              07 FILLER     PIC X(29).
000770        07 ORIG-01    PIC X(11).
000120     05  UND-01        PIC X(04).
000130     05  LIVRO-01      PIC X.
000140     05  CLASSECE-01   PIC X.
000150*CLASSE P\EMISSAO DE MAPA DE LOJA.
000160*P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
000170*B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
000180*UNIDADE DE FORNECIMENTO
000190     05  ESTMIN-01     PIC 9(07).
000200     05  ESTMIN-01R REDEFINES ESTMIN-01 PIC 9(05)V99.
000210*ESTOQUE MINIMO
000220     05  QTPED-01      PIC 9(07).
000230     05  QTPED-01R REDEFINES QTPED-01 PIC 9(05)V99.
000240*QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
000250     05  QTENT-01      PIC 9(07).
000260     05  QTENT-01R REDEFINES QTENT-01 PIC 9(05)V99.
000270*QUANTIDADE ACUMULADA DE ENTREGAS NOMES
000280     05  QTSAIDAR-01 OCCURS 12 TIMES.
000290        07 QTSAI-01   PIC 9(05).
000300        07 QTSAI-01R REDEFINES QTSAI-01 PIC 9(03)V99.
000310*QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
000320     05  EST-01        PIC 9(07).
000330     05  EST-01R REDEFINES EST-01 PIC 9(05)V99.
000340*ESTOQUE DA MERCADORIA NA EMPRESA
000350     05  DCUSTO-01.
000360        07 DIACUSTO-01 PIC 99.
000370        07 MESCUSTO-01 PIC 99.
000380        07 ANOCUSTO-01 PIC 99.
000390     05  CONDPG-01     PIC 9(03).
000400*PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
000410     05  DATCAD-01.
000420        07 DIACAD-01  PIC 99.
000430        07 MESCAD-01  PIC 99.
000440        07 ANOCAD-01  PIC 99.
000450*DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
000460     05  DATNOV-01.
000470        07 MESNOV-01  PIC 99.
000480        07 ANONOV-01  PIC 99.
000490*MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
000500     05  CODTAB-01     PIC X(01).
000510     05  CONTOU-01     PIC X(01).
000520     05  CODFOR-01     PIC 9(04).
000530     05  CREAL-01      PIC 9(10).
000540     05  CREAL-01R REDEFINES CREAL-01 PIC 9(08)V99.
000550*CUSTO REAL
000560     05  CMEDIO-01     PIC 9(10).
000570     05  CMEDIO-01R REDEFINES CMEDIO-01 PIC 9(08)V99.
000580*CUSTO MEDIO.
000590     05  PRATAC-01     PIC 9(10).
000600     05  PRATAC-01R REDEFINES PRATAC-01 PIC 9(08)V99.
000610*PRECO DE VENDA NO ATACADO
000620     05  PRVAR-01      PIC 9(10).
000630     05  PRVAR-01R REDEFINES PRVAR-01 PIC 9(08)V99.
000640*PRECO DE VENDA NO VAREJO
000650     05  VRPU-01       PIC 9(10).
000660     05  VRPU-01R REDEFINES VRPU-01 PIC 9(08)V99.
000670     05  CATUAL-01     PIC 9(10).
000680     05  CATUAL-01R REDEFINES CATUAL-01 PIC 9(08)V99.
000690*CUSTO ATUAL
000700     05  EMB-01        PIC 999.
000710     05  ARTIGO-01     PIC 9(06).
000720     05  DTCON-01.
000730        07 ACON-01    PIC 9(02).
000740        07 MCON-01    PIC 9(02).
000750        07 DCON-01    PIC 9(02).
000760* DATA DA CONTAGEM DE ESTOQUE.
000770     05  RAZ-01      PIC X(01).
      *S SAI NO RAZAO
000770     05  FILLER        PIC X(03).
000770     05  CODLUZA-01    PIC X(05).
000770     05  CONFPR-01     PIC X(01).
000770     05  CONFCUS-01    PIC X(01).
000780     05  CODTRI-01     PIC 9.
000790     05  DATINF-01.
000800        07 DIAINF-01  PIC 99.
000810        07 MESINF-01  PIC 99.
000820*DATA DO ULTIMO INFLACIONAMENTO DO CUSTO REAL
       procedure division using reg-01.


      *---------------------------------------------------------------*

       Main-Process SECTION.
          .
      *---------------------------------------------------------------*

       Program-Initialize SECTION.

          INITIALIZE Ds-Control-Block
          INITIALIZE Data-block
          MOVE Data-block-version-no
                                   TO Ds-Data-Block-Version-No
          MOVE Version-no TO Ds-Version-No
          if desc-01 not = spaces
              move reg-01 to reg-01cpb.
          MOVE Ds-New-Set TO Ds-Control
          MOVE "TCED1201" TO Ds-Set-Name
          PERFORM L-S

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.
          move 1 to EXIT-FLAG.

          .
      *---------------------------------------------------------------*
       Program-Terminate SECTION.
        exit.


       L-S SECTION.

           MOVE ds-new-set TO ds-control
           MOVE "TCED1201" TO ds-set-name
           PERFORM Call-Dialog-System.



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
       exit.
          .
       End Method mostraproduto.





 
      ****************************************************
      * Clientes                                         *
      ****************************************************
 
       Method-id. rececliente.
       linkage section.
       01  codigo-ls    pic x(04).
       procedure division returning codigo-ls.
       recebe-codigo.
           move ds-continue   to ds-control
      *    invoke self "   "
           Call Dialog-System using DS-CONTROL-BLOCK,
                                    DATA-BLOCK, DS-EVENT-BLOCK
           invoke self "move-ds-to-ws"
           if funcao-dsg = "F1"
              invoke a-clientes "ler" using codigo-cli
                                      returning status-ws
              if status-ws = "00"
                 invoke a-clientes "retornaDados" returning reg-cli
              else
                 move spaces to nome-cli
                 move spaces to nome-cli-dsg
                 move spaces to endereco-cli
                 move spaces to endereco-cli-dsg
                 move zeros  to saldo-cli
                 move zeros  to saldo-cli-dsg
              end-if
              go to recebe-codigo.
 
           if funcao-dsg = "F2"
              invoke a-clientes "ler-proximo"
                     using codigo-cli returning status-ws
              if status-ws = "00"
                 invoke a-clientes "retornaDados" returning reg-cli
              end-if
              go to recebe-codigo.
 
           if funcao-dsg = "F3"
              invoke a-clientes "ler-anterior"
                     using codigo-cli returning status-ws
              if status-ws = "00"
                 invoke a-clientes "retornaDados" returning reg-cli
              end-if
              go to recebe-codigo.
 
           if funcao-dsg = "F4"
              invoke a-clientes "excluir"
                     using codigo-cli returning status-ws
              go to recebe-codigo.
 
           if funcao-dsg = "F5"
              invoke a-clientes "ler" using codigo-cli
                                      returning status-ws
              if status-ws = "00"
                 invoke a-clientes "moveDados"
                        using reg-cli
                 invoke a-clientes "regravar"
                        using codigo-cli returning status-ws
               else
                  invoke a-clientes "moveDados"
                         using reg-cli
                  invoke a-clientes "gravar"
                         using codigo-cli returning status-ws
               end-if
               go to recebe-codigo.
 
           if codigo-cli not = spaces
              go to recebe-codigo.
 
           move codigo-cli to codigo-ls.
       End Method   rececliente.
 
       Method-id. guardaRefCliente.
       linkage section.
       01  ls-clientes       object reference.
       procedure division using ls-clientes.
           move ls-clientes to a-clientes.
       End Method guardaRefCliente.
 
      ****************************************************
      * Contas a Receber                                 *
      ****************************************************
 
       Method-id. recebeCliente2.
       Working-storage section.
       01  chave-cont.
           03 codigo-cli-ws pic x(04).
           03 num-titulo-ws pic x(10).
       linkage section.
       01  codigo-ls    pic x(04).
       procedure division returning codigo-ls.
       recebe-codigo2.
           move ds-continue   to ds-control
           invoke self "move-ws-to-ds"
           Call Dialog-System using DS-CONTROL-BLOCK,
                                    DATA-BLOCK, DS-EVENT-BLOCK
           invoke self "move-ds-to-ws"
           move spaces to mensagem-dsg
           if funcao-dsg = "F1"
              move codigo-cli-cont to codigo-cli-ws
              move num-titulo-cont to num-titulo-ws
              invoke a-contasReceber "ler"
                     using chave-cont returning status-ws
              if status-ws = "00"
                invoke a-contasReceber "retornaDados" returning reg-cont
              else
                initialize reg-cont
                initialize reg-cont-dsg
              end-if
              move situacao-cont to situacao-ant
              move valor-cont    to valor-ant
              go to recebe-codigo2.
 
           if funcao-dsg = "F2"
              move codigo-cli-cont to codigo-cli-ws
              move num-titulo-cont to num-titulo-ws
              invoke a-contasReceber "ler-proximo"
                     using chave-cont returning status-ws
              if status-ws = "00"
                invoke a-contasReceber "retornaDados" returning reg-cont
              else
                initialize reg-cont
                initialize reg-cont-dsg
              end-if
              move situacao-cont to situacao-ant
              move valor-cont    to valor-ant
              go to recebe-codigo2.
 
           if funcao-dsg = "F3"
              move codigo-cli-cont to codigo-cli-ws
              move num-titulo-cont to num-titulo-ws
              invoke a-contasReceber "ler-anterior"
                     using chave-cont returning status-ws
              if status-ws = "00"
                invoke a-contasReceber "retornaDados" returning reg-cont
              else
                initialize reg-cont
                initialize reg-cont-dsg
              end-if
              move situacao-cont to situacao-ant
              move valor-cont    to valor-ant
              go to recebe-codigo2.
 
           if funcao-dsg = "F4"
             move codigo-cli-cont to codigo-cli-ws
             move num-titulo-cont to num-titulo-ws
             invoke a-contasReceber "ler"
                    using chave-cont returning status-ws
             if status-ws = "00"
               invoke a-contasReceber "retornaDados" returning reg-cont
               invoke a-contasReceber "excluir"
                      using chave-cont returning status-ws
               if situacao-cont = "A"
                 subtract valor-cont from saldo-cli
                 invoke a-clientes "moveDados" using reg-cli
                 invoke a-clientes "regravar"
                        using codigo-cli returning status-ws
               end-if
             end-if
             go to recebe-codigo2.
 
           if funcao-dsg = "TE"
              invoke a-clientes "ler" using codigo-cli-cont
                                      returning status-ws
              if status-ws not = "00"
                 move "Cliente Inexistente" to mensagem-dsg
              end-if
              if num-titulo-cont = spaces
                 move "Titulo Invalido" to mensagem-dsg
              end-if
              if situacao-cont not = "A" and "L"
                 move "Situacao Invalida" to mensagem-dsg
              end-if
              go to recebe-codigo2.
 
           if funcao-dsg = "F5"
              move codigo-cli-cont to codigo-cli-ws
              move num-titulo-cont to num-titulo-ws
              invoke a-contasReceber "ler"
                     using chave-cont returning status-ws
              if status-ws = "00"
                 invoke a-contasReceber "moveDados"
                        using reg-cont
                 invoke a-contasReceber "regravar"
                        using chave-cont returning status-ws
                 if situacao-cont = "A"
                    add valor-cont to saldo-cli
                    invoke a-clientes "moveDados"
                           using reg-cli
                    invoke a-clientes "regravar"
                           using codigo-cli-cont returning status-ws
                 end-if
              else
                 if situacao-ant = "A"
                    subtract valor-ant from saldo-cli
                 end-if
                 invoke a-contasReceber "moveDados"
                        using reg-cont
                 invoke a-contasReceber "gravar"
                        using chave-cont returning status-ws
                 if situacao-cont = "A"
                    add valor-cont to saldo-cli
                 end-if
                 invoke a-clientes "moveDados"
                        using reg-cli
                 invoke a-clientes "regravar"
                        using codigo-cli-cont returning status-ws
              end-if
              go to recebe-codigo2.
 
           if codigo-cli-cont not = spaces
              go to recebe-codigo2.
 
           move codigo-cli-cont to codigo-ls.
 
       End Method recebeCliente2.
 
       Method-id. guardaRefContas.
       linkage section.
       01  ls-contasReceber  object reference.
       procedure division using ls-contasReceber.
           move ls-contasReceber to a-contasReceber.
       End Method guardaRefContas.
 
       Method-id. move-ws-to-ds.
       procedure division.
           move codigo-cli   to codigo-cli-dsg
           move nome-cli     to nome-cli-dsg
           move endereco-cli to endereco-cli-dsg
           move saldo-cli    to saldo-cli-dsg
 
           move codigo-cli-cont to codigo-cli-cont-dsg
           move num-titulo-cont to num-titulo-cont-dsg
           move descricao-cont  to descricao-cont-dsg
           move valor-cont      to valor-cont-dsg
           move data-venc-cont  to data-venc-cont-dsg
           move situacao-cont   to situacao-cont-dsg.
       End Method move-ws-to-ds.
 
       Method-id. move-ds-to-ws.
       procedure division.
           move codigo-cli-dsg   to codigo-cli
           move nome-cli-dsg     to nome-cli
           move endereco-cli-dsg to endereco-cli
           move saldo-cli-dsg    to saldo-cli
 
           move codigo-cli-cont-dsg to codigo-cli-cont
           move num-titulo-cont-dsg to num-titulo-cont
           move descricao-cont-dsg  to descricao-cont
           move valor-cont-dsg      to valor-cont
           move data-venc-cont-dsg  to data-venc-cont
           move situacao-cont-dsg   to situacao-cont.
       End Method move-ds-to-ws.
 
       End Object.
       End Class Interface.
