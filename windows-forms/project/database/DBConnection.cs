using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace project.database
{
    public class DBConnection
    {
        static DBConnection DB = new DBConnection();
        private readonly string connectionString;

        public DBConnection() 
        {
            connectionString = "Server=(local); Database=db; Integrated Security=true";
        }

        public SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }
    }
}
