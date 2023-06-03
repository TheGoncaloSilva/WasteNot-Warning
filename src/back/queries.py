import pyodbc
import time
import json
import subprocess
from threading import Lock
critical_function_lock = Lock()
import config
import sys


config = config.getConfig()


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
        
        "get_restricted_areas" : {"query" : "SELECT * FROM AREA_RESTRITA" , "returns_table" : True},
        
        "get_last_repairs_of_a_restricted_area" : {"query" : "SELECT * FROM GetLastRepairsOfARestrictedArea(?,?)", "returns_table" : True},
        
        "get_device_list_of_a_restricted_area" : {"query" : "SELECT * FROM GetDeviceListOfARestrictedArea(?)", "returns_table" : True},
        
        "get_horarios_monitorizacao_by_restricted_area" : {"query" : "SELECT * FROM GetHorariosMonitorizacaoByRestrictedArea(?)", "returns_table" : True},

        "get_number_of_events" : {"query" : "SELECT COUNT(*) AS row_count FROM list_ordered_events;", "returns_table" : True},
        "get_number_of_areas" : {"query" : "SELECT COUNT(*) AS row_count FROM AREA_RESTRITA;", "returns_table" : True},
        "get_number_of_devices" : {"query" : "SELECT COUNT(*) AS row_count FROM DISPOSITIVO;", "returns_table" : True},

        "list_events" : {"query" : "SELECT * FROM list_ordered_events ORDER BY Reg_timestamp DESC;", "returns_table" : True},
        
        "unused_devices" : {"query" : """ 
                            
                            SELECT *
                            FROM DISPOSITIVO_SEGURANCA
                            WHERE AreaRestrita_Id IS NULL;
                            
                            """, "returns_table" : True},
        
        
        "restricted_area_add_device" : {"query" : """
                                        UPDATE DISPOSITIVO_SEGURANCA
                                        SET AreaRestrita_Id = ?
                                        WHERE Dispositivo_Mac = ?;
                                        """, "returns_table" : False},
        "trigger_alarm" : {"query" : "EXEC getAlarmActivated;", "returns_table" : True},
        "get_events_paginated" : {"query" : "SELECT * FROM PaginatedEvents(?,?,?)", "returns_table" : True},
    }
    
    
    
    def __init__(self, reset_db: bool = False):
        if reset_db:
            self.__reset()
            
        self.cursor = None
        self.conn = None
        try:
            self.conn = self.establish_connection_with_retry()

            #self.conn = conn
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            raise(e)
        
            
    def __reset(self):
        self.__run_sql_from_source('/database/reset.sql')
        self.__run_sql_from_source('/database/WasteNotWarning_db.sql')
        self.__run_sql_from_source('/database/stored_procedures.sql')
        self.__run_sql_from_source('/database/views.sql')
        self.__run_sql_from_source('/database/udfs.sql')
        self.__run_sql_from_source('/database/triggers.sql')
        self.__run_sql_from_source('/database/populate.sql')

        
    def __run_sql_from_source(self, file_src):
        
        try:

            with open(file_src, 'r') as file:
                sql_script = file.read()

            cmd = [
                "/opt/mssql-tools/bin/sqlcmd",
                "-S", config["Server"],
                "-U", config["UID"],
                "-P", config["PWD"],
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
        with critical_function_lock:
            if query_name not in DatabaseInteraction.query_mapping:
                raise ValueError(f"Unknown query: {query_name}")
            
            info = DatabaseInteraction.query_mapping[query_name]
            #self.cursor = self.conn.cursor() 
            cursor = self.conn.cursor()
            cursor = cursor.execute(info["query"], args)

            if info["returns_table"]:
                columns = [column[0] for column in cursor.description]
                results = []
                for row in cursor.fetchall():
                    results.append(dict(zip(columns, row)))
                cursor.close()
                return results
            cursor.close()
        
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
    
    def get_last_repairs_of_a_restricted_area(self, restrictedArea, count):
        return self.__execute_query("get_last_repairs_of_a_restricted_area", restrictedArea, count)
    
    def get_device_list_of_a_restricted_area(self, restrictedArea):
        return self.__execute_query("get_device_list_of_a_restricted_area", restrictedArea)
    
    def get_horarios_monitorizacao_by_restricted_area(self, restrictedArea):
        return self.__execute_query("get_horarios_monitorizacao_by_restricted_area", restrictedArea)
    
    def get_number_of_events(self):
        return self.__execute_query("get_number_of_events")
    
    def get_number_of_areas(self):
        return self.__execute_query("get_number_of_areas")
    
    def get_number_of_devices(self):
        return self.__execute_query("get_number_of_devices")
    
    def get_restricted_areas(self):
        return self.__execute_query("get_restricted_areas")
    
    def list_events(self):
        return self.__execute_query("list_events")
    
    def get_unused_devices(self):
        return self.__execute_query("unused_devices")
    
    def get_trigger_alarm(self):
        return self.__execute_query("trigger_alarm")
    
    def get_paginated_events(self, offset: int, fetch: int, type: str):
        var = self.__execute_query("get_events_paginated", offset , fetch, type)
        return var
    
    def restricted_area_add_device(self, mac: str,area_id: int):
        self.__execute_query("restricted_area_add_device", area_id , mac)
    
    