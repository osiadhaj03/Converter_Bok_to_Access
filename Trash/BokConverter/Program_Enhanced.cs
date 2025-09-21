using System;
using System.IO;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Access;

namespace BokConverterEnhanced
{
    class Program
    {
        static void Main(string[] args)
        {
            // مسار مجلد الملفات
            string bokFolderPath = @"d:\test5\bok file";
            string outputFolderPath = @"d:\test5\access file";

            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.WriteLine("=== Enhanced BOK to ACCDB Converter ===");
            Console.WriteLine("=== محول ملفات BOK المحسن ===");
            Console.WriteLine();

            // التحقق من وجود المجلدات
            if (!Directory.Exists(bokFolderPath))
            {
                Console.WriteLine($"Error: Source folder not found: {bokFolderPath}");
                Console.WriteLine("Press any key to exit...");
                Console.ReadKey();
                return;
            }

            if (!Directory.Exists(outputFolderPath))
            {
                Console.WriteLine($"Creating output folder: {outputFolderPath}");
                Directory.CreateDirectory(outputFolderPath);
            }

            Console.WriteLine($"Source folder: {bokFolderPath}");
            Console.WriteLine($"Output folder: {outputFolderPath}");
            Console.WriteLine();

            // إنشاء كائن للتحكم ببرنامج Access
            Microsoft.Office.Interop.Access.Application accessApp = null;
            int filesConverted = 0;
            int filesSkipped = 0;
            int filesError = 0;

            try
            {
                Console.WriteLine("Starting Microsoft Access...");
                accessApp = new Microsoft.Office.Interop.Access.Application();
                accessApp.Visible = false;
                accessApp.AutomationSecurity = MsoAutomationSecurity.msoAutomationSecurityLow;
                
                // الحصول على كل الملفات التي تنتهي بـ .bok
                string[] bokFiles = Directory.GetFiles(bokFolderPath, "*.bok");

                if (bokFiles.Length == 0)
                {
                    Console.WriteLine("No .bok files found in the folder.");
                    Console.WriteLine("Press any key to exit...");
                    Console.ReadKey();
                    return;
                }

                Console.WriteLine($"Found {bokFiles.Length} files to convert");
                Console.WriteLine();

                // المرور على كل ملف
                foreach (string bokFilePath in bokFiles)
                {
                    string fileName = Path.GetFileNameWithoutExtension(bokFilePath);
                    string tempMdbPath = Path.Combine(Path.GetTempPath(), fileName + ".mdb");
                    string outputAccdbPath = Path.Combine(outputFolderPath, fileName + ".accdb");

                    Console.Write($"Converting: {Path.GetFileName(bokFilePath)}... ");

                    try
                    {
                        // التحقق من وجود الملف المحول مسبقاً
                        if (File.Exists(outputAccdbPath))
                        {
                            Console.WriteLine("Already exists - Skipped");
                            filesSkipped++;
                            continue;
                        }

                        // الخطوة 1: نسخ .bok إلى مجلد مؤقت بامتداد .mdb
                        File.Copy(bokFilePath, tempMdbPath, true);

                        // الخطوة 2: التحويل باستخدام الطريقة المحسنة
                        bool conversionSuccess = ConvertDatabaseEnhanced(accessApp, tempMdbPath, outputAccdbPath);

                        // حذف الملف المؤقت
                        if (File.Exists(tempMdbPath))
                        {
                            File.Delete(tempMdbPath);
                        }

                        if (conversionSuccess)
                        {
                            Console.WriteLine("Success ✓");
                            filesConverted++;
                        }
                        else
                        {
                            Console.WriteLine("Failed ✗");
                            filesError++;
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Failed ✗");
                        Console.WriteLine($"   Error: {ex.Message}");
                        filesError++;

                        // تنظيف الملفات المؤقتة في حال الخطأ
                        try
                        {
                            if (accessApp != null)
                            {
                                accessApp.CloseCurrentDatabase();
                            }
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
                Console.WriteLine($"\nGeneral error occurred: {ex.Message}");
                Console.WriteLine("Make sure Microsoft Access is installed on the system.");
            }
            finally
            {
                // إغلاق برنامج Access وتحرير الذاكرة
                if (accessApp != null)
                {
                    try
                    {
                        accessApp.Quit();
                        Marshal.ReleaseComObject(accessApp);
                    }
                    catch { }
                }
            }

            // عرض النتائج النهائية
            Console.WriteLine("\n" + new string('=', 50));
            Console.WriteLine("Operation Report:");
            Console.WriteLine($"• Successfully converted: {filesConverted} files");
            Console.WriteLine($"• Skipped (already exists): {filesSkipped} files");
            Console.WriteLine($"• Failed to convert: {filesError} files");
            Console.WriteLine($"• Total files: {filesConverted + filesSkipped + filesError} files");
            Console.WriteLine();

            if (filesConverted > 0)
            {
                Console.WriteLine($"Converted files saved in: {outputFolderPath}");
            }

            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }

        private static bool ConvertDatabaseEnhanced(Microsoft.Office.Interop.Access.Application accessApp, string sourceMdbPath, string targetAccdbPath)
        {
            try
            {
                // الطريقة الأولى: استخدام OpenCurrentDatabase ثم SaveAs
                accessApp.OpenCurrentDatabase(sourceMdbPath, false, "");
                
                // حفظ قاعدة البيانات بتنسيق ACCDB
                accessApp.CurrentDb().Execute("SELECT 1", false); // Test connection
                
                // إغلاق قاعدة البيانات الحالية
                accessApp.CloseCurrentDatabase();
                
                // الطريقة الثانية: استخدام CompactRepair مع تحديد التنسيق
                try
                {
                    accessApp.CompactRepair(sourceMdbPath, targetAccdbPath, false);
                    return true;
                }
                catch
                {
                    // الطريقة الثالثة: استخدام ConvertAccessProject
                    try
                    {
                        accessApp.ConvertAccessProject(sourceMdbPath, targetAccdbPath, AcFileFormat.acFileFormatAccess2007);
                        return true;
                    }
                    catch
                    {
                        // الطريقة الرابعة: الطريقة اليدوية
                        return ConvertManually(accessApp, sourceMdbPath, targetAccdbPath);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Conversion error: {ex.Message}");
                return false;
            }
        }

        private static bool ConvertManually(Microsoft.Office.Interop.Access.Application accessApp, string sourceMdbPath, string targetAccdbPath)
        {
            try
            {
                // فتح قاعدة البيانات المصدر
                accessApp.OpenCurrentDatabase(sourceMdbPath, false, "");
                
                // إنشاء قاعدة بيانات جديدة بتنسيق ACCDB
                accessApp.NewCurrentDatabase(targetAccdbPath, AcNewDatabaseFormat.acNewDatabaseFormatAccess2007);
                
                // الحصول على مرجع لقاعدة البيانات المصدر
                string tempDbPath = sourceMdbPath;
                
                // إغلاق قاعدة البيانات الهدف مؤقتاً
                accessApp.CloseCurrentDatabase();
                
                // فتح قاعدة البيانات المصدر مرة أخرى
                accessApp.OpenCurrentDatabase(tempDbPath, false, "");
                
                // نسخ جميع الكائنات إلى قاعدة البيانات الجديدة
                var db = accessApp.CurrentDb();
                
                // نسخ الجداول
                foreach (Microsoft.Office.Interop.Access.AccessObject table in accessApp.CurrentData.AllTables)
                {
                    if (!table.Name.StartsWith("MSys"))
                    {
                        try
                        {
                            accessApp.DoCmd.TransferDatabase(
                                AcDataTransferType.acExport,
                                "Microsoft.ACE.OLEDB.12.0",
                                targetAccdbPath,
                                AcObjectType.acTable,
                                table.Name,
                                table.Name,
                                false
                            );
                        }
                        catch { }
                    }
                }
                
                // نسخ الاستعلامات
                foreach (Microsoft.Office.Interop.Access.AccessObject query in accessApp.CurrentData.AllQueries)
                {
                    try
                    {
                        accessApp.DoCmd.TransferDatabase(
                            AcDataTransferType.acExport,
                            "Microsoft.ACE.OLEDB.12.0",
                            targetAccdbPath,
                            AcObjectType.acQuery,
                            query.Name,
                            query.Name,
                            false
                        );
                    }
                    catch { }
                }
                
                // نسخ النماذج
                foreach (Microsoft.Office.Interop.Access.AccessObject form in accessApp.CurrentProject.AllForms)
                {
                    try
                    {
                        accessApp.DoCmd.TransferDatabase(
                            AcDataTransferType.acExport,
                            "Microsoft.ACE.OLEDB.12.0",
                            targetAccdbPath,
                            AcObjectType.acForm,
                            form.Name,
                            form.Name,
                            false
                        );
                    }
                    catch { }
                }
                
                // نسخ التقارير
                foreach (Microsoft.Office.Interop.Access.AccessObject report in accessApp.CurrentProject.AllReports)
                {
                    try
                    {
                        accessApp.DoCmd.TransferDatabase(
                            AcDataTransferType.acExport,
                            "Microsoft.ACE.OLEDB.12.0",
                            targetAccdbPath,
                            AcObjectType.acReport,
                            report.Name,
                            report.Name,
                            false
                        );
                    }
                    catch { }
                }
                
                accessApp.CloseCurrentDatabase();
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Manual conversion error: {ex.Message}");
                try
                {
                    accessApp.CloseCurrentDatabase();
                }
                catch { }
                return false;
            }
        }
    }
}
