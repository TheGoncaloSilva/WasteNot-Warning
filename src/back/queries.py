import pyodbc
import time

config = {
    'Driver': '{ODBC Driver 17 for SQL Server}',
    'Server': '172.16.0.4,1433',  # Specify the SQL Server instance and port
    'Database': 'WasteNot_Warning',
    'UID': 'sa',
    'PWD': 'StrongP@ssw0rd123'
}


class DatabaseInteraction:
    def __init__(self):
        print(pyodbc.drivers())
        self.cursor = None
        try:
            conn = self.establish_connection_with_retry()
            self.cursor = conn.cursor()
        except Exception as e:
            print(f"An error occurred: {str(e)}")

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

    def get_users(self):
        if self.cursor:
            self.cursor.execute("SELECT * FROM UTILIZADOR")
            return self.cursor.fetchall()