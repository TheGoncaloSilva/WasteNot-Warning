import os
from dotenv import dotenv_values

def getConfig():

    prod_vars = None
    fname = 'dev.env'
    if os.environ.get('NODE_ENV') == 'prod':
        fname = 'prod.env'

    env_vars = dotenv_values(fname)

    pwd = env_vars.get('PWD')
    uid = env_vars.get('UID')
    database = env_vars.get('Database')
    server = env_vars.get('Server')

    CONFIG = {
        'Driver': '{ODBC Driver 17 for SQL Server}',
        'UID' : uid,
        'PWD' : pwd,
        'Server' : server
    }

    return CONFIG