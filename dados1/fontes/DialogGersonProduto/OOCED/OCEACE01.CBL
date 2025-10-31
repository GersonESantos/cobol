       Identification Division.
       Class-Id. OCEACE01
                 Data is protected
                 inherits from Base with data.
 
      ********************** Metodos de Classe ************************
 
       Class-Object.
       Object-Storage Section.
 
       End Class-object.
 
      ********************** Metodos de Instancia *********************
 
       Object.
       Environment Division.
       input-output section.
       file-control.
       COPY "\dados1\book\SELC-01".
 
       data division.
       file section.

       COPY "\dados1\book\FD-01".
 
 
       working-storage section.
       01  FS                      pic xx.
 
       object-storage section.
 
       Method-id. abrir.
       Data Division.
       linkage Section.
       01  status-ls      pic x(02).
       Procedure Division returning status-ls.
           open i-o ACE01
           move FS to status-ls.
       End Method abrir.
 
       Method-id. fechar.
       Data Division.
       linkage Section.
       01  status-ls      pic x(02).
       Procedure Division returning status-ls.
           close ACE01
           move FS to status-ls.
       End Method fechar.
 
       Method-Id. ler.
       Data Division.
       linkage Section.
       01  codigo-ls      pic 9(06).
       01  status-ls      pic x(02).
       Procedure Division using codigo-ls returning status-ls.
           initialize REG-01
           move codigo-ls to COD-01
           read ACE01
           move FS to status-ls.
       End Method ler.
      *
       Method-Id. ler-proximo.
       Data Division.
       linkage Section.
       01  cod-01-ls      pic 9(6).
       01  status-ls      pic x(02).
       Procedure Division using cod-01-ls returning status-ls.
           initialize REG-01
           move cod-01-ls to COD-01
           start ACE01 key greater COD-01
           if FS = "00"
              read ACE01 next.
           move FS to status-ls.
       End Method ler-proximo.
      *
       Method-Id. ler-anterior.
       Data Division.
       linkage Section.
       01  codigo-ls      pic x(04).
       01  status-ls      pic x(02).
       Procedure Division using codigo-ls returning status-ls.
           initialize REG-01
           move codigo-ls to COD-01
           start ACE01 key less COD-01
           if FS = "00"
              read ACE01 previous.
           move FS to status-ls.
       End Method ler-anterior.
      *
       Method-Id. gravar.
       Data Division.
       linkage Section.
       01  REG-01CPB.
           05 COD-01CPB         PIC 9(06).
      *CODIGO DO PRODUTO
           05  DESC-01CPB       PIC X(40).
           05  UND-01CPB        PIC X(04).
           05  LIVRO-01CPB      PIC X.
           05  CLASSECE-01CPB   PIC X.
      *CLASSE P\EMISSAO DE MAPA DE LOJA.
      *P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
      *B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
      *UNIDADE DE FORNECIMENTO
           05  ESTMIN-01CPB     PIC 9(07).
      *ESTOQUE MINIMO
           05  QTPED-01CPB      PIC 9(07).
      *QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
           05  QTENT-01CPB      PIC 9(07).
      *QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
           05  EST-01CPB        PIC 9(07).
      *ESTOQUE DA MERCADORIA NA EMPRESA
           05  DCUSTO-01CPB     PIC 9(06).
           05  CONDPG-01CPB     PIC 9(03).
      *PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
           05  DATCAD-01CPB     PIC 9(06).
      *DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
           05  DATNOV-01CPB     PIC 9(04).
      *MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
           05  CODTAB-01CPB     PIC X(01).
           05  CONTOU-01CPB     PIC X(01).
           05  CODFOR-01CPB     PIC 9(04).
           05  CREAL-01CPB      PIC 9(10).
      *CUSTO REAL
           05  CMEDIO-01CPB     PIC 9(10).
      *CUSTO MEDIO.
           05  PRATAC-01CPB     PIC 9(10).
      *PRECO DE VENDA NO ATACADO
           05  PRVAR-01CPB      PIC 9(10).
      *PRECO DE VENDA NO VAREJO
           05  VRPU-01CPB       PIC 9(10).
           05  CATUAL-01CPB     PIC 9(10).
      *CUSTO ATUAL
           05  EMB-01CPB        PIC 999.
           05  ARTIGO-01CPB     PIC 9(06).
           05  DTCON-01CPB      PIC 9(06).
      * DATA DA CONTAGEM DE ESTOQUE.
           05  RAZ-01CPB      PIC X(01).
      *S SAI NO RAZAO
           05  FILLER        PIC X(03).
           05  CODLUZA-01CPB    PIC X(05).
           05  CONFPR-01CPB     PIC X(01).
           05  CONFCUS-01CPB    PIC X(01).
           05  CODTRI-01CPB     PIC 9.
           05  DATINF-01CPB     PIC 9(04).
      *QUANTIDADE ACUMULADA DE ENTREGAS NOMES
           05  QTSAIDAR-01CPB OCCURS 12 TIMES.
              07 QTSAI-01CPB   PIC 9(05).
       Procedure Division using reg-01cpb.
           move reg-01cpb  to reg-01.
           write REG-01
       End Method gravar.
      *
       Method-Id. regravar.
       Data Division.
       linkage Section.
       01  REG-01CPB.
           05 COD-01CPB         PIC 9(06).
      *CODIGO DO PRODUTO
           05  DESC-01CPB       PIC X(40).
           05  UND-01CPB        PIC X(04).
           05  LIVRO-01CPB      PIC X.
           05  CLASSECE-01CPB   PIC X.
      *CLASSE P\EMISSAO DE MAPA DE LOJA.
      *P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
      *B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
      *UNIDADE DE FORNECIMENTO
           05  ESTMIN-01CPB     PIC 9(07).
      *ESTOQUE MINIMO
           05  QTPED-01CPB      PIC 9(07).
      *QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
           05  QTENT-01CPB      PIC 9(07).
      *QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
           05  EST-01CPB        PIC 9(07).
      *ESTOQUE DA MERCADORIA NA EMPRESA
           05  DCUSTO-01CPB     PIC 9(06).
           05  CONDPG-01CPB     PIC 9(03).
      *PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
           05  DATCAD-01CPB     PIC 9(06).
      *DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
           05  DATNOV-01CPB     PIC 9(04).
      *MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
           05  CODTAB-01CPB     PIC X(01).
           05  CONTOU-01CPB     PIC X(01).
           05  CODFOR-01CPB     PIC 9(04).
           05  CREAL-01CPB      PIC 9(10).
      *CUSTO REAL
           05  CMEDIO-01CPB     PIC 9(10).
      *CUSTO MEDIO.
           05  PRATAC-01CPB     PIC 9(10).
      *PRECO DE VENDA NO ATACADO
           05  PRVAR-01CPB      PIC 9(10).
      *PRECO DE VENDA NO VAREJO
           05  VRPU-01CPB       PIC 9(10).
           05  CATUAL-01CPB     PIC 9(10).
      *CUSTO ATUAL
           05  EMB-01CPB        PIC 999.
           05  ARTIGO-01CPB     PIC 9(06).
           05  DTCON-01CPB      PIC 9(06).
      * DATA DA CONTAGEM DE ESTOQUE.
           05  RAZ-01CPB      PIC X(01).
      *S SAI NO RAZAO
           05  FILLER        PIC X(03).
           05  CODLUZA-01CPB    PIC X(05).
           05  CONFPR-01CPB     PIC X(01).
           05  CONFCUS-01CPB    PIC X(01).
           05  CODTRI-01CPB     PIC 9.
           05  DATINF-01CPB     PIC 9(04).
      *QUANTIDADE ACUMULADA DE ENTREGAS NOMES
           05  QTSAIDAR-01CPB OCCURS 12 TIMES.
              07 QTSAI-01CPB   PIC 9(05).

       01  status-lss      pic x(02).
       Procedure Division using reg-01cpb returning status-lss.
           move reg-01cpb  to reg-01.
           initialize status-lss
           rewrite REG-01
           move FS to status-lss.
       End Method regravar.
      *
       Method-Id. excluir.
       Data Division.
       linkage Section.
       Procedure Division.
      *using codigo-ls returning status-ls.
           delete ACE01.
      *    move FS to status-ls.
       End Method excluir.
 
       Method-id. retornaDados.
       Data Division.
       linkage Section.
       01  REG-01CPB.
           05 COD-01CPB         PIC 9(06).
      *CODIGO DO PRODUTO
           05  DESC-01CPB       PIC X(40).
           05  UND-01CPB        PIC X(04).
           05  LIVRO-01CPB      PIC X.
           05  CLASSECE-01CPB   PIC X.
      *CLASSE P\EMISSAO DE MAPA DE LOJA.
      *P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
      *B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
      *UNIDADE DE FORNECIMENTO
           05  ESTMIN-01CPB     PIC 9(07).
      *ESTOQUE MINIMO
           05  QTPED-01CPB      PIC 9(07).
      *QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
           05  QTENT-01CPB      PIC 9(07).
      *QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
           05  EST-01CPB        PIC 9(07).
      *ESTOQUE DA MERCADORIA NA EMPRESA
           05  DCUSTO-01CPB     PIC 9(06).
           05  CONDPG-01CPB     PIC 9(03).
      *PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
           05  DATCAD-01CPB     PIC 9(06).
      *DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
           05  DATNOV-01CPB     PIC 9(04).
      *MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
           05  CODTAB-01CPB     PIC X(01).
           05  CONTOU-01CPB     PIC X(01).
           05  CODFOR-01CPB     PIC 9(04).
           05  CREAL-01CPB      PIC 9(10).
      *CUSTO REAL
           05  CMEDIO-01CPB     PIC 9(10).
      *CUSTO MEDIO.
           05  PRATAC-01CPB     PIC 9(10).
      *PRECO DE VENDA NO ATACADO
           05  PRVAR-01CPB      PIC 9(10).
      *PRECO DE VENDA NO VAREJO
           05  VRPU-01CPB       PIC 9(10).
           05  CATUAL-01CPB     PIC 9(10).
      *CUSTO ATUAL
           05  EMB-01CPB        PIC 999.
           05  ARTIGO-01CPB     PIC 9(06).
           05  DTCON-01CPB      PIC 9(06).
      * DATA DA CONTAGEM DE ESTOQUE.
           05  RAZ-01CPB      PIC X(01).
      *S SAI NO RAZAO
           05  FILLER        PIC X(03).
           05  CODLUZA-01CPB    PIC X(05).
           05  CONFPR-01CPB     PIC X(01).
           05  CONFCUS-01CPB    PIC X(01).
           05  CODTRI-01CPB     PIC 9.
           05  DATINF-01CPB     PIC 9(04).
      *QUANTIDADE ACUMULADA DE ENTREGAS NOMES
           05  QTSAIDAR-01CPB OCCURS 12 TIMES.
              07 QTSAI-01CPB   PIC 9(05).

       procedure division returning reg-01cpb.
           move REG-01 to reg-01cpb.
       End Method retornaDados.
      *
       Method-id. moved.
       Data Division.
       linkage Section.

       01  REG-01CPB.
           05 COD-01CPB         PIC 9(06).
      *CODIGO DO PRODUTO
           05  DESC-01CPB       PIC X(40).
           05  UND-01CPB        PIC X(04).
           05  LIVRO-01CPB      PIC X.
           05  CLASSECE-01CPB   PIC X.
      *CLASSE P\EMISSAO DE MAPA DE LOJA.
      *P=MATERIA PRIMA - L=MATERIAL LIMPESA - R=REFEICOES E LANCHES
      *B=BRINDES E INDENIZACAO-M=MATERIAL DE CONSUMO-V=MANUT.VEICULO
      *UNIDADE DE FORNECIMENTO
           05  ESTMIN-01CPB     PIC 9(07).
      *ESTOQUE MINIMO
           05  QTPED-01CPB      PIC 9(07).
      *QUANTIDADE ACUMULADA DOS PEDIDOS NAO ENTREGUES
           05  QTENT-01CPB      PIC 9(07).
      *QUANTIDADE DE SAIDAS PARA OS ULTIMOS 12 MESES
           05  EST-01CPB        PIC 9(07).
      *ESTOQUE DA MERCADORIA NA EMPRESA
           05  DCUSTO-01CPB     PIC 9(06).
           05  CONDPG-01CPB     PIC 9(03).
      *PRAZO DE PAGAMENTO DE MERCADORIA EM DIAS
           05  DATCAD-01CPB     PIC 9(06).
      *DATA DE CADASTRAMENTO E REMARCACAO DO PRODUTO
           05  DATNOV-01CPB     PIC 9(04).
      *MES E ANO DO ULTIMO MOVIMENTO DE MERCADORIA
           05  CODTAB-01CPB     PIC X(01).
           05  CONTOU-01CPB     PIC X(01).
           05  CODFOR-01CPB     PIC 9(04).
           05  CREAL-01CPB      PIC 9(10).
      *CUSTO REAL
           05  CMEDIO-01CPB     PIC 9(10).
      *CUSTO MEDIO.
           05  PRATAC-01CPB     PIC 9(10).
      *PRECO DE VENDA NO ATACADO
           05  PRVAR-01CPB      PIC 9(10).
      *PRECO DE VENDA NO VAREJO
           05  VRPU-01CPB       PIC 9(10).
           05  CATUAL-01CPB     PIC 9(10).
      *CUSTO ATUAL
           05  EMB-01CPB        PIC 999.
           05  ARTIGO-01CPB     PIC 9(06).
           05  DTCON-01CPB      PIC 9(06).
      * DATA DA CONTAGEM DE ESTOQUE.
           05  RAZ-01CPB      PIC X(01).
      *S SAI NO RAZAO
           05  FILLER        PIC X(03).
           05  CODLUZA-01CPB    PIC X(05).
           05  CONFPR-01CPB     PIC X(01).
           05  CONFCUS-01CPB    PIC X(01).
           05  CODTRI-01CPB     PIC 9.
           05  DATINF-01CPB     PIC 9(04).
      *QUANTIDADE ACUMULADA DE ENTREGAS NOMES
           05  QTSAIDAR-01CPB OCCURS 12 TIMES.
              07 QTSAI-01CPB   PIC 9(05).
       procedure division using reg-01cpb.
           move reg-01cpb to reg-01.
       End Method moved.
      *
       End Object.
       End Class OCEACE01.
 
