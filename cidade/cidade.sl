           select  Arquivo-Cidade
                  assign to LS-nome-base
                  organization is indexed
                  access mode  is dynamic
                  lock mode    is automatic with lock on record
                  record key   is Cid-Codigo
                  alternate record key is Cidade with duplicates
                  file status  is File-Status.
