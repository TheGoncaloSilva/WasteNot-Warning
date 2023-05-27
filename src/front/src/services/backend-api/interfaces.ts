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