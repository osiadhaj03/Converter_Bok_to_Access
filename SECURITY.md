# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 🔒 Private Reporting (Recommended)

1. **Do NOT** create a public issue for security vulnerabilities
2. Email us at: `security@bokconverter.example.com` (replace with actual email)
3. Include detailed information about the vulnerability
4. Allow up to 48 hours for initial response

### 📧 What to Include

When reporting a security issue, please include:

- **Description**: Clear description of the vulnerability
- **Impact**: Potential impact and affected systems
- **Reproduction**: Step-by-step reproduction instructions
- **Environment**: Operating system, PowerShell version, etc.
- **Files**: Any relevant files or screenshots (if safe to share)

### ⏱️ Response Timeline

- **Initial Response**: Within 48 hours
- **Investigation**: 3-7 business days
- **Fix Development**: 1-2 weeks (depending on severity)
- **Public Disclosure**: After fix is released and users have time to update

## Security Best Practices

### For Users

1. **Download Only from Official Sources**
   - Use official GitHub releases
   - Verify file hashes when provided
   - Be cautious of third-party downloads

2. **System Security**
   - Keep Windows and .NET Framework updated
   - Use antivirus software
   - Run with minimal necessary privileges

3. **File Handling**
   - Backup important files before conversion
   - Scan downloaded BOK files for malware
   - Use trusted file sources only

### For Developers

1. **Code Security**
   - Follow secure coding practices
   - Validate all user inputs
   - Handle errors gracefully
   - Avoid hardcoded credentials

2. **Build Security**
   - Use official PowerShell modules
   - Verify dependencies
   - Sign executables when possible
   - Regular security audits

## Known Security Considerations

### Current Implementation

- ✅ **Local Processing**: No network communication required
- ✅ **No Data Collection**: No telemetry or user data transmission
- ✅ **Sandboxed Execution**: Runs in user context only
- ✅ **Input Validation**: Basic file type and path validation
- ⚠️ **Code Signing**: Executables are not currently code-signed
- ⚠️ **Privilege Escalation**: Some features may require admin rights

### Potential Risks

1. **File System Access**: Application has access to user's file system
2. **PowerShell Execution**: Runs PowerShell scripts with user privileges
3. **Windows SmartScreen**: May show warnings for unsigned executables
4. **Antivirus Detection**: May trigger false positives due to PS2EXE conversion

## Security Features

### Built-in Protections

- **Input Sanitization**: File paths and names are validated
- **Error Handling**: Prevents information disclosure through error messages
- **Resource Limits**: Prevents excessive memory or CPU usage
- **Safe File Operations**: Uses .NET file handling APIs

### Planned Enhancements

- [ ] **Code Signing**: Digital signing of executables
- [ ] **Hash Verification**: Provide SHA-256 hashes for downloads
- [ ] **Enhanced Validation**: Stronger input validation
- [ ] **Audit Logging**: Optional security event logging
- [ ] **Least Privilege**: Run with minimal required permissions

## Vulnerability Disclosure Policy

### Our Commitment

- We will acknowledge receipt of vulnerability reports
- We will provide regular updates during investigation
- We will credit researchers in security advisories (if desired)
- We will work to resolve issues promptly

### Scope

**In Scope:**
- Code execution vulnerabilities
- Privilege escalation issues
- Information disclosure
- File system manipulation outside intended directories
- Memory corruption issues

**Out of Scope:**
- Issues requiring physical access to the machine
- Social engineering attacks
- Denial of service attacks on user's own machine
- Issues in third-party dependencies (report to respective projects)

## Security Resources

### External Tools
- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/security)
- [Windows Security Guidelines](https://docs.microsoft.com/en-us/windows/security/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Security Contacts
- General Security: `security@bokconverter.example.com`
- Project Lead: Contact through GitHub issues for non-security matters

---

## سياسة الأمان

### 🔒 الإبلاغ عن الثغرات الأمنية

إذا اكتشفت ثغرة أمنية، يرجى:

1. **لا تنشئ** مشكلة عامة للثغرات الأمنية
2. أرسل بريد إلكتروني إلى: `security@bokconverter.example.com`
3. تضمين معلومات مفصلة عن الثغرة
4. امنح ما يصل إلى 48 ساعة للرد الأولي

### الممارسات الأمنية الأفضل للمستخدمين

1. **حمل فقط من المصادر الرسمية**
2. **حافظ على نظامك محدثاً**
3. **انسخ الملفات المهمة احتياطياً قبل التحويل**
4. **استخدم مصادر ملفات موثوقة فقط**

### الاعتبارات الأمنية الحالية

- ✅ **معالجة محلية**: لا يتطلب اتصال بالشبكة
- ✅ **لا جمع بيانات**: لا إرسال بيانات أو قياس عن بُعد
- ✅ **تنفيذ محدود**: يعمل في سياق المستخدم فقط
- ⚠️ **توقيع الكود**: الملفات التنفيذية غير موقعة حالياً

---

**نحن ملتزمون بالحفاظ على أمان مستخدمينا ومعلوماتهم.**