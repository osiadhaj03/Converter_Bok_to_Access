using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Office.Interop.Access;

namespace BokConverterGUI
{
    public partial class MainForm : Form
    {
        private Button btnSelectBokFiles;
        private Button btnSelectOutputFolder;
        private Button btnConvert;
        private Button btnClear;
        private ListBox lstBokFiles;
        private TextBox txtOutputFolder;
        private ProgressBar progressBar;
        private RichTextBox txtLog;
        private Label lblBokFiles;
        private Label lblOutputFolder;
        private Label lblProgress;
        private Label lblLog;
        private Label lblTitle;

        public MainForm()
        {
            InitializeComponent();
            this.Load += MainForm_Load;
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();

            // Form properties
            this.Text = "BOK to ACCDB Converter - محول ملفات BOK إلى ACCDB";
            this.Size = new Size(800, 700);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.BackColor = Color.WhiteSmoke;

            // Title Label
            lblTitle = new Label();
            lblTitle.Text = "محول ملفات BOK إلى ACCDB";
            lblTitle.Font = new Font("Arial", 16, FontStyle.Bold);
            lblTitle.ForeColor = Color.DarkBlue;
            lblTitle.Location = new Point(20, 20);
            lblTitle.Size = new Size(350, 30);
            lblTitle.TextAlign = ContentAlignment.MiddleLeft;
            this.Controls.Add(lblTitle);

            // BOK Files Section
            lblBokFiles = new Label();
            lblBokFiles.Text = "ملفات BOK المحددة:";
            lblBokFiles.Font = new Font("Arial", 10, FontStyle.Bold);
            lblBokFiles.Location = new Point(20, 70);
            lblBokFiles.Size = new Size(150, 20);
            this.Controls.Add(lblBokFiles);

            btnSelectBokFiles = new Button();
            btnSelectBokFiles.Text = "اختيار ملفات BOK";
            btnSelectBokFiles.Font = new Font("Arial", 10);
            btnSelectBokFiles.Location = new Point(620, 65);
            btnSelectBokFiles.Size = new Size(140, 30);
            btnSelectBokFiles.BackColor = Color.LightBlue;
            btnSelectBokFiles.Click += BtnSelectBokFiles_Click;
            this.Controls.Add(btnSelectBokFiles);

            lstBokFiles = new ListBox();
            lstBokFiles.Location = new Point(20, 100);
            lstBokFiles.Size = new Size(740, 120);
            lstBokFiles.Font = new Font("Arial", 9);
            lstBokFiles.SelectionMode = SelectionMode.MultiExtended;
            this.Controls.Add(lstBokFiles);

            // Output Folder Section
            lblOutputFolder = new Label();
            lblOutputFolder.Text = "مجلد الحفظ:";
            lblOutputFolder.Font = new Font("Arial", 10, FontStyle.Bold);
            lblOutputFolder.Location = new Point(20, 240);
            lblOutputFolder.Size = new Size(100, 20);
            this.Controls.Add(lblOutputFolder);

            txtOutputFolder = new TextBox();
            txtOutputFolder.Location = new Point(20, 265);
            txtOutputFolder.Size = new Size(580, 25);
            txtOutputFolder.Font = new Font("Arial", 9);
            txtOutputFolder.ReadOnly = true;
            txtOutputFolder.BackColor = Color.White;
            this.Controls.Add(txtOutputFolder);

            btnSelectOutputFolder = new Button();
            btnSelectOutputFolder.Text = "اختيار المجلد";
            btnSelectOutputFolder.Font = new Font("Arial", 10);
            btnSelectOutputFolder.Location = new Point(620, 260);
            btnSelectOutputFolder.Size = new Size(140, 30);
            btnSelectOutputFolder.BackColor = Color.LightGreen;
            btnSelectOutputFolder.Click += BtnSelectOutputFolder_Click;
            this.Controls.Add(btnSelectOutputFolder);

            // Progress Section
            lblProgress = new Label();
            lblProgress.Text = "تقدم العملية:";
            lblProgress.Font = new Font("Arial", 10, FontStyle.Bold);
            lblProgress.Location = new Point(20, 310);
            lblProgress.Size = new Size(100, 20);
            this.Controls.Add(lblProgress);

            progressBar = new ProgressBar();
            progressBar.Location = new Point(20, 335);
            progressBar.Size = new Size(580, 25);
            progressBar.Style = ProgressBarStyle.Blocks;
            this.Controls.Add(progressBar);

            // Buttons Section
            btnConvert = new Button();
            btnConvert.Text = "بدء التحويل";
            btnConvert.Font = new Font("Arial", 12, FontStyle.Bold);
            btnConvert.Location = new Point(620, 320);
            btnConvert.Size = new Size(140, 40);
            btnConvert.BackColor = Color.Orange;
            btnConvert.ForeColor = Color.White;
            btnConvert.Enabled = false;
            btnConvert.Click += BtnConvert_Click;
            this.Controls.Add(btnConvert);

            btnClear = new Button();
            btnClear.Text = "مسح الكل";
            btnClear.Font = new Font("Arial", 10);
            btnClear.Location = new Point(620, 370);
            btnClear.Size = new Size(140, 30);
            btnClear.BackColor = Color.LightCoral;
            btnClear.Click += BtnClear_Click;
            this.Controls.Add(btnClear);

            // Log Section
            lblLog = new Label();
            lblLog.Text = "سجل العمليات:";
            lblLog.Font = new Font("Arial", 10, FontStyle.Bold);
            lblLog.Location = new Point(20, 420);
            lblLog.Size = new Size(100, 20);
            this.Controls.Add(lblLog);

            txtLog = new RichTextBox();
            txtLog.Location = new Point(20, 445);
            txtLog.Size = new Size(740, 200);
            txtLog.Font = new Font("Consolas", 9);
            txtLog.ReadOnly = true;
            txtLog.BackColor = Color.Black;
            txtLog.ForeColor = Color.LimeGreen;
            this.Controls.Add(txtLog);

            this.ResumeLayout(false);
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            LogMessage("مرحباً بك في محول ملفات BOK إلى ACCDB", Color.Yellow);
            LogMessage("اختر ملفات BOK ومجلد الحفظ ثم اضغط 'بدء التحويل'", Color.White);
            
            // Set default output folder
            string defaultOutput = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Converted_ACCDB");
            txtOutputFolder.Text = defaultOutput;
        }

