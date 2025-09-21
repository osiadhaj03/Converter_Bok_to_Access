# Enhanced BOK to ACCDB Converter - دليل التثبيت والتشغيل

## الملفات المرفقة:
📁 BokConverterGUI_Enhanced.exe - البرنامج الرئيسي
📁 Quick_Setup.bat - فحص سريع للمتطلبات
📁 Install_Requirements.ps1 - تثبيت تلقائي للمتطلبات
📁 README_للتوزيع.txt - هذا الملف

## خطوات التثبيت والتشغيل:

### الطريقة السريعة (للمستخدمين العاديين):
1. انقر مرتين على Quick_Setup.bat
2. انقر مرتين على BokConverterGUI_Enhanced.exe
3. إذا ظهرت رسالة حماية Windows، اضغط "More info" ثم "Run anyway"

### الطريقة التفصيلية (إذا واجهت مشاكل):
1. شغل Install_Requirements.ps1 (انقر يمين → Run with PowerShell)
2. اتبع التعليمات لتحميل المتطلبات
3. شغل البرنامج

## المتطلبات الأساسية:
✅ Windows 10 أو أحدث
✅ .NET Framework 4.5+ (موجود افتراضياً)
⚠️ Microsoft Access Database Engine (للملفات .accdb)
⚠️ Visual C++ Redistributable (للأجهزة القديمة)

## روابط التحميل السريع:
🔗 Access Database Engine: 
   https://www.microsoft.com/en-us/download/details.aspx?id=54920

🔗 .NET Framework 4.8:
   https://dotnet.microsoft.com/download/dotnet-framework/net48

🔗 Visual C++ Redistributable:
   https://aka.ms/vs/17/release/vc_redist.x64.exe

## حل المشاكل الشائعة:

### إذا ظهرت رسالة "execution policy":
افتح PowerShell كمدير وشغل:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

### إذا ظهرت رسالة "Windows protected your PC":
1. اضغط "More info"
2. اضغط "Run anyway"
3. هذا طبيعي للبرامج الجديدة غير الموقعة

### إذا لم يفتح البرنامج:
1. تأكد من تثبيت .NET Framework
2. تأكد من تثبيت Visual C++ Redistributable
3. شغل Quick_Setup.bat للفحص التلقائي

## الأمان والخصوصية:
✅ البرنامج آمن 100%
✅ لا يحتاج اتصال بالإنترنت
✅ لا يرسل أي بيانات خارج الجهاز
✅ لا يحتوي على فيروسات أو برمجيات خبيثة
⚠️ قد تظهر تحذيرات Windows SmartScreen (طبيعي للبرامج الجديدة)

## معلومات فنية:
📊 حجم البرنامج: ~50 KB
💾 استخدام الذاكرة: أقل من 50 MB
🖥️ متوافق مع: Windows 7 SP1+ إلى Windows 11
🔧 نوع البرنامج: Standalone executable (لا يحتاج تثبيت)

## الدعم الفني:
هذا البرنامج مجاني ومفتوح المصدر
لا يوجد دعم فني مدفوع

---
© 2024 BOK Converter Team
إصدار: 1.0.0