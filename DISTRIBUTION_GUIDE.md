# كيفية تحويل سكريبت PowerShell إلى برنامج قابل للتوزيع

## الملخص
لقد قمت بإنشاء بنية مشروع متكاملة لتحويل سكريبت `BokConverterGUI_Enhanced.ps1` إلى برنامج قابل للتوزيع مع ملف setup.

## ما تم إنجازه:

### 1. بناء الملف التنفيذي (.exe)
✅ **تم إنشاء:** `BokConverterGUI_Enhanced.exe`
- الحجم: 0.05 MB
- الموقع: `dist/BokConverterGUI_Enhanced.exe`
- يعمل بدون الحاجة لـ PowerShell مرئي

### 2. ملفات البناء المُحدثة
✅ **السكريبتات الجاهزة:**
- `build/build-executable.ps1` - بناء الـ EXE المحسن
- `scripts/simple-build.ps1` - بناء بسيط وسريع
- `scripts/create-installer.ps1` - إنشاء installer كامل

### 3. ملفات الـ Installer
✅ **NSIS Installer Script:**
- `installer/setup-script.nsi` - سكريبت NSIS محترف
- ينشئ installer با shortcut على سطح المكتب
- يضيف البرنامج لـ Add/Remove Programs
- يدعم الإلغاء (uninstall)

### 4. الوثائق والملفات المساعدة
✅ **الملفات الجاهزة:**
- `README.md` - دليل المستخدم
- `docs/installation-guide.md` - دليل التثبيت
- `docs/user-manual.md` - دليل الاستخدام
- `src/manifest.xml` - معلومات البرنامج

## كيفية الاستخدام:

### الطريقة البسيطة (EXE فقط):
```powershell
cd "BokConverter-Distribution\scripts"
.\simple-build.ps1
```

### الطريقة الكاملة (EXE + Installer):
```powershell
# الخطوة 1: بناء الـ EXE
cd "BokConverter-Distribution\scripts"
.\simple-build.ps1

# الخطوة 2: إنشاء الـ Installer (يتطلب NSIS)
# تحميل NSIS من: https://nsis.sourceforge.io/Download
# أو تثبيت عبر: choco install nsis
.\create-installer-new.ps1
```

## النتائج النهائية:

### الملفات الجاهزة للتوزيع:
1. **`dist/BokConverterGUI_Enhanced.exe`** - البرنامج مباشرة
2. **`dist/BokConverter_Setup.exe`** - ملف الـ setup (عند تثبيت NSIS)

### مزايا هذا الإعداد:
- ✅ **سهولة التوزيع**: ملف exe واحد أو installer
- ✅ **لا يحتاج PowerShell**: يعمل على أي Windows
- ✅ **installer احترافي**: مع shortcuts وإلغاء تثبيت
- ✅ **حجم صغير**: 50KB فقط للـ EXE
- ✅ **بنية منظمة**: سهل الصيانة والتطوير

## للاستخدام الفوري:
البرنامج جاهز الآن في:
**`d:\Converter_Bok_to_Access\BokConverter-Distribution\dist\BokConverterGUI_Enhanced.exe`**

يمكنك توزيع هذا الملف مباشرة ولن يحتاج المستخدمون إلى PowerShell أو أي إعدادات إضافية.

---

**المطورون:** أسيد حاج (Osaid Haj) وعزيز هشلمون (Aziz Hashlamoun)  
**© 2025 جميع الحقوق محفوظة**