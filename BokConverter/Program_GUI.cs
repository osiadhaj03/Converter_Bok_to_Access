using System;
using System.Windows.Forms;

namespace BokConverterGUI
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            // Enable visual styles and text rendering
            System.Windows.Forms.Application.EnableVisualStyles();
            System.Windows.Forms.Application.SetCompatibleTextRenderingDefault(false);
            
            // Run the main form
            System.Windows.Forms.Application.Run(new MainForm());
        }
    }
}
