       Class-Control.
           Interface            is class "intergra"
           produto              is class "ooce1301".

       working-storage section.
       01  a-produto        object reference.
       01  a-interface      object reference.
       01  status-ws        pic x(02).
       01  filler           redefines status-ws.
           03 st1-ws        pic 9.
           03 st2-ws        pic 9 comp.
       01  status2-ws       pic 999.
       01  mensagem-ws      pic x(40).
       01  opcao-ws         pic 9   value zeros.
       01  REG-01.
           05  CHAVE-01.
              07 COD-01     PIC X(06).
              07 COD-01R REDEFINES COD-01 PIC 9(06).
      *CODIGO DO PRODUTO
           05  DESC-01       PIC X(40).
           05  FILLER REDEFINES DESC-01.
              07 FILLER     PIC X(29).
              07 ORIG-01    PIC X(11).
           05  UND-01        PIC X(04).
           05  LIVRO-01      PIC X.
           05  CLASSECE-01   PIC X.
      *CLASSE P\EMISSAO DE MAPA DE LOJA.
      *P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
      *B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
      *UNIDADE DE FORNECIMENTO
           05  ESTMIN-01     PIC 9(07).
           05  ESTMIN-01R REDEFINES ESTMIN-01 PIC 9(05)V99.
      *ESTOQUE MINIMO
           05  QTPED-01      PIC 9(07).
           05  QTPED-01R REDEFINES QTPED-01 PIC 9(05)V99.
      *QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
           05  QTENT-01      PIC 9(07).
           05  QTENT-01R REDEFINES QTENT-01 PIC 9(05)V99.
      *QUANTIDADE ACUMULADA DE ENTREGAS NOMES
           05  QTSAIDAR-01 OCCURS 12 TIMES.
              07 QTSAI-01   PIC 9(05).
              07 QTSAI-01R REDEFINES QTSAI-01 PIC 9(03)V99.
      *QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
           05  EST-01        PIC 9(07).
           05  EST-01R REDEFINES EST-01 PIC 9(05)V99.
      *ESTOQUE DA MERCADORIA NA EMPRESA
           05  DCUSTO-01.
              07 DIACUSTO-01 PIC 99.
              07 MESCUSTO-01 PIC 99.
              07 ANOCUSTO-01 PIC 99.
           05  CONDPG-01     PIC 9(03).
      *PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
           05  DATCAD-01.
              07 DIACAD-01  PIC 99.
              07 MESCAD-01  PIC 99.
              07 ANOCAD-01  PIC 99.
      *DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
           05  DATNOV-01.
              07 MESNOV-01  PIC 99.
              07 ANONOV-01  PIC 99.
      *MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
           05  CODTAB-01     PIC X(01).
           05  CONTOU-01     PIC X(01).
           05  CODFOR-01     PIC 9(04).
           05  CREAL-01      PIC 9(10).
           05  CREAL-01R REDEFINES CREAL-01 PIC 9(08)V99.
      *CUSTO REAL
           05  CMEDIO-01     PIC 9(10).
           05  CMEDIO-01R REDEFINES CMEDIO-01 PIC 9(08)V99.
      *CUSTO MEDIO.
           05  PRATAC-01     PIC 9(10).
           05  PRATAC-01R REDEFINES PRATAC-01 PIC 9(08)V99.
      *PRECO DE VENDA NO ATACADO
           05  PRVAR-01      PIC 9(10).
           05  PRVAR-01R REDEFINES PRVAR-01 PIC 9(08)V99.
      *PRECO DE VENDA NO VAREJO
           05  VRPU-01       PIC 9(10).
           05  VRPU-01R REDEFINES VRPU-01 PIC 9(08)V99.
           05  CATUAL-01     PIC 9(10).
           05  CATUAL-01R REDEFINES CATUAL-01 PIC 9(08)V99.
      *CUSTO ATUAL
           05  EMB-01        PIC 999.
           05  ARTIGO-01     PIC 9(06).
           05  DTCON-01.
              07 ACON-01    PIC 9(02).
              07 MCON-01    PIC 9(02).
              07 DCON-01    PIC 9(02).
      * DATA DA CONTAGEM DE ESTOQUE.
           05  RAZ-01      PIC X(01).
      *S SAI NO RAZAO
           05  FILLER        PIC X(03).
           05  CODLUZA-01    PIC X(05).
           05  CONFPR-01     PIC X(01).
           05  CONFCUS-01    PIC X(01).
           05  CODTRI-01     PIC 9.
           05  DATINF-01.
              07 DIAINF-01  PIC 99.
              07 MESINF-01  PIC 99.
      *DATA DO ULTIMO INFLACIONAMENTO DO CUSTO REAL
      *======================================

       procedure division.
           invoke produto       "new" returning a-produto
           invoke Interface     "new" returning a-interface
           invoke a-produto     "abrir" returning status-ws
           if status-ws not = "00" and "05"
              move "Erro no cadastro de Produto" to mensagem-ws
              invoke a-interface "mostraMensagem" using mensagem-ws
              stop run.
 
           move zeros to opcao-ws
 
           perform until opcao-ws = 3
              invoke a-interface "recebeOpcao" returning opcao-ws
              if opcao-ws = 7
                 perform cadastro-produtos thru fim-cadastro-produtos
              end-if
           end-perform
           invoke a-produto "fechar" returning status-ws
           if status-ws not = "00" and "05"
              move "Erro no cadastro de Produto" to mensagem-ws
              invoke a-interface "mostraMensagem" using mensagem-ws.
           stop run.

      ****************************************************************
      *  sub-rotinas                                                 *
      ****************************************************************
 
       cadastro-produtos.
           initialize reg-01.
           invoke a-interface "recebeproduto"    returning cod-01.
           invoke a-produto   "ler" using cod-01 returning status-ws
           invoke a-produto   "retornaDados"     returning reg-01 .
           invoke a-interface "mostraproduto"    using reg-01.
       fim-cadastro-produtos.
           exit.
 
