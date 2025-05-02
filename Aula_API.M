let
    #"Requisição" =
    (numeroPagina) => 
        Json.Document(
                     Web.Contents("http://localhost:8080",
                     [
                         RelativePath = "/medicos",
                         Query = [
                             page = Number.ToText(numeroPagina)
                     ]
                     ]
                     )
    )[content],

    #"Total Paginas" = 
                 Json.Document(
                        Web.Contents("http://localhost:8080",
                     [
                          RelativePath = "/medicos",
                          Query = [
                          page = "1"
                    ]
            ])
          )[totalPages],

 #"Lista Paginas" = {0 .. #"Total Paginas"-1},

 #"Lista Dados" = List.Transform(
                  #"Lista Paginas",
                  each {_, #"Requisição"(_)}
                ),
#"Tabela" =
        Table.ExpandRecordColumn(
           Table.ExpandListColumn(
               #table(
                   type table
                   [Pagina=text, Dados=list],
                   #"Lista Dados"
               ),
               "Dados"
           ),
           "Dados",
           {"id","nome", "email","crm","especialidade"},
           {"Id","Nome", "Email","CRM","Especialidade"}
           
        )
in
    #"Tabela"