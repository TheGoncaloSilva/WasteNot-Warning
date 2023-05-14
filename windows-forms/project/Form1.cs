using Microsoft.Data.SqlClient;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;
using System.Xml.Linq;
using System;
using System.Data;
using Microsoft.VisualBasic;
using System.Windows.Forms;

namespace project
{
    public partial class Form1 : Form
    {
        private SqlConnection connection;
        public Form1()
        {
            InitializeComponent();
        }

        private bool connectDatabase()
        {
            this.connection = new SqlConnection(
                "Data Source=" + sv_name.Text + ";" +
                "Initial Catalog=" + db_name.Text + ";" +
                "Integrated Security=SSPI;" +
                "Encrypt=False;"
            );

            try
            {
                this.connection.Open();
                if (this.connection.State == ConnectionState.Open)
                    return true;

                MessageBox.Show("Ligação não estabelecida");
                return false;
            }
            catch(Exception ex)
            {
                MessageBox.Show("Ocorreu um erro: " + ex.ToString());
                return false;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Utilizadores utilizadoresForm = new Utilizadores(this.connection);
            utilizadoresForm.Show();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            if(this.connectDatabase())
            {
                Dashboard dashboard = new Dashboard(this.connection);
                this.Controls.Add(dashboard);
                dashboard.Dock = DockStyle.Fill;
                this.Controls.SetChildIndex(dashboard, 0);
                this.Show();
            }
        }

        private void sv_name_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}