using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;

namespace DiagnosisModeler
{
    public partial class frmMain : Form
    {
        private bool dirty = false;

        public frmMain()
        {
            InitializeComponent();
            foreach (DataGridViewColumn c in dataGridView1.Columns)
                c.Tag = false;
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void deleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            int count = dataGridView1.SelectedColumns.Count;
            if (count > 0)
            {
                if (MessageBox.Show(String.Format("Really delete {0} column(s)?", count), "Delete Column?", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
                {
                    for (int x = 0; x < count; x++)
                        dataGridView1.Columns.Remove(dataGridView1.SelectedColumns[x]);
                }
            }
        }

        private void newToolStripMenuItem_Click(object sender, EventArgs e)
        {
            PromptDialogBox pdb = new PromptDialogBox("Please enter the column header text.");
            pdb.Text = "Column Header Name...";
            if (pdb.ShowDialog() == DialogResult.OK)
            {
                DataGridViewColumn c = new DataGridViewTextBoxColumn();
                c.HeaderText = pdb.PromptValue;
                c.Name = pdb.PromptValue.Replace(" ", "-");
                c.Tag = false;
                c.ContextMenuStrip = ctxColumn;
                c.SortMode = DataGridViewColumnSortMode.Programmatic;
                dataGridView1.Columns.Add(c);
            }
        }

        private void makeGoalAttributeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            int count = dataGridView1.SelectedColumns.Count;
            if (count == 1)
            {
                // find the currently selected column and deactivate it
                foreach (DataGridViewColumn colOld in dataGridView1.Columns)
                {
                    if ((bool)colOld.Tag == true)
                    {
                        int oldColIdx = colOld.Index;
                        for (int rOld = 0; rOld < dataGridView1.Rows.Count; rOld++)
                            dataGridView1[oldColIdx, rOld].Style.BackColor = dataGridView1.DefaultCellStyle.BackColor;
                        colOld.Tag = false;
                    }
                }
                
                // set the new cell's properties
                makeGoalAttributeToolStripMenuItem.Checked = !makeGoalAttributeToolStripMenuItem.Checked;
                if (makeGoalAttributeToolStripMenuItem.Checked)
                {
                    DataGridViewColumn c = dataGridView1.SelectedColumns[0];

                    int newColIdx = c.Index;
                    for (int rNew = 0; rNew < dataGridView1.Rows.Count; rNew++)
                        dataGridView1[newColIdx, rNew].Style.BackColor = Color.PowderBlue;

                    c.Tag = true;
                }
            }
        }

        private void ctxColumn_Opening(object sender, CancelEventArgs e)
        {
            int count = dataGridView1.SelectedColumns.Count;
            if (count == 1)
            {
                DataGridViewColumn c = dataGridView1.SelectedColumns[0];
                makeGoalAttributeToolStripMenuItem.Checked = (bool)c.Tag;
                makeGoalAttributeToolStripMenuItem.Enabled = true;
            }
            else
            {
                makeGoalAttributeToolStripMenuItem.Checked = false;
                makeGoalAttributeToolStripMenuItem.Enabled = false;
            }
        }

        private void removeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            deleteToolStripMenuItem_Click(sender, e);
        }

        private void newModelToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (dirty && MessageBox.Show("You have unsaved changes.  Do you want to save now?", "Save Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
                this.SaveModel();
            dataGridView1.Columns.Clear();
            saveModelToolStripMenuItem.Enabled = false;
        }

        private void SaveModel()
        {
            using (SaveFileDialog sfd = new SaveFileDialog())
            {
                sfd.Title = "Save Model";
                sfd.Filter = "LISP Code Files|*.cl|Delimited Text Files|*.txt";
                sfd.FilterIndex = 0;
                if (sfd.ShowDialog() == DialogResult.OK)
                {
                    dirty = false;
                    saveModelToolStripMenuItem.Enabled = false;
                }
            }
        }

        private void dataGridView1_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            dirty = true;
            saveModelToolStripMenuItem.Enabled = true;
        }

        private void saveModelToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveModel();
        }

        private void frmMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (dirty && MessageBox.Show("You have unsaved changes.  Do you want to save now?", "Save Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
                this.SaveModel();
        }
    }
}