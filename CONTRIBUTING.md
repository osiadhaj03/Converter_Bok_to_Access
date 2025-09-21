# Contributing to Enhanced BOK to ACCDB Converter

First off, thank you for considering contributing to our project! 🎉

## Ways to Contribute

### 🐛 Reporting Bugs
- Check if the bug has already been reported in [Issues](../../issues)
- Use the bug report template when creating a new issue
- Include system information, steps to reproduce, and expected vs actual behavior

### 💡 Suggesting Features
- Check existing [Feature Requests](../../issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
- Describe your idea in detail with use cases
- Consider the scope and impact on existing functionality

### 🔧 Code Contributions

#### Getting Started
1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/Converter_Bok_to_Access.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`

#### Development Setup
```powershell
# Navigate to the project directory
cd BokConverter-Distribution

# Install PS2EXE module for building
Install-Module -Name ps2exe -Scope CurrentUser

# Test your changes
.\scripts\simple-build.ps1
```

#### Code Style Guidelines
- Follow PowerShell best practices
- Use clear, descriptive variable names
- Add comments for complex logic
- Include error handling
- Test your changes thoroughly

#### Commit Guidelines
- Use clear, concise commit messages
- Reference issue numbers when applicable
- Keep commits focused on single changes

Example:
```
fix: resolve file path encoding issue (#123)

- Handle Unicode characters in file paths
- Add proper encoding for Arabic file names
- Include unit tests for path validation
```

### 📚 Documentation
- Improve existing documentation
- Add examples and use cases
- Translate content to additional languages
- Fix typos and clarify instructions

### 🌐 Translations
We welcome translations to make the tool accessible to more users:
- Follow the existing bilingual format (English/Arabic)
- Maintain consistent terminology
- Test UI elements with translated text

## Pull Request Process

1. **Before submitting:**
   - Ensure your code builds successfully
   - Test the application thoroughly
   - Update documentation if needed
   - Add or update tests for new functionality

2. **Submitting:**
   - Create a pull request from your feature branch
   - Use the pull request template
   - Link to relevant issues
   - Provide clear description of changes

3. **Review process:**
   - Maintain your PR by responding to feedback
   - Make requested changes promptly
   - Ensure CI checks pass

## Development Guidelines

### Building and Testing
```powershell
# Build the executable
.\scripts\simple-build.ps1

# Run with test files (if available)
.\dist\BokConverterGUI_Enhanced.exe

# Create installer (requires NSIS)
.\scripts\create-installer-new.ps1
```

### Adding New Features
1. Create an issue first to discuss the feature
2. Follow the existing code structure
3. Add appropriate error handling
4. Update the user manual if needed
5. Consider backward compatibility

### Bug Fixes
1. Reproduce the bug first
2. Write a test case if possible
3. Fix the issue with minimal code changes
4. Verify the fix doesn't break existing functionality

## Community Guidelines

### Code of Conduct
- Be respectful and inclusive
- Help others learn and grow
- Focus on constructive feedback
- Respect different opinions and experiences

### Communication
- Use clear, professional language
- Be patient with newcomers
- Ask questions when unclear
- Share knowledge and resources

## Getting Help

- 📖 Check the [documentation](docs/) first
- 💬 Join discussions in [Issues](../../issues)
- 🔍 Search for similar problems
- 📧 Contact maintainers for complex issues

## Recognition

Contributors will be recognized in:
- The project README
- Release notes for significant contributions
- Special mentions for exceptional help

## Development Roadmap

Current priorities:
- [ ] Enhanced error handling
- [ ] Performance optimizations
- [ ] Additional file format support
- [ ] Improved UI/UX
- [ ] Automated testing
- [ ] Continuous integration

## Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/writing-portable-modules)
- [Git Workflow](https://guides.github.com/introduction/flow/)
- [Markdown Guide](https://guides.github.com/features/mastering-markdown/)

---

# المساهمة في محول BOK إلى ACCDB المحسن

أولاً، شكراً لك على النظر في المساهمة في مشروعنا! 🎉

## طرق المساهمة

### 🐛 الإبلاغ عن الأخطاء
- تحقق من أن الخطأ لم يتم الإبلاغ عنه في [المشاكل](../../issues)
- استخدم قالب تقرير الأخطاء عند إنشاء مشكلة جديدة
- اتضمن معلومات النظام وخطوات إعادة الإنتاج والسلوك المتوقع مقابل الفعلي

### 💡 اقتراح الميزات
- تحقق من [طلبات الميزات](../../issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) الموجودة
- اوصف فكرتك بالتفصيل مع حالات الاستخدام
- اعتبر النطاق والتأثير على الوظائف الموجودة

### 🔧 مساهمات الكود

#### البدء
1. قم بعمل Fork للمستودع
2. استنسخ Fork الخاص بك: `git clone https://github.com/YOUR_USERNAME/Converter_Bok_to_Access.git`
3. أنشئ فرع ميزة: `git checkout -b feature/your-feature-name`

### 📚 الوثائق
- حسن الوثائق الموجودة
- أضف أمثلة وحالات استخدام
- ترجم المحتوى لغات إضافية
- اصلح الأخطاء الإملائية ووضح التعليمات

## إرشادات المجتمع

### قواعد السلوك
- كن محترماً وشاملاً
- ساعد الآخرين على التعلم والنمو
- ركز على التعليقات البناءة
- احترم الآراء والتجارب المختلفة

---

**شكراً لك على المساهمة في جعل هذا المشروع أفضل!** 🚀