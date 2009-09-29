using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace DiagnosisModeler
{
    public partial class PromptDialogBox : Form
    {
        private string input = "";
        public string PromptValue
        {
            get { return this.input; }
        }

        public string PromptText
        {
            get { return this.lblPrompt.Text; }
            set { this.lblPrompt.Text = value; }
        }

        public PromptDialogBox()
        {
            InitializeComponent();
            this.Text = String.Format("Promt from {0}", Application.ProductName);
        }
        public PromptDialogBox(string prompt)
        {
            InitializeComponent();
            this.lblPrompt.Text = prompt;
        }

        private void cmdCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void cmdOK_Click(object sender, EventArgs e)
        {
            if (txtValue.Text.Length > 0)
                this.input = txtValue.Text;
            this.DialogResult = DialogResult.OK;
            this.Close();
        }
    }
}