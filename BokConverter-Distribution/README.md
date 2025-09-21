# 📚 Enhanced BOK to ACCDB Converter

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-5.0+-blue.svg)

**A powerful and user-friendly tool for converting BOK files to Microsoft Access ACCDB format**

[🚀 Quick Start](#-quick-start) • [📖 Documentation](#-documentation) • [💾 Download](#-download) • [🤝 Contributing](#-contributing)

</div>

---

## 🌟 Overview

The **Enhanced BOK to ACCDB Converter** is a robust Windows application that simplifies the conversion of BOK files into Microsoft Access ACCDB format. Built with PowerShell and Windows Forms, it provides an intuitive graphical interface for seamless file conversion.

### ✨ Key Features

- 🎯 **Intuitive GUI** - Easy-to-use interface for effortless file selection and conversion
- 📁 **Batch Processing** - Convert multiple BOK files simultaneously
- 📊 **Real-time Progress** - Detailed activity log with conversion progress tracking
- 🎛️ **Customizable Output** - Choose your preferred destination folder
- ⚡ **Enhanced Performance** - Optimized conversion algorithms for speed and reliability
- 🔄 **Error Handling** - Comprehensive error detection and reporting
- 🌐 **Bilingual Support** - Full Arabic and English language support

## 🚀 Quick Start

### Prerequisites

- **Windows 10** or later (Windows 7 SP1+ supported)
- **.NET Framework 4.5+** (usually pre-installed)
- **PowerShell 5.0+** (built into Windows)
- **Microsoft Access Database Engine** (for .accdb files) - [Download here](https://www.microsoft.com/en-us/download/details.aspx?id=54920)

### 📥 Installation

#### Option 1: Portable Version (Recommended)
1. Download the latest release from [Releases](../../releases)
2. Extract the files to your desired location
3. Run `Quick_Setup.bat` to verify system requirements
4. Double-click `BokConverterGUI_Enhanced.exe` to start

#### Option 2: Full Installer (Coming Soon)
1. Download `BokConverter_Setup.exe` from [Releases](../../releases)
2. Run the installer and follow the setup wizard
3. Launch from Start Menu or Desktop shortcut

### 🎮 Usage

1. **Launch the Application**
   ```
   Double-click BokConverterGUI_Enhanced.exe
   ```

2. **Select BOK Files**
   - Click "Select BOK Files" button
   - Choose one or multiple BOK files from your computer

3. **Choose Output Folder**
   - Click "Browse Folder" to select destination
   - Create a new folder if needed

4. **Start Conversion**
   - Click "Start Enhanced Convert"
   - Monitor progress in the activity log
   - Access converted files in your chosen output folder

## 📖 Documentation

| Document | Description | Language |
|----------|-------------|----------|
| [📋 Installation Guide](docs/installation-guide.md) | Detailed installation instructions | 🇺🇸 🇸🇦 |
| [📖 User Manual](docs/user-manual.md) | Complete usage guide | 🇺🇸 🇸🇦 |
| [⚙️ Requirements](requirements.txt) | System requirements and dependencies | 🇺🇸 🇸🇦 |
| [🚀 Distribution Guide](DISTRIBUTION_GUIDE.md) | How to distribute the application | 🇺🇸 🇸🇦 |

## 💾 Download

### Latest Release: v1.0.0

| Platform | Download | Size | Notes |
|----------|----------|------|-------|
| Windows (Portable) | [📦 BokConverter_Portable.zip](../../releases/latest) | ~50KB | No installation required |
| Windows (Installer) | [🔧 BokConverter_Setup.exe](../../releases/latest) | ~2MB | Full installer with shortcuts |

### System Requirements

| Component | Requirement | Status |
|-----------|-------------|---------|
| **OS** | Windows 7 SP1+ / 10 / 11 | ✅ Required |
| **.NET Framework** | 4.5 or higher | ✅ Usually installed |
| **PowerShell** | 5.0 or higher | ✅ Built-in |
| **Access Engine** | For .accdb files | ⚠️ May need download |
| **Memory** | 512MB RAM minimum | ✅ Standard |
| **Storage** | 100MB free space | ✅ Minimal |

## 🛠️ Development

### Building from Source

1. **Clone the repository**
   ```powershell
   git clone https://github.com/osiadhaj03/Converter_Bok_to_Access.git
   cd Converter_Bok_to_Access/BokConverter-Distribution
   ```

2. **Install PS2EXE module**
   ```powershell
   Install-Module -Name ps2exe -Scope CurrentUser
   ```

3. **Build the executable**
   ```powershell
   cd scripts
   .\simple-build.ps1
   ```

4. **Create installer (optional)**
   ```powershell
   # Requires NSIS: https://nsis.sourceforge.io/Download
   .\create-installer-new.ps1
   ```

### Project Structure

```
BokConverter-Distribution/
├── 📁 src/                    # Source code
│   ├── BokConverterGUI_Enhanced.ps1
│   ├── icon.ico
│   └── manifest.xml
├── 📁 build/                  # Build scripts
├── 📁 scripts/                # Automation scripts
├── 📁 installer/              # Installer configuration
├── 📁 docs/                   # Documentation
├── 📁 dist/                   # Built executables
└── 📄 README.md              # This file
```

## 🔧 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **"Windows protected your PC"** | Click "More info" → "Run anyway" (normal for new apps) |
| **PowerShell execution policy** | Run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| **Access engine errors** | Install [Microsoft Access Database Engine](https://www.microsoft.com/en-us/download/details.aspx?id=54920) |
| **Application won't start** | Run `Quick_Setup.bat` to check requirements |

### Getting Help

1. 📖 Check the [User Manual](docs/user-manual.md)
2. 🔍 Search [Issues](../../issues) for similar problems
3. 🆕 Create a [New Issue](../../issues/new) with details

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **🐛 Report Bugs** - Use our [Issue Tracker](../../issues)
2. **💡 Suggest Features** - Share your ideas
3. **🔧 Submit Code** - Fork, improve, and create pull requests
4. **📚 Improve Documentation** - Help make instructions clearer
5. **🌐 Translations** - Add support for more languages

### Development Setup

```powershell
# Fork the repository and clone your fork
git clone https://github.com/YOUR_USERNAME/Converter_Bok_to_Access.git

# Create a feature branch
git checkout -b feature/your-feature-name

# Make your changes and test
.\scripts\simple-build.ps1

# Commit and push
git commit -m "Add your feature"
git push origin feature/your-feature-name

# Create a pull request
```

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](docs/LICENSE.txt) file for details.

```
MIT License - Free to use, modify, and distribute
✅ Commercial use    ✅ Modification    ✅ Distribution    ✅ Private use
```

## 🙏 Acknowledgments

- Built with **PowerShell** and **Windows Forms**
- Uses **PS2EXE** for executable conversion
- **NSIS** for installer creation
- Icons and UI inspired by modern Windows design

## � Authors

- **Osaid Haj** - Lead Developer
- **Aziz Hashlamoun** - Co-Developer

## �📊 Statistics

![GitHub stars](https://img.shields.io/github/stars/osiadhaj03/Converter_Bok_to_Access?style=social)
![GitHub forks](https://img.shields.io/github/forks/osiadhaj03/Converter_Bok_to_Access?style=social)
![GitHub issues](https://img.shields.io/github/issues/osiadhaj03/Converter_Bok_to_Access)
![GitHub downloads](https://img.shields.io/github/downloads/osiadhaj03/Converter_Bok_to_Access/total)

---

<div align="center">

**Made with ❤️ by Osaid Haj & Aziz Hashlamoun**

[⭐ Star this repo](../../stargazers) • [🐛 Report Bug](../../issues) • [✨ Request Feature](../../issues/new)

</div>

---

# 📚 محول BOK إلى ACCDB المحسن

<div align="center">

![الإصدار](https://img.shields.io/badge/الإصدار-1.0.0-blue.svg)
![المنصة](https://img.shields.io/badge/المنصة-Windows-lightgrey.svg)
![الترخيص](https://img.shields.io/badge/الترخيص-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-5.0+-blue.svg)

**أداة قوية وسهلة الاستخدام لتحويل ملفات BOK إلى تنسيق Microsoft Access ACCDB**

[🚀 البدء السريع](#-البدء-السريع) • [📖 الوثائق](#-الوثائق) • [💾 التحميل](#-التحميل) • [🤝 المساهمة](#-المساهمة)

</div>

---

## 🌟 نظرة عامة

**محول BOK إلى ACCDB المحسن** هو تطبيق Windows قوي يبسط تحويل ملفات BOK إلى تنسيق Microsoft Access ACCDB. مبني بـ PowerShell و Windows Forms، يوفر واجهة رسومية بديهية لتحويل الملفات بسلاسة.

### ✨ المميزات الرئيسية

- 🎯 **واجهة بديهية** - واجهة سهلة الاستخدام لاختيار الملفات والتحويل دون عناء
- 📁 **المعالجة المجمعة** - تحويل ملفات BOK متعددة في نفس الوقت
- 📊 **التقدم المباشر** - سجل نشاط مفصل مع تتبع تقدم التحويل
- 🎛️ **إخراج قابل للتخصيص** - اختر مجلد الوجهة المفضل لديك
- ⚡ **أداء محسن** - خوارزميات تحويل محسنة للسرعة والموثوقية
- 🔄 **معالجة الأخطاء** - اكتشاف وتقرير شامل للأخطاء
- 🌐 **دعم ثنائي اللغة** - دعم كامل للغة العربية والإنجليزية

## 🚀 البدء السريع

### المتطلبات الأساسية

- **Windows 10** أو أحدث (Windows 7 SP1+ مدعوم)
- **.NET Framework 4.5+** (عادة مثبت مسبقاً)
- **PowerShell 5.0+** (مدمج في Windows)
- **Microsoft Access Database Engine** (لملفات .accdb) - [تحميل من هنا](https://www.microsoft.com/en-us/download/details.aspx?id=54920)

### 📥 التثبيت

#### الخيار 1: النسخة المحمولة (مُوصى به)
1. حمل أحدث إصدار من [الإصدارات](../../releases)
2. استخرج الملفات إلى المكان المرغوب
3. شغل `Quick_Setup.bat` للتحقق من متطلبات النظام
4. انقر نقراً مزدوجاً على `BokConverterGUI_Enhanced.exe` للبدء

#### الخيار 2: برنامج التثبيت الكامل (قريباً)
1. حمل `BokConverter_Setup.exe` من [الإصدارات](../../releases)
2. شغل برنامج التثبيت واتبع معالج الإعداد
3. شغل من قائمة ابدأ أو اختصار سطح المكتب

### 🎮 الاستخدام

1. **تشغيل التطبيق**
   ```
   انقر نقراً مزدوجاً على BokConverterGUI_Enhanced.exe
   ```

2. **اختيار ملفات BOK**
   - انقر على زر "اختيار ملفات BOK"
   - اختر ملف BOK واحد أو عدة ملفات من حاسوبك

3. **اختيار مجلد الإخراج**
   - انقر "استعراض المجلد" لتحديد الوجهة
   - أنشئ مجلد جديد إذا لزم الأمر

4. **بدء التحويل**
   - انقر "بدء التحويل المحسن"
   - راقب التقدم في سجل النشاط
   - اطلع على الملفات المحولة في مجلد الإخراج المختار

## 📖 الوثائق

| الوثيقة | الوصف | اللغة |
|---------|--------|-------|
| [📋 دليل التثبيت](docs/installation-guide.md) | تعليمات التثبيت التفصيلية | 🇺🇸 🇸🇦 |
| [📖 دليل المستخدم](docs/user-manual.md) | دليل الاستخدام الكامل | 🇺🇸 🇸🇦 |
| [⚙️ المتطلبات](requirements.txt) | متطلبات النظام والتبعيات | 🇺🇸 🇸🇦 |
| [🚀 دليل التوزيع](DISTRIBUTION_GUIDE.md) | كيفية توزيع التطبيق | 🇺🇸 🇸🇦 |

## 💾 التحميل

### أحدث إصدار: v1.0.0

| المنصة | التحميل | الحجم | ملاحظات |
|-------|---------|-------|---------|
| Windows (محمول) | [📦 BokConverter_Portable.zip](../../releases/latest) | ~50KB | لا يحتاج تثبيت |
| Windows (مثبت) | [🔧 BokConverter_Setup.exe](../../releases/latest) | ~2MB | برنامج تثبيت كامل مع اختصارات |

## 🤝 المساهمة

نرحب بالمساهمات! إليك كيف يمكنك المساعدة:

1. **🐛 الإبلاغ عن الأخطاء** - استخدم [متتبع المشاكل](../../issues)
2. **💡 اقتراح ميزات** - شارك أفكارك
3. **🔧 إرسال كود** - Fork، حسن، وأنشئ pull requests
4. **📚 تحسين الوثائق** - ساعد في جعل التعليمات أوضح
5. **🌐 الترجمات** - أضف دعم لمزيد من اللغات

## 📜 الترخيص

هذا المشروع مرخص تحت **رخصة MIT** - راجع ملف [LICENSE](docs/LICENSE.txt) للتفاصيل.

```
رخصة MIT - مجاني للاستخدام والتعديل والتوزيع
✅ الاستخدام التجاري    ✅ التعديل    ✅ التوزيع    ✅ الاستخدام الخاص
```

---

<div align="center">

**صُنع بـ ❤️ من قبل أسيد حاج وعزيز هشلمون**

[⭐ ضع نجمة للمستودع](../../stargazers) • [🐛 بلغ عن خطأ](../../issues) • [✨ اطلب ميزة](../../issues/new)

</div>