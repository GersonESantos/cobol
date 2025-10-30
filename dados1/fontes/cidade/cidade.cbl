       $set ans85 comp
        identification division.
        program-id.cidade.
       environment division.
       input-output section.
       file-control.
      * File select entries here
           select  Arquivo-Cidade
                  assign to "arquivos\cidade.dat"
                  organization is indexed
                  access mode  is dynamic
                  lock mode    is automatic with lock on record
                  record key   is Cid-Codigo
                  alternate record key is Cidade with duplicates
                  file status  is File-Status.

       data division.
       file section.
      *File FD's here
       FD Arquivo-Cidade.
       01 Registro-Cidade.
         02 Cid-Codigo         Pic 9(05).
         02 Cidade             Pic x(30).
         02 DDD-Cidade         Pic 9(04).
         02 Cid-Cod-Municipio  Pic 9(07).
         02 Cid-Estado         Pic x(02).
         02 FILLER             Pic x(08).

       working-storage section.
       copy "DS-CNTRL.MF".
       copy "Cidade.CPB".
       copy "DSSYSINF.CPY".

       77 File-status              pic x(2).
       77 indice                   pic 9(05).
       78 Dialog-system            value "DSGRUN".
      * Nome do programa - conferido se já está ativo na memória
       01 Este-programa            PIC X(8) VALUE "CIDADE".
      * Flags especificos para este programa
       01 Flag-programa            PIC 9(2) COMP-5 VALUE 1.
          88 Nova-carga            VALUE 1 FALSE 0.

       *> Lista de Funções
       78 Funcao-Sair               value "Q".
       78 Funcao-Alterar            value "A".
       78 Funcao-consultar          value "C".
       78 Funcao-excluir            value "E".
       78 Funcao-incluir            value "I".
       78 Funcao-imprimir           value "R".
       78 Funcao-listar             value "L".
       78 Funcao-primeiro-registro  value "PR".
       78 Funcao-registro-anterior  value "RA".
       78 Funcao-registro-posterior value "RP".
       78 Funcao-ultimo-registro    value "UR".

       procedure division.
       SecaoPrincipal section.
      * Na primeira chamada do programa, carrega a GS como "new screenset"
           perform CarregarGS
           perform ChamarTela until Tl-funcao equal Funcao-Sair
           stop run
           .
       CarregarGS section.
      *Certifica que a GS não será criada novamente após esta carga
           set Nova-carga to false
      *Inicialização padrão dos parâmetros da GS
           initialize Data-block
           initialize DS-control-block
           move Data-block-version-no to DS-DATA-BLOCK-VERSION-NO
           move Version-no to DS-VERSION-NO
           move Este-programa to DS-SET-NAME
           move 3 to DS-PARAMETER-COUNT
      *Indica o código de carga de nova GS
          MOVE Ds-New-Set TO Ds-Control
           .
       UsarGSCarregada section.
      *Indica o código de utilização de GS já carregada
           move DS-USE-SET to DS-CONTROL
      *Indica o nome da GS a ser trabalhada
           move Este-programa to DS-SET-NAME
           .
       EscolherMetodo section.
      *    perform VerificarPermissoesManutencao
           evaluate Tl-funcao
               when Funcao-Alterar
                    perform Alterar
               when Funcao-consultar
                    perform Consultar
               when Funcao-excluir
                    perform Excluir
               when Funcao-incluir
                    perform Incluir
               when Funcao-listar
                    perform Listar
               when Funcao-primeiro-registro
                    perform PosicionarPrimeiro
               when Funcao-registro-anterior
                    perform PosicionarAnterior
               when Funcao-registro-posterior
                    perform PosicionarPosterior
               when Funcao-ultimo-registro
                    perform PosicionarUltimo
           end-evaluate
           .
       Alterar section.
           move zeros to Tl-Resposta
           perform AbrirArquivoCidadeIO
           move Tl-cid-Codigo to cid-Codigo
           read Arquivo-cidade
           if File-Status not equal "00" and "02"
              move "Registro Inválido" to TL-Mensagem
              move "Mensagem-Erro"     to DS-Procedure
              perform MostrarMensagem
              move 1 to Tl-Resposta
           else
              perform PreencherArquivo
              rewrite Registro-cidade
              if  File-Status not equal "00" and "02"
                  move "Erro ao gravar o registro." to TL-Mensagem
                  move "Mensagem-Aviso" to DS-Procedure
                  perform MostrarMensagem
                  move 1 to Tl-Resposta
              end-if
           end-if
           perform FecharArquivoCidade
           .
       Consultar section.
           perform AbrirArquivoCidadeInput
           move Tl-cid-Codigo to Cid-Codigo
           read Arquivo-cidade
           if File-Status not equal "00" and "02"
              move "Registro Inválido" to TL-Mensagem
              move "Mensagem-Aviso" to DS-Procedure
              perform MostrarMensagem
           else
              perform PreencherTela
           end-if
           perform FecharArquivoCidade
           .
       Excluir section.
           perform AbrirArquivoCidadeIO
           move Tl-Cid-Codigo to Cid-Codigo
           delete Arquivo-Cidade
           if File-Status not equal "00"
              move "Registro Inválido" to TL-Mensagem
              move "Mensagem-Aviso" to DS-Procedure
              perform MostrarMensagem
              move 1 to tl-resposta
           end-if
           perform FecharArquivoCidade
           .
       Finalizar section.
           exit program
           .
       Incluir section.
           move zeros to Tl-Resposta
           perform AbrirArquivoCidadeIO
           move 99999 to Cid-Codigo
           start Arquivo-Cidade key is not greater Cid-Codigo
           if File-Status not equal "00" and "02"
              move zeros to Cid-Codigo
           else
              read Arquivo-cidade previous
              if File-Status not equal "00" and "02"
                  move "Erro ao ler o arquivo." to TL-Mensagem
                  move "Mensagem-Aviso" to DS-Procedure
                  perform MostrarMensagem
              end-if
           end-if
           perform PreencherArquivo
           add 1 to Cid-Codigo
           move Cid-Codigo to TL-Cid-Codigo
           write Registro-Cidade
           if File-Status not equal "00" and "02"
              move "Erro ao gravar o registro." to TL-Mensagem
              move "Mensagem-Aviso" to DS-Procedure
              perform MostrarMensagem
              move 1 to Tl-Resposta
           end-if
           perform FecharArquivoCidade
           .
       Listar section.
           initialize tl-ocorrencias indice tl-resposta
           perform AbrirArquivoCidadeInput
           move TL-cidade to cidade
           start Arquivo-Cidade key is not less cidade
           perform until exit
               read Arquivo-cidade next
               if (File-Status not equal "00" and "02")
                  or Indice equal 20
                  move Indice to TL-Ocorrencias
                  exit perform
               else
                  add 1 to indice
                  move cid-Codigo        to TL-LB-cid-Codigo(Indice)
                  move Cidade            to TL-LB-Cidade(Indice)
                  move DDD-cidade        to TL-LB-DDD-cidade(Indice)
                  move Cid-Estado        to Tl-LB-Estado(Indice)
                  move Cid-Cod-Municipio
                       to Tl-Lb-Cod-Municipio(Indice)
               end-if
           end-perform
           perform FecharArquivoCidade
           .
       PosicionarAnterior section.
           perform AbrirArquivoCidadeInput
           move TL-cidade to cidade
           start Arquivo-cidade key is less cidade
           if File-Status not equal "00" and "02"
              move "Início de Arquivo" to TL-Mensagem
              move "Mensagem-aviso"    to DS-Procedure
              perform MostrarMensagem
           else
              read Arquivo-Cidade previous
              if  File-Status not equal "00" and "02"
                  move "Erro ao ler o arquivo" to TL-Mensagem
                  move "Mensagem-aviso"        to DS-Procedure
                  perform MostrarMensagem
              end-if
           end-if
           move cidade to TL-cidade
           perform FecharArquivoCidade
           .
       PosicionarPosterior section.
           perform AbrirArquivoCidadeInput
           move TL-cidade to cidade
           start Arquivo-cidade key is greater cidade
           if File-Status not equal "00" and "02"
              move "Fim de Arquivo" to TL-Mensagem
              move "Mensagem-aviso" to DS-PROCEDURE
              perform MostrarMensagem
           else
              read Arquivo-cidade next
              if File-Status not equal "00" and "02"
                 move "Fim de Arquivo" to TL-Mensagem
                 move "Mensagem-aviso" to DS-PROCEDURE
                 perform MostrarMensagem
              else
                 perform PreencherTela
              end-if
           end-if
           perform FecharArquivoCidade
           .
       PosicionarPrimeiro section.
           perform AbrirArquivoCidadeInput
           move spaces to Cidade
           start Arquivo-cidade key is not less Cidade
           if File-Status not equal "00" and "02"
              move "Não há registros" to TL-Mensagem
              move "Mensagem-Aviso" to DS-PROCEDURE
              perform MostrarMensagem
           else
              read Arquivo-cidade next
              if File-Status not equal "00" and "02"
                 move "Não há registros" to TL-Mensagem
                 move "Mensagem-Aviso" to DS-PROCEDURE
                 perform MostrarMensagem
              else
                 perform PreencherTela
              end-if
           end-if
           perform FecharArquivoCidade
           .
       PosicionarUltimo section.
           perform AbrirArquivoCidadeInput
           move high-value to cidade
           start Arquivo-cidade key is not greater Cidade
           if File-Status not equal "00" and "02"
              move "Não há registros" to TL-Mensagem
              move "Mensagem-Aviso" to DS-PROCEDURE
              perform MostrarMensagem
           else
              read Arquivo-cidade previous
              if File-Status not equal "00" and "02"
                 initialize Registro-cidade
              else
                 perform PreencherTela
              end-if
           end-if
           perform FecharArquivoCidade
           .
       PreencherArquivo section.
           move TL-cidade        to cidade
           move TL-DDD-cidade    to DDD-cidade
           move Tl-Cod-Municipio to Cid-Cod-Municipio
           move Tl-Estado        to Cid-Estado
           .
       PreencherTela section.
           move Cid-Codigo        to TL-cid-codigo
           move Cidade            to TL-cidade
           move DDD-cidade        to TL-DDD-cidade
           move Cid-Cod-Municipio to Tl-Cod-Municipio
           move Cid-Estado        to Tl-Estado
           .
       ChamarTela section.
      * Chamadas ao Dialog System
      * Inicialização e chamada padrão do Dialog System
           initialize Tl-funcao
           call Dialog-system using DS-control-block
                                    Data-block
                                    DS-event-block
           if not DS-no-error
              move Funcao-sair to Tl-funcao
           end-if
           perform EscolherMetodo
           .
       MostrarMensagem section.
           call Dialog-system using DS-control-block
                                    Data-block
                                    DS-event-block
           if not DS-no-error
              move Funcao-sair to Tl-funcao
           end-if
           perform EscolherMetodo
           .
       AbrirArquivoCidadeInput section.
           open input Arquivo-Cidade
           if File-status not equal zeros
              move "Erro ao abrir o arquivo." to TL-Mensagem
              move "Mensagem-Aviso" to DS-PROCEDURE
              perform MostrarMensagem
           end-if
           .
       AbrirArquivoCidadeIO section.
           open i-o Arquivo-Cidade
           if  File-status not equal zeros
              move "Erro ao abrir o arquivo." to TL-Mensagem
              move "Mensagem-Aviso" to DS-PROCEDURE
              perform MostrarMensagem
           end-if
           .
       FecharArquivoCidade section.
           close Arquivo-Cidade
           if File-status not equal zeros
              move "Erro ao fechar o arquivo." to TL-Mensagem
              move "Mensagem-Aviso" to DS-PROCEDURE
              perform MostrarMensagem
           end-if
           .
