import pyodbc
import time
import json


config = {
    'Driver': '{ODBC Driver 17 for SQL Server}',
    'Server': '172.16.0.4,1433',  # Specify the SQL Server instance and port
    'Database': 'WasteNot_Warning',
    'UID': 'sa',
    'PWD': 'StrongP@ssw0rd123'
}


class DatabaseInteraction:
    
    
    query_mapping = {
        "get_users": {"query": "SELECT * FROM UTILIZADOR", "returns_table" : True},
        "add_user": {"query" : """
                    INSERT INTO UTILIZADOR (DataNascimento, NivelPermissao_Nivel, Nome, Password, Telefone)
                    VALUES (?, ?, ?, ?, ?)
                    """, "returns_table" : False
                    },
        
        "remove_user": {"query": "DELETE FROM UTILIZADOR WHERE Id = ?", "returns_table": False},
        "get_events": {"query": "SELECT * FROM REGISTO_EVENTOS", "returns_table" : True},
    }
    
    
    
    def __init__(self):
        self.cursor = None
        try:
            conn = self.establish_connection_with_retry()
            self.cursor = conn.cursor()
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            raise(e)

    def establish_connection_with_retry(self):
        max_retries = 2  # Maximum number of retries
        retry_interval = 5  # Interval between retries (in seconds)

        for attempt in range(1, max_retries + 1):
            try:
                # Attempt to establish the connection
                conn = pyodbc.connect(**config)
                print("Connection established")
                return conn
            except pyodbc.Error as err:
                print(f"Error: {str(err)}")
                print(f"Connection attempt {attempt} failed. Retrying in {retry_interval} seconds...")
                time.sleep(retry_interval)

        # Maximum retries exceeded, raise an exception
        raise Exception("Unable to establish a connection with the SQL Server.")

    def __execute_query(self, query_name, *args):
        if query_name not in DatabaseInteraction.query_mapping:
            raise ValueError(f"Unknown query: {query_name}")

        info = DatabaseInteraction.query_mapping[query_name]
        cursor = self.cursor.execute(info["query"], args)
        
        if info["returns_table"]:
            columns = [column[0] for column in cursor.description]
            results = []
            for row in cursor.fetchall():
                results.append(dict(zip(columns, row)))
            return results
        
    def get_users(self):
        return self.__execute_query("get_users")
    
    def add_user(self, DataNascimento, NivelPermissao_Nivel, Nome, Password, Telefone):
        self.__execute_query("add_user", DataNascimento,NivelPermissao_Nivel,Nome,Password,Telefone)
        
    def remove_user(self, user_id):
        self.__execute_query("remove_user",user_id)

    def get_events(self):
        return self.__execute_query("get_users")
    
    
    