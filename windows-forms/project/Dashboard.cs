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
    public partial class Dashboard : UserControl
    {
        SqlConnection connection;
        public Dashboard(SqlConnection connection)
        {
            InitializeComponent();
            this.connection = connection;
        }

        private void Dashboard_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            Utilizadores utilizadores = new Utilizadores(connection);
            utilizadores.Show();
        }
    }
}
