export interface UTILIZADOR {
    DataNascimento: Date;
    Id: number;
    NivelPermissao_Nivel: string;
    Nome: string;
    Password: string;
    Telefone: number;
};

export interface AREA_RESTRITA
{
    Id: number,
    DESCRICAO: string;
    LOCALIZACAO: string;
};

export interface LAST_USER_EVENTS {
    Id: number;
    Timestamp: Date;
    TipoEvento_Descricao: string;
    Mac: string;
    Modelo: string;
    Fabricante: string;
};

export interface EVENTS_COUNT_BY_CATEGORY {
    TipoEvento_Descricao: string;
    neventos: number;
}

export interface NUMBER_STATS {
    row_count: number;
}

export interface NEXT_MAINTENANCE {
    Man_id: number;
    Man_inicio: string;
    Man_fim: string;
    Man_comentario: string;
    Man_estado: string;
    AR_id: number;
    AR_descricao: string;
    AR_localizacao: string;
}

export interface LAST_REPAIRS
{
    DataInicio: Date;
    DataFim: Date;
    Comentatio: string;
    EstadoManutencao_Descricao: string;
    AreaRestrita_Id: number;
}

export interface SECURITY_DEVICE
{
    Dispositivo_Mac: string;
    TipoDispositivoSeguranca_Descricao: string;
}

export interface HORARIO_MONITORIZACAO {
    HoraInicio: Date;
    HoraFim: Date;
    Estado: string;
}

export interface EVENT_LIST {
    Reg_id: number;
    Reg_tipo: string;
    Reg_timestamp: string;
    Disp_mac: string;
    Disp_tipo: string;
    AR_descricao: string;
    AR_localizacao: string;
}