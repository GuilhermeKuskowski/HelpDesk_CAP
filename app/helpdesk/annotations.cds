using ServiceDesk as service from '../../srv/service';

annotate service.Incidentes with @(
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: titulo,
                Label: 'Título',
            },
            {
                $Type: 'UI.DataField',
                Value: cliente_ID,
                Label: 'Cliente',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Status',
                Value: status_codigo,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Urgência',
                Value: urgencia_codigo,
            },
            {
                $Type: 'UI.DataField',
                Value: createdAt,
                Label: 'Data de Abertura',
            },
            {
                $Type: 'UI.DataField',
                Value: categoria_ID,
                Label: 'Categoria',
            },
            {
                $Type      : 'UI.DataField',
                Label      : 'SLA',
                Value      : slaStatus,
                Criticality: slaCriticidade,
            }
        ],
    },
    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'Informações Gerais',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Descrição',
            ID    : 'Descrio',
            Target: '@UI.FieldGroup#Descrio',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Resolução',
            ID    : 'Resoluo',
            Target: '@UI.FieldGroup#Resoluo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Conversas',
            ID    : 'Conversa',
            Target: 'conversas/@UI.LineItem#Conversa',
        },
    ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Label: 'Título',
            Value: titulo,
        },
        {
            $Type: 'UI.DataField',
            Value: cliente.nome,
            Label: 'Cliente',
        },
        {
            $Type: 'UI.DataField',
            Value: categoria.nome,
            Label: 'Categoria',
        },
        {
            $Type                    : 'UI.DataField',
            Label                    : 'Urgência',
            Value                    : urgencia_codigo,
            Criticality              : urgencia.criticidade,
            CriticalityRepresentation: #WithoutIcon,
        },
        {
            $Type      : 'UI.DataField',
            Label      : 'Status',
            Value      : status_codigo,
            Criticality: status.criticidade,
        },
        {
            $Type      : 'UI.DataField',
            Label      : 'SLA',
            Value      : slaStatus,
            Criticality: slaCriticidade,
        }
    ],
    UI.HeaderInfo                : {
        Title         : {
            $Type: 'UI.DataField',
            Value: titulo,
        },
        TypeName      : '',
        TypeNamePlural: '',
    },
    UI.FieldGroup #Descrio       : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: descricao,
            Label: 'Descrição',
        }, ],
    },
    UI.FieldGroup #Resoluo       : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: descricaoResolucao,
                Label: 'Resolução',
            },
            {
                $Type: 'UI.DataField',
                Value: dataFechamento,
                Label: 'Data de Fechamento',
            },
            {
                $Type : 'UI.DataField',
                Value : tempoResolucao,
                Label : 'Tempo de Resolução',
            },
        ],
    },
    UI.FieldGroup #Conversas     : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: conversas.mensagem,
                Label: 'Mensagem',
            },
            {
                $Type: 'UI.DataField',
                Value: conversas.createdAt,
                Label: 'Data',
            },
            {
                $Type: 'UI.DataField',
                Value: conversas.cliente_ID,
                Label: 'Autor',
            },
        ],
    },
    UI.Identification            : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'ServiceDesk.fecharIncidente',
            Label : 'Fechar Incidente',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'ServiceDesk.reabrirIncidente',
            Label : 'Reabrir Incidente',
        },
    ],
);

annotate service.Incidentes with {
    cliente @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Clientes',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: cliente_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'nome',
                },

            ],

        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : cliente.nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};

annotate service.Incidentes with {
    status @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Status',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: status_codigo,
                    ValueListProperty: 'codigo',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'nome',
                },
            ],
        },
        Common.Text                    : status.nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
    )
};

annotate service.Incidentes with {
    urgencia @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Urgencia',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: urgencia_codigo,
                    ValueListProperty: 'codigo',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'nome',
                },
            ],
        },
        Common.Text                    : urgencia.nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
    )
};

annotate service.Incidentes with {
    categoria @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Categoria',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: categoria_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'nome',
                },
            ],
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : categoria.nome,
        Common.Text.@UI.TextArrangement: #TextOnly
    )
};

annotate service.Conversas with {
    cliente @(
        Common.Text                    : cliente.nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Clientes',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : cliente_ID,
                    ValueListProperty : 'ID',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Conversas with @(UI.LineItem #Conversa: [
    {
        $Type: 'UI.DataField',
        Value: incidente.conversas.mensagem,
        Label: 'Mensagem',
    },
    {
        $Type: 'UI.DataField',
        Value: incidente.conversas.cliente_ID,
        Label: 'Autor',
    },
    {
        $Type: 'UI.DataField',
        Value: incidente.conversas.createdAt,
        Label: 'Data',
    },
]);


annotate service.Clientes with {
    ID @(
        Common.Text                    : nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};

annotate service.Urgencia with {
    codigo @(
        Common.Text                    : nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};

annotate service.Status with {
    codigo @(
        Common.Text                    : nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};

annotate service.Categoria with {
    ID @(
        Common.Text                    : nome,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};
