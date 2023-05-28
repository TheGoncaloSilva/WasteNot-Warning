import pyodbc
import time
import json
import subprocess

config = {
    'Driver': '{ODBC Driver 17 for SQL Server}',
    'Server': '172.16.0.4,1433',  # Specify the SQL Server instance and port
    'Database': 'WasteNot_Warning',
    'UID': 'sa',
    'PWD': 'StrongP@ssw0rd123'
}


class DatabaseInteraction:
    
    
    query_mapping = {
        "get_users": {"query": "SELECT Id,Nome,Telefone,DataNascimento,NivelPermissao_Nivel FROM UTILIZADOR", "returns_table" : True},
        "add_user": {"query" : """
                    INSERT INTO UTILIZADOR (DataNascimento, NivelPermissao_Nivel, Nome, PW_Hash, Salt, Telefone)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """, "returns_table" : False
                    },
        
        "remove_user": {"query": "DELETE FROM UTILIZADOR WHERE Id = ?", "returns_table": False},
        "get_events": {"query": "SELECT * FROM REGISTO_EVENTOS", "returns_table" : True},
        "get_user_last_events" : {"query" : "SELECT * FROM GetLastUserEvents(?,?)" , "returns_table" : True},
        "get_user_restricted_areas" : {"query" : "SELECT * FROM GetAreasRestritasByUserId(?)" , "returns_table" : True},
        "get_events_count_by_category" : {
            "query" : "SELECT * FROM events_count_by_category" , "returns_table" : True
        },
        "get_number_of_events_in_excluded_time": {"query": "EXEC GetRowCountOfEventsInExclusionTime", "returns_table" : True},
        "get_number_of_events_in_maintenance": {"query": "EXEC GetRowCountOfEventsInRepairingSchedule", "returns_table" : True},
        "get_number_of_events_in_active_schedule": {"query": "EXEC GetRowCountOfEventsInActiveSchedule", "returns_table" : True},
        
        "get_user" : {"query" : "SELECT * FROM UTILIZADOR WHERE Telefone = ?", "returns_table" : True},

        "get_next_maintenance": {"query": "SELECT * FROM next_repairs", "returns_table" : True},
    }
    
    
    
    def __init__(self, reset_db: bool = False):
        if reset_db:
            self.__reset()
            
        self.cursor = None
        try:
            conn = self.establish_connection_with_retry()
            self.cursor = conn.cursor()
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            raise(e)
        
            
    def __reset(self):
        self.__run_sql_from_source('/database/WasteNotWarning_db.sql')
        self.__run_sql_from_source('/database/populate.sql')
        self.__run_sql_from_source('/database/stored_procedures.sql')
        self.__run_sql_from_source('/database/udfs.sql')
        self.__run_sql_from_source('/database/views.sql')        

        
    def __run_sql_from_source(self, file_src):
        
        try:

            with open(file_src, 'r') as file:
                sql_script = file.read()

            cmd = [
                "/opt/mssql-tools/bin/sqlcmd",
                "-S", config["Server"],
                "-U", config["UID"],
                "-P", config["PWD"],
                "-d", config["Database"],
                "-i", file_src,
            ]
            
            subprocess.run(cmd,check=True)          
                
        except Exception as e:
            raise Exception("Error while running file source '" + file_src + "' -> "  + str(e))
        
            

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
    
    def add_user(self, DataNascimento, NivelPermissao_Nivel, Nome, PW_Hash, Salt, Telefone):
        self.__execute_query("add_user", DataNascimento,NivelPermissao_Nivel,Nome,PW_Hash,Salt,Telefone)
        
    def remove_user(self, user_id):
        self.__execute_query("remove_user",user_id)

    def get_events(self):
        return self.__execute_query("get_users")
        
    def get_user_last_events(self, userid, nevents):
        return self.__execute_query("get_user_last_events", userid, nevents)
        
    def get_user_restricted_areas(self, userid):
        return self.__execute_query("get_user_restricted_areas", userid)
    
    def get_events_count_by_category(self):
        return self.__execute_query("get_events_count_by_category")
    
    def get_number_of_events_in_excluded_time(self):
        return self.__execute_query("get_number_of_events_in_excluded_time")
    
    def get_number_of_events_in_maintenance(self):
        return self.__execute_query("get_number_of_events_in_maintenance")
    
    def get_number_of_events_in_active_schedule(self):
        return self.__execute_query("get_number_of_events_in_active_schedule")
    
    def get_next_maintenance(self):
        return self.__execute_query("get_next_maintenance")
    
    def get_user(self, telefone):
        return self.__execute_query("get_user" , telefone)
    
    