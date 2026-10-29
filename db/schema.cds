using {managed} from '@sap/cds/common';

namespace db;

entity Incidente : managed {
    key ID : UUID;
    titulo : String(150);
    descricao : LargeString;
    descricaoResolucao : LargeString;
    cliente : Association to Cliente;
    status : Association to Status;
    urgencia : Association to Urgencia;
    categoria : Association to Categoria;
    dataFechamento : Timestamp;
    conversas : Composition of many Conversa on conversas.incidente = $self;
    slaStatus : String(20);
    slaCriticidade: Integer;

}

entity Cliente : managed {
    key ID : UUID;
    nome : String(100);
    email : String(255);
    telefone : String(20);
    ativo : Boolean default true;
    incidentes : Association to many Incidente on incidentes.cliente = $self;
}

entity Status {
    key codigo : String(1);
    nome : String(30);
    criticidade : Integer;
}

entity Urgencia {
    key codigo : String(1);
    nome : String(20);
    criticidade : Integer;
}


entity Categoria {
    key ID : UUID;
    nome : String(50);
    descricao : String(255);
}

entity Conversa : managed {
    key ID : UUID;
    mensagem : LargeString;
    incidente : Association to Incidente;
    cliente : Association to Cliente;
}