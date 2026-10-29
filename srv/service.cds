using {db} from '../db/schema';

service ServiceDesk {
    @odata.draft.enabled
    entity Incidentes as projection on db.Incidente
        actions {
            @Common.SideEffects: {
                TargetProperties: [
                    'status_codigo',
                    'dataFechamento'
                ],
                TargetEntities  : ['conversas']
            } action  fecharIncidente();
            @Common.SideEffects: {TargetProperties: [
                'status_codigo',
                'dataFechamento'
            ],
            TargetEntities : ['conversas']
            } action reabrirIncidente();
        };

    entity Clientes   as projection on db.Cliente;
    entity Conversas  as projection on db.Conversa;

    @readonly
    entity Status     as projection on db.Status;

    @readonly
    entity Urgencia   as projection on db.Urgencia;

    @readonly
    entity Categoria  as projection on db.Categoria;
}
