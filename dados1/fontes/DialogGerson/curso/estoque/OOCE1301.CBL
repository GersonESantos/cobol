       Identification Division.
       Class-Id. OCE1201
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
       01  codigo-ls      pic x(04).
       01  status-ls      pic x(02).
       Procedure Division using codigo-ls returning status-ls.
           move codigo-ls  to COD-01
           write REG-01
           move FS to status-ls.
       End Method gravar.
      *
       Method-Id. regravar.
       Data Division.
       linkage Section.
       01  codigo-ls      pic x(04).
       01  status-ls      pic x(02).
       Procedure Division using codigo-ls returning status-ls.
           move codigo-ls  to COD-01
           rewrite REG-01
           move FS to status-ls.
       End Method regravar.
      *
       Method-Id. excluir.
       Data Division.
       linkage Section.
       01 codigo-ls       pic x(04).
       01 status-ls       pic x(02).
       Procedure Division using codigo-ls returning status-ls.
           move codigo-ls   to COD-01
           delete ACE01.
           move FS to status-ls.
       End Method excluir.
 
       Method-id. retornaDados.
       Data Division.
       linkage Section.
       01  reg-cli-ls.
           03 codigo-cli-ls          pic x(04).
           03 nome-cli-ls            pic x(30).
           03 endereco-cli-ls        pic x(40).
           03 saldo-cli-ls           pic s9(07)v99 comp-3.
           03 observacao-cli-ls      pic x(50).
       procedure division returning reg-cli-ls.
           move REG-01 to reg-cli-ls.
       End Method retornaDados.
      *
       Method-id. moveDados.
       Data Division.
       linkage Section.
       01  reg-cli-ls.
           03 codigo-cli-ls          pic x(04).
           03 nome-cli-ls            pic x(30).
           03 endereco-cli-ls        pic x(40).
           03 saldo-cli-ls           pic s9(07)v99 comp-3.
           03 observacao-cli-ls      pic x(50).
       procedure division using reg-cli-ls.
           move reg-cli-ls to reg-01.
       End Method moveDados.
      *
       End Object.
       End Class OCE1201.
 
