using System;
using System.IO;
using System.Runtime.InteropServices;
using Microsoft.Office.Interop.Access;

namespace BokConverter
{
    class Program
    {
        static void Main(string[] args)
        {
            // مسار مجلد الملفات - يمكنك تغييره حسب الحاجة
            string bokFolderPath = @"d:\test5\bok file";
            string outputFolderPath = @"d:\test5\access file";

            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.WriteLine("=== برنامج تحويل ملفات .bok إلى .accdb ===");
            Console.WriteLine();

            // التحقق من وجود المجلدات
            if (!Directory.Exists(bokFolderPath))
            {
                Console.WriteLine($"خطأ: مجلد الملفات غير موجود: {bokFolderPath}");
                Console.WriteLine("اضغط أي مفتاح للخروج...");
                Console.ReadKey();
                return;
            }

            if (!Directory.Exists(outputFolderPath))
            {
                Console.WriteLine($"إنشاء مجلد الإخراج: {outputFolderPath}");
                Directory.CreateDirectory(outputFolderPath);
            }

            Console.WriteLine($"مجلد الملفات المصدر: {bokFolderPath}");
            Console.WriteLine($"مجلد الإخراج: {outputFolderPath}");
            Console.WriteLine();

            // إنشاء كائن للتحكم ببرنامج Access
            Application accessApp = null;
            int filesConverted = 0;
            int filesSkipped = 0;
            int filesError = 0;

            try
            {
                Console.WriteLine("بدء تشغيل Microsoft Access...");
                accessApp = new Application();
                accessApp.Visible = false; // إخفاء واجهة Access
                
                // الحصول على كل الملفات التي تنتهي بـ .bok
                string[] bokFiles = Directory.GetFiles(bokFolderPath, "*.bok");

                if (bokFiles.Length == 0)
                {
                    Console.WriteLine("لم يتم العثور على أي ملفات بامتداد .bok في المجلد.");
                    Console.WriteLine("اضغط أي مفتاح للخروج...");
                    Console.ReadKey();
                    return;
                }

                Console.WriteLine($"تم العثور على {bokFiles.Length} ملف للتحويل");
                Console.WriteLine();

                // المرور على كل ملف
                foreach (string bokFilePath in bokFiles)
                {
                    string fileName = Path.GetFileNameWithoutExtension(bokFilePath);
                    string tempMdbPath = Path.Combine(Path.GetTempPath(), fileName + ".mdb");
                    string outputAccdbPath = Path.Combine(outputFolderPath, fileName + ".accdb");

                    Console.Write($"تحويل: {Path.GetFileName(bokFilePath)}... ");

                    try
                    {
                        // التحقق من وجود الملف المحول مسبقاً
                        if (File.Exists(outputAccdbPath))
                        {
                            Console.WriteLine("موجود مسبقاً - تم التجاهل");
                            filesSkipped++;
                            continue;
                        }

                        // الخطوة 1: نسخ .bok إلى مجلد مؤقت بامتداد .mdb
                        File.Copy(bokFilePath, tempMdbPath, true);

                        // الخطوة 2: فتح قاعدة البيانات
                        accessApp.OpenCurrentDatabase(tempMdbPath, false);

                        // الخطوة 3: حفظ بتنسيق .accdb
                        accessApp.SaveAsAXL(outputAccdbPath, "Microsoft.ACE.OLEDB.12.0");

                        // إغلاق قاعدة البيانات
                        accessApp.CloseCurrentDatabase();

                        // حذف الملف المؤقت
                        if (File.Exists(tempMdbPath))
                        {
                            File.Delete(tempMdbPath);
                        }

                        Console.WriteLine("نجح ✓");
                        filesConverted++;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"فشل ✗");
                        Console.WriteLine($"   الخطأ: {ex.Message}");
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
                Console.WriteLine($"\nحدث خطأ عام أثناء العملية: {ex.Message}");
                Console.WriteLine("تأكد من تثبيت Microsoft Access على النظام.");
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
            Console.WriteLine("تقرير العملية:");
            Console.WriteLine($"• تم التحويل بنجاح: {filesConverted} ملف");
            Console.WriteLine($"• تم التجاهل (موجود مسبقاً): {filesSkipped} ملف");
            Console.WriteLine($"• فشل في التحويل: {filesError} ملف");
            Console.WriteLine($"• إجمالي الملفات: {filesConverted + filesSkipped + filesError} ملف");
            Console.WriteLine();

            if (filesConverted > 0)
            {
                Console.WriteLine($"الملفات المحولة محفوظة في: {outputFolderPath}");
            }

            Console.WriteLine("\nاضغط أي مفتاح للخروج...");
            Console.ReadKey();
        }
    }
}