        private void BtnSelectBokFiles_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.Title = "اختيار ملفات BOK";
                openFileDialog.Filter = "BOK Files (*.bok)|*.bok|All Files (*.*)|*.*";
                openFileDialog.Multiselect = true;
                openFileDialog.InitialDirectory = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    lstBokFiles.Items.Clear();
                    foreach (string fileName in openFileDialog.FileNames)
                    {
                        lstBokFiles.Items.Add(fileName);
                    }
                    
                    LogMessage($"تم اختيار {openFileDialog.FileNames.Length} ملف BOK", Color.Cyan);
                    UpdateConvertButtonState();
                }
            }
        }

        private void BtnSelectOutputFolder_Click(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog = new FolderBrowserDialog())
            {
                folderDialog.Description = "اختيار مجلد حفظ الملفات المحولة";
                folderDialog.ShowNewFolderButton = true;

                if (folderDialog.ShowDialog() == DialogResult.OK)
                {
                    txtOutputFolder.Text = folderDialog.SelectedPath;
                    LogMessage($"مجلد الحفظ: {folderDialog.SelectedPath}", Color.Cyan);
                    UpdateConvertButtonState();
                }
            }
        }

        private void UpdateConvertButtonState()
        {
            btnConvert.Enabled = lstBokFiles.Items.Count > 0 && !string.IsNullOrEmpty(txtOutputFolder.Text);
        }

        private async void BtnConvert_Click(object sender, EventArgs e)
        {
            if (lstBokFiles.Items.Count == 0)
            {
                MessageBox.Show("يرجى اختيار ملفات BOK أولاً", "تنبيه", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (string.IsNullOrEmpty(txtOutputFolder.Text))
            {
                MessageBox.Show("يرجى اختيار مجلد الحفظ أولاً", "تنبيه", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            // Create output directory if it doesn't exist
            try
            {
                if (!Directory.Exists(txtOutputFolder.Text))
                {
                    Directory.CreateDirectory(txtOutputFolder.Text);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"خطأ في إنشاء مجلد الحفظ: {ex.Message}", "خطأ", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Disable controls during conversion
            SetControlsEnabled(false);
            progressBar.Value = 0;
            progressBar.Maximum = lstBokFiles.Items.Count;

            LogMessage("=== بدء عملية التحويل ===", Color.Yellow);
            
            await Task.Run(() => ConvertFiles());
            
            // Re-enable controls
            SetControlsEnabled(true);
        }

        private void ConvertFiles()
        {
            Microsoft.Office.Interop.Access.Application accessApp = null;
            int filesConverted = 0;
            int filesSkipped = 0;
            int filesError = 0;

            try
            {
                this.Invoke(new Action(() => LogMessage("تشغيل Microsoft Access...", Color.White)));
                
                accessApp = new Microsoft.Office.Interop.Access.Application();
                accessApp.Visible = false;

                List<string> bokFiles = new List<string>();
                this.Invoke(new Action(() => 
                {
                    foreach (string item in lstBokFiles.Items)
                    {
                        bokFiles.Add(item);
                    }
                }));

                for (int i = 0; i < bokFiles.Count; i++)
                {
                    string bokFilePath = bokFiles[i];
                    string fileName = Path.GetFileNameWithoutExtension(bokFilePath);
                    string tempMdbPath = Path.Combine(Path.GetTempPath(), $"{fileName}.mdb");
                    string outputAccdbPath = Path.Combine(txtOutputFolder.Text, $"{fileName}.accdb");

                    this.Invoke(new Action(() => 
                    {
                        LogMessage($"تحويل: {Path.GetFileName(bokFilePath)}...", Color.White);
                        progressBar.Value = i;
                    }));

                    try
                    {
                        // Check if file already exists
                        if (File.Exists(outputAccdbPath))
                        {
                            this.Invoke(new Action(() => LogMessage("   الملف موجود مسبقاً - تم التجاهل", Color.Yellow)));
                            filesSkipped++;
                            continue;
                        }

                        // Copy .bok to temp as .mdb
                        File.Copy(bokFilePath, tempMdbPath, true);

                        // Convert using CompactRepair
                        accessApp.CompactRepair(tempMdbPath, outputAccdbPath, false);

                        // Clean up temp file
                        if (File.Exists(tempMdbPath))
                        {
                            File.Delete(tempMdbPath);
                        }

                        this.Invoke(new Action(() => LogMessage("   نجح التحويل ✓", Color.LimeGreen)));
                        filesConverted++;
                    }
                    catch (Exception ex)
                    {
                        this.Invoke(new Action(() => LogMessage($"   فشل التحويل: {ex.Message}", Color.Red)));
                        filesError++;

                        // Clean up on error
                        try
                        {
                            if (File.Exists(tempMdbPath))
                            {
                                File.Delete(tempMdbPath);
                            }
                        }
                        catch { }
                    }
                }
            }
            catch (Exception ex)
            {
                this.Invoke(new Action(() => LogMessage($"خطأ عام: {ex.Message}", Color.Red)));
            }
            finally
            {
                // Close Access
                if (accessApp != null)
                {
                    try
                    {
                        accessApp.Quit();
                        Marshal.ReleaseComObject(accessApp);
                    }
                    catch { }
                }

                // Update progress and show results
                this.Invoke(new Action(() => 
                {
                    progressBar.Value = progressBar.Maximum;
                    LogMessage("=== انتهت عملية التحويل ===", Color.Yellow);
                    LogMessage($"نجح: {filesConverted} | تجوهل: {filesSkipped} | فشل: {filesError}", Color.Cyan);
                    
                    if (filesConverted > 0)
                    {
                        LogMessage($"الملفات المحولة في: {txtOutputFolder.Text}", Color.LimeGreen);
                        
                        var result = MessageBox.Show("تم التحويل بنجاح!\nهل تريد فتح مجلد الملفات المحولة؟", 
                                                   "مكتمل", MessageBoxButtons.YesNo, MessageBoxIcon.Information);
                        if (result == DialogResult.Yes)
                        {
                            System.Diagnostics.Process.Start("explorer.exe", txtOutputFolder.Text);
                        }
                    }
                }));
            }
        }

        private void SetControlsEnabled(bool enabled)
        {
            btnSelectBokFiles.Enabled = enabled;
            btnSelectOutputFolder.Enabled = enabled;
            btnConvert.Enabled = enabled && lstBokFiles.Items.Count > 0 && !string.IsNullOrEmpty(txtOutputFolder.Text);
            btnClear.Enabled = enabled;
        }

        private void BtnClear_Click(object sender, EventArgs e)
        {
            lstBokFiles.Items.Clear();
            txtLog.Clear();
            progressBar.Value = 0;
            UpdateConvertButtonState();
            LogMessage("تم مسح جميع البيانات", Color.Yellow);
        }

        private void LogMessage(string message, Color color)
        {
            txtLog.SelectionStart = txtLog.TextLength;
            txtLog.SelectionLength = 0;
            txtLog.SelectionColor = color;
            txtLog.AppendText($"[{DateTime.Now:HH:mm:ss}] {message}\n");
            txtLog.ScrollToCaret();
        }
    }
}
