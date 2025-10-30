      *********************************
      * FD-01DBL ARQUIVO ACE01, PRODUTOS *
      *********************************
       03  REG-01DBL.
           05 COD-01DBL         PIC 9(06).
      *CODIGO DO PRODUTO
           05  DESC-01DBL       PIC X(40).
           05  UND-01DBL        PIC X(04).
           05  LIVRO-01DBL      PIC X.
           05  CLASSECE-01DBL   PIC X.
      *CLASSE P\EMISSAO DE MAPA DE LOJA.
      *P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
      *B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
      *UNIDADE DE FORNECIMENTO
           05  ESTMIN-01DBL     PIC 9(07).
      *ESTOQUE MINIMO
           05  QTPED-01DBL      PIC 9(07).
      *QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
           05  QTENT-01DBL      PIC 9(07).
      *QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
           05  EST-01DBL        PIC 9(07).
      *ESTOQUE DA MERCADORIA NA EMPRESA
           05  DCUSTO-01DBL     PIC 9(06).
           05  CONDPG-01DBL     PIC 9(03).
      *PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
           05  DATCAD-01DBL     PIC 9(06).
      *DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
           05  DATNOV-01DBL     PIC 9(04).
      *MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
           05  CODTAB-01DBL     PIC X(01).
           05  CONTOU-01DBL     PIC X(01).
           05  CODFOR-01DBL     PIC 9(04).
           05  CREAL-01DBL      PIC 9(10).
      *CUSTO REAL
           05  CMEDIO-01DBL     PIC 9(10).
      *CUSTO MEDIO.
           05  PRATAC-01DBL     PIC 9(10).
      *PRECO DE VENDA NO ATACADO
           05  PRVAR-01DBL      PIC 9(10).
      *PRECO DE VENDA NO VAREJO
           05  VRPU-01DBL       PIC 9(10).
           05  CATUAL-01DBL     PIC 9(10).
      *CUSTO ATUAL
           05  EMB-01DBL        PIC 999.
           05  ARTIGO-01DBL     PIC 9(06).
           05  DTCON-01DBL      PIC 9(06).
      * DATA DA CONTAGEM DE ESTOQUE.
           05  RAZ-01DBL      PIC X(01).
      *S SAI NO RAZAO
           05  FILLER        PIC X(03).
           05  CODLUZA-01DBL    PIC X(05).
           05  CONFPR-01DBL     PIC X(01).
           05  CONFCUS-01DBL    PIC X(01).
           05  CODTRI-01DBL     PIC 9.
           05  DATINF-01DBL     PIC 9(04).
      *QUANTIDADE ACUMULADA DE ENTREGAS NOMES
           03  QTSAIDAR-01DBL OCCURS 12 TIMES.
              05 QTSAI-01DBL   PIC 9(05).

      *DATA DO ULTIMO INFLACIONAMENTO DO CUSTO REAL
      *======================================
