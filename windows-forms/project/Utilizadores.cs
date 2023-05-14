using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace project
{
    public partial class Utilizadores : Form
    {
        SqlConnection connection;
        public Utilizadores(SqlConnection connection)
        {
            InitializeComponent();
            this.connection = connection;
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Utilizadores_Load(object sender, EventArgs e)
        {
            SqlCommand command = new SqlCommand("SELECT * FROM UTILIZADOR", this.connection);
            DataTable dataTable = new DataTable();
            using (SqlDataReader reader = command.ExecuteReader())
            {
                dataTable.Load(reader);
            }
            dataGridView1.DataSource = dataTable;
        }
    }
}
