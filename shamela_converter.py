#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ================================
# تعليمات التشغيل:
# 1. تأكد من تثبيت الحزم المطلوبة عبر:
#    pip install pyodbc mysql-connector-python
# 2. يجب أن يكون لديك Microsoft Access ODBC Driver (عادة موجود في ويندوز أو نزله من موقع مايكروسوفت)
# 3. شغل السكريبت عبر:
#    python shamela_converter.py
# ================================

# فحص الحزم المطلوبة وإظهار رسالة واضحة إذا كانت غير مثبتة
try:
    import pyodbc
except ImportError:
    print("[خطأ] مكتبة pyodbc غير مثبتة. ثبّتها بالأمر: pip install pyodbc")
    exit(1)
try:
    import pymysql
    # تعيين PyMySQL كمحرك افتراضي لـ MySQL
    pymysql.install_as_MySQLdb()
except ImportError:
    print("[خطأ] مكتبة PyMySQL غير مثبتة. ثبّتها بالأمر: pip install PyMySQL")
    exit(1)

"""
سكريبت تحويل كتب الشاملة من Access إلى MySQL
يقوم بقراءة ملفات .accdb وتحويلها إلى قاعدة بيانات MySQL

النظام الجديد للصفحات:
- page_number: رقم الصفحة الأصلي من ملف Access (يمكن تكراره)
- internal_index: ترقيم تسلسلي فريد للصفحات (1, 2, 3, ...) لكامل الكتاب
- استخدام internal_index في ربط الصفحات مع الفصول والعمليات الداخلية
- الحفاظ على page_number للمرجعية والعرض

المطور: مساعد الذكي الاصطناعي
التاريخ: 2025 - محدث لدعم internal_index
"""

import pyodbc
import pymysql
import uuid
import os
import re
import json
from datetime import datetime
from typing import Dict, List, Optional, Tuple

# تعيين PyMySQL كمحرك افتراضي لـ MySQL
pymysql.install_as_MySQLdb()

class ShamelaConverter:
    def __init__(self, mysql_config: dict, message_callback=None):
        """
        إنشاء محول جديد
        mysql_config: قاموس يحتوي على إعدادات اتصال MySQL
        message_callback: دالة لإرسال الرسائل إلى الواجهة
        """
        self.mysql_config = mysql_config
        self.mysql_conn = None
        self.access_conn = None
        self.conversion_log = []
        self.message_callback = message_callback
        
    def log_message(self, message: str, level: str = "INFO"):
        """تسجيل رسالة في السجل"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"[{timestamp}] {level}: {message}"
        self.conversion_log.append(log_entry)
        print(log_entry)
        
        # إرسال الرسالة للواجهة إذا كان هناك callback
        if self.message_callback:
            self.message_callback(message, level)
    
    def connect_mysql(self) -> bool:
        """الاتصال بقاعدة بيانات MySQL باستخدام PyMySQL"""
        try:
            # إعداد معاملات الاتصال
            connection_params = {
                'host': self.mysql_config.get('host', '127.0.0.1'),
                'port': self.mysql_config.get('port', 3306),
                'database': self.mysql_config.get('database'),
                'user': self.mysql_config.get('user'),
                'charset': 'utf8mb4',
                'autocommit': True
            }
            
            # إضافة كلمة المرور إذا كانت موجودة
            if self.mysql_config.get('password'):
                connection_params['password'] = self.mysql_config['password']
            
            # محاولة الاتصال
            self.mysql_conn = pymysql.connect(**connection_params)
            self.log_message("تم الاتصال بقاعدة بيانات MySQL بنجاح باستخدام PyMySQL")
            
            # التحقق من هيكل قاعدة البيانات وإصلاحها
            self.check_and_fix_database_schema()
            
            return True
            
        except pymysql.Error as mysql_error:
            # معالجة خاصة لأخطاء MySQL
            error_code = mysql_error.args[0] if mysql_error.args else None
            error_msg = mysql_error.args[1] if len(mysql_error.args) > 1 else str(mysql_error)
            
            if error_code:
                full_error_msg = f"خطأ MySQL ({error_code}): {error_msg}"
            else:
                full_error_msg = f"خطأ MySQL: {error_msg}"
            
            if error_code == 2059 or "2059" in str(mysql_error):
                full_error_msg += "\n\nحلول مقترحة لخطأ 2059:"
                full_error_msg += "\n1. تأكد من أن MySQL يعمل على المنفذ الصحيح"
                full_error_msg += "\n2. تحقق من اسم المستخدم وكلمة المرور"
                full_error_msg += "\n3. قم بتحديث كلمة مرور MySQL باستخدام: ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
                full_error_msg += "\n4. أو قم بإنشاء مستخدم جديد: CREATE USER 'shamela'@'localhost' IDENTIFIED WITH mysql_native_password BY 'shamela123';"
            elif error_code == 1045:
                full_error_msg += "\n\nخطأ في كلمة المرور أو اسم المستخدم:"
                full_error_msg += "\n1. تحقق من صحة اسم المستخدم وكلمة المرور"
                full_error_msg += "\n2. تأكد من أن المستخدم له صلاحيات الوصول لقاعدة البيانات"
            elif error_code == 2003:
                full_error_msg += "\n\nلا يمكن الاتصال بخادم MySQL:"
                full_error_msg += "\n1. تأكد من أن MySQL يعمل"
                full_error_msg += "\n2. تحقق من عنوان الخادم والمنفذ"
                full_error_msg += "\n3. تأكد من إعدادات جدار الحماية"
            
            self.log_message(full_error_msg, "ERROR")
            return False
            
        except Exception as e:
            # معالجة الأخطاء العامة الأخرى
            error_msg = f"خطأ عام في الاتصال بقاعدة بيانات MySQL: {str(e)}"
            self.log_message(error_msg, "ERROR")
            return False
    
    def check_and_fix_database_schema(self):
        """التحقق من هيكل قاعدة البيانات وإصلاحها للنظام الجديد"""
        try:
            cursor = self.mysql_conn.cursor()
            
            # التحقق من وجود قيد UNIQUE على page_number
            cursor.execute("""
                SELECT CONSTRAINT_NAME 
                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
                WHERE TABLE_SCHEMA = %s 
                AND TABLE_NAME = 'pages' 
                AND COLUMN_NAME = 'page_number'
                AND CONSTRAINT_NAME LIKE '%unique%'
            """, (self.mysql_config['database'],))
            
            unique_constraints = cursor.fetchall()
            
            if unique_constraints:
                self.log_message("تم اكتشاف قيد UNIQUE على page_number - سيتم إزالته للنظام الجديد")
                
                for constraint in unique_constraints:
                    constraint_name = constraint[0]
                    try:
                        cursor.execute(f"ALTER TABLE pages DROP INDEX {constraint_name}")
                        self.log_message(f"تم إزالة القيد: {constraint_name}")
                    except Exception as drop_error:
                        self.log_message(f"تحذير: لم يتم إزالة القيد {constraint_name}: {str(drop_error)}", "WARNING")
            
            # التحقق من وجود عمود internal_index
            cursor.execute("""
                SELECT COLUMN_NAME 
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_SCHEMA = %s 
                AND TABLE_NAME = 'pages' 
                AND COLUMN_NAME = 'internal_index'
            """, (self.mysql_config['database'],))
            
            internal_index_exists = cursor.fetchone()
            
            if not internal_index_exists:
                self.log_message("إضافة عمود internal_index لجدول pages...")
                cursor.execute("""
                    ALTER TABLE pages 
                    ADD COLUMN internal_index INT NOT NULL AUTO_INCREMENT FIRST,
                    ADD PRIMARY KEY (internal_index)
                """)
                self.log_message("تم إضافة عمود internal_index بنجاح")
            
            # التحقق من أعمدة internal_index في جدول chapters
            cursor.execute("""
                SELECT COLUMN_NAME 
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_SCHEMA = %s 
                AND TABLE_NAME = 'chapters' 
                AND COLUMN_NAME IN ('internal_index_start', 'internal_index_end')
            """, (self.mysql_config['database'],))
            
            chapter_columns = [row[0] for row in cursor.fetchall()]
            
            if 'internal_index_start' not in chapter_columns:
                cursor.execute("ALTER TABLE chapters ADD COLUMN internal_index_start INT")
                self.log_message("تم إضافة عمود internal_index_start لجدول chapters")
                
            if 'internal_index_end' not in chapter_columns:
                cursor.execute("ALTER TABLE chapters ADD COLUMN internal_index_end INT")
                self.log_message("تم إضافة عمود internal_index_end لجدول chapters")
            
            self.mysql_conn.commit()
            self.log_message("تم التحقق من هيكل قاعدة البيانات وإصلاحها للنظام الجديد")
            
        except Exception as e:
            self.log_message(f"خطأ في فحص/إصلاح هيكل قاعدة البيانات: {str(e)}", "ERROR")
    
    def connect_access(self, access_file_path: str) -> bool:
        """الاتصال بقاعدة بيانات Access"""
        try:
            if not os.path.exists(access_file_path):
                self.log_message(f"ملف Access غير موجود: {access_file_path}", "ERROR")
                return False
            
            conn_str = f'DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={access_file_path};'
            self.access_conn = pyodbc.connect(conn_str)
            self.log_message(f"تم الاتصال بملف Access: {os.path.basename(access_file_path)}")
            return True
        except Exception as e:
            self.log_message(f"خطأ في الاتصال بملف Access: {str(e)}", "ERROR")
            return False
    
    def generate_uuid(self) -> str:
        """إنشاء معرف فريد UUID"""
        return str(uuid.uuid4())
    
    def clean_text(self, text: str) -> str:
        """تنظيف النص من الأحرف غير المرغوب فيها"""
        if not text:
            return ""
        
        # إزالة الأحرف الخاصة والتحكم
        text = re.sub(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]', '', str(text))
        # تنظيف المسافات الزائدة
        text = re.sub(r'\s+', ' ', text).strip()
        return text
    
    def extract_book_info(self) -> Optional[Dict]:
        """استخراج معلومات الكتاب من جدول Main"""
        try:
            cursor = self.access_conn.cursor()
            cursor.execute("SELECT * FROM Main")
            row = cursor.fetchone()
            
            if not row:
                self.log_message("لا توجد بيانات في جدول Main", "WARNING")
                return None
            
            # الحصول على أسماء الأعمدة
            columns = [column[0] for column in cursor.description]
            book_data = dict(zip(columns, row))
            
            # تنظيف البيانات
            cleaned_data = {}
            for key, value in book_data.items():
                if isinstance(value, str):
                    cleaned_data[key] = self.clean_text(value)
                else:
                    cleaned_data[key] = value
            
            self.log_message(f"تم استخراج معلومات الكتاب: {cleaned_data.get('Bk', 'غير محدد')}")
            return cleaned_data
            
        except Exception as e:
            self.log_message(f"خطأ في استخراج معلومات الكتاب: {str(e)}", "ERROR")
            return None
    
    def extract_book_content(self, table_name: str) -> List[Dict]:
        """استخراج محتوى الكتاب من جدول المحتوى مع معلومات الصفحات والمجلدات"""
        try:
            cursor = self.access_conn.cursor()
            cursor.execute(f"SELECT * FROM [{table_name}] ORDER BY id")
            
            columns = [column[0] for column in cursor.description]
            content_data = []
            
            for row in cursor.fetchall():
                row_data = dict(zip(columns, row))
                # تنظيف النص
                if 'nass' in row_data and row_data['nass']:
                    row_data['nass'] = self.clean_text(row_data['nass'])
                content_data.append(row_data)
            
            self.log_message(f"تم استخراج {len(content_data)} صف من جدول {table_name}")
            return content_data
            
        except Exception as e:
            self.log_message(f"خطأ في استخراج محتوى الكتاب من {table_name}: {str(e)}", "ERROR")
            return []
    
    def extract_book_index(self, table_name: str) -> List[Dict]:
        """استخراج فهرس الكتاب من جدول الفهرس"""
        try:
            cursor = self.access_conn.cursor()
            cursor.execute(f"SELECT * FROM [{table_name}] ORDER BY id")
            
            columns = [column[0] for column in cursor.description]
            index_data = []
            
            for row in cursor.fetchall():
                row_data = dict(zip(columns, row))
                # تنظيف العنوان
                if 'tit' in row_data and row_data['tit']:
                    row_data['tit'] = self.clean_text(row_data['tit'])
                index_data.append(row_data)
            
            self.log_message(f"تم استخراج {len(index_data)} عنصر من فهرس {table_name}")
            return index_data
            
        except Exception as e:
            self.log_message(f"خطأ في استخراج فهرس الكتاب من {table_name}: {str(e)}", "ERROR")
            return []
    
    def insert_author(self, author_name: str) -> int:
        """إدراج مؤلف جديد وإرجاع معرفه"""
        try:
            cursor = self.mysql_conn.cursor()
            
            # التحقق من وجود المؤلف
            cursor.execute("SELECT id FROM authors WHERE full_name = %s", (author_name,))
            existing = cursor.fetchone()
            
            if existing:
                return existing[0]
            
            # إدراج مؤلف جديد
            insert_query = """
                INSERT INTO authors (full_name, created_at, updated_at)
                VALUES (%s, %s, %s)
            """
            now = datetime.now()
            cursor.execute(insert_query, (author_name, now, now))
            author_id = cursor.lastrowid
            
            self.log_message(f"تم إدراج مؤلف جديد: {author_name}")
            return author_id
            
        except Exception as e:
            self.log_message(f"خطأ في إدراج المؤلف: {str(e)}", "ERROR")
            return 1  # إرجاع معرف افتراضي
    
    def insert_publisher(self, publisher_name: str) -> int:
        """إدراج ناشر جديد وإرجاع معرفه"""
        try:
            cursor = self.mysql_conn.cursor()
            
            # التحقق من وجود الناشر
            cursor.execute("SELECT id FROM publishers WHERE name = %s", (publisher_name,))
            existing = cursor.fetchone()
            
            if existing:
                return existing[0]
            
            # إدراج ناشر جديد
            insert_query = """
                INSERT INTO publishers (name, created_at, updated_at)
                VALUES (%s, %s, %s)
            """
            now = datetime.now()
            cursor.execute(insert_query, (publisher_name, now, now))
            publisher_id = cursor.lastrowid
            
            self.log_message(f"تم إدراج ناشر جديد: {publisher_name}")
            return publisher_id
            
        except Exception as e:
            self.log_message(f"خطأ في إدراج الناشر: {str(e)}", "ERROR")
            return 1  # إرجاع معرف افتراضي
    
    def insert_book(self, book_info: Dict, author_id: int, publisher_id: int) -> int:
        """إدراج كتاب جديد"""
        try:
            cursor = self.mysql_conn.cursor()
            
            # استخراج المعلومات المهمة
            title = book_info.get('Bk', 'كتاب بدون عنوان')
            description = book_info.get('Betaka', '')
            shamela_id = str(book_info.get('BkId', ''))
            
            # إنشاء slug من العنوان مع timestamp لضمان التفرد
            import re
            from datetime import datetime
            slug = re.sub(r'[^\w\s-]', '', title).strip()
            slug = re.sub(r'[-\s]+', '-', slug)
            slug = f"{slug}-{int(datetime.now().timestamp())}"
            
            # إدراج كتاب جديد دائماً
            insert_query = """
                INSERT INTO books (shamela_id, title, description, slug, publisher_id, 
                                 status, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            
            now = datetime.now()
            cursor.execute(insert_query, (
                shamela_id, title, description, slug, publisher_id,
                'published', now, now
            ))
            
            book_id = cursor.lastrowid
            self.log_message(f"تم إدراج كتاب جديد: {title}")
            return book_id
            
        except Exception as e:
            self.log_message(f"خطأ في إدراج الكتاب: {str(e)}", "ERROR")
            return 1
    
    def insert_pages_and_chapters(self, book_id: int, content_data: List[Dict], index_data: List[Dict]):
        """إدراج الصفحات والفصول مع ربط صحيح بينهما (مع مجلد افتراضي واحد فقط)"""
        try:
            cursor = self.mysql_conn.cursor()
            now = datetime.now()
            
            # إنشاء مجلد افتراضي واحد فقط لكل كتاب (مطلوب لجدول chapters)
            try:
                volume_query = """
                    INSERT INTO volumes (book_id, number, title, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s)
                """
                cursor.execute(volume_query, (book_id, 1, "المجلد الرئيسي", now, now))
                default_volume_id = cursor.lastrowid
                self.log_message(f"تم إنشاء مجلد افتراضي برقم {default_volume_id}")
            except Exception as vol_error:
                if "Duplicate entry" in str(vol_error):
                    # المجلد موجود مسبقاً، استخدم الموجود
                    cursor.execute("SELECT id FROM volumes WHERE book_id = %s AND number = 1", (book_id,))
                    existing_volume = cursor.fetchone()
                    if existing_volume:
                        default_volume_id = existing_volume[0]
                        self.log_message(f"استخدام المجلد الموجود برقم {default_volume_id}")
                    else:
                        self.log_message(f"خطأ في إنشاء المجلد: {str(vol_error)}", "ERROR")
                        return
                else:
                    self.log_message(f"خطأ في إنشاء المجلد: {str(vol_error)}", "ERROR")
                    return
            
            # 1. إدراج الفصول أولاً - سنستخدم internal_index لاحقاً للربط
            chapter_data = {}  # خريطة لحفظ معلومات الفصول {chapter_order: chapter_db_id}
            chapter_count = 0
            sorted_index = sorted(index_data, key=lambda x: x.get('id', 0))
            
            self.log_message(f"بدء معالجة {len(sorted_index)} فصل")
            
            for i, index_item in enumerate(sorted_index):
                chapter_id = index_item.get('id')
                chapter_title = self.clean_text(index_item.get('tit', f'فصل {chapter_id}'))
                chapter_level = index_item.get('lvl', 1)
                
                # تحديد نطاق الصفحات للفصل بدقة أكبر (بناءً على page_number للمرجعية فقط)
                start_page = chapter_id
                if i < len(sorted_index) - 1:
                    end_page = sorted_index[i + 1].get('id') - 1
                else:
                    # الفصل الأخير - أخذ آخر صفحة من المحتوى
                    end_page = max([item.get('page', item.get('id', 0)) for item in content_data])
                
                # إدراج الفصل مع المجلد الافتراضي
                # page_start و page_end للمرجعية فقط، الربط الفعلي سيكون بـ internal_index
                chapter_query = """
                    INSERT INTO chapters (book_id, volume_id, title, level, page_start, page_end, 
                                        `order`, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                cursor.execute(chapter_query, (
                    book_id, default_volume_id, chapter_title, chapter_level,
                    start_page, end_page, chapter_id, now, now
                ))
                
                db_chapter_id = cursor.lastrowid
                chapter_count += 1
                
                # حفظ معلومات الفصل للاستخدام لاحقاً في ربط الصفحات بـ internal_index
                chapter_data[chapter_id] = {
                    'db_id': db_chapter_id,
                    'start_page': start_page,
                    'end_page': end_page,
                    'title': chapter_title
                }
                
                self.log_message(f"فصل '{chapter_title}': page_number من {start_page} إلى {end_page} (سيتم ربطه بـ internal_index لاحقاً)")
            
            self.log_message(f"تم إدراج {chapter_count} فصل")
            
            # 2. إدراج الصفحات مع ربطها بالفصول وتوليد internal_index
            page_count = 0
            pages_without_chapter = 0
            part_stats = {}  # إحصائيات توزيع الصفحات حسب part
            internal_index_counter = 1  # عداد التسلسل الداخلي يبدأ من 1
            
            self.log_message(f"بدء معالجة {len(content_data)} صفحة مع توليد internal_index")
            
            for content_item in content_data:
                page_num = content_item.get('page', content_item.get('id', 0))  # page_number الأصلي من Access
                content_text = content_item.get('nass', '')
                
                # استخراج قيمة part من البيانات وحفظها كما هي
                part_value = content_item.get('part') or content_item.get('Part')
                if part_value is not None:
                    part_value = int(part_value) if str(part_value).strip() != '' else None
                
                # تتبع إحصائيات الأجزاء
                part_key = part_value if part_value is not None else "بدون جزء"
                if part_key not in part_stats:
                    part_stats[part_key] = 0
                part_stats[part_key] += 1
                
                # تحديد الفصل المناسب للصفحة بناءً على page_number الأصلي
                # نجد الفصل الذي يقع page_num ضمن نطاقه
                chapter_id_for_page = None
                for ch_order, ch_info in chapter_data.items():
                    if ch_info['start_page'] <= page_num <= ch_info['end_page']:
                        chapter_id_for_page = ch_info['db_id']
                        break
                
                if not chapter_id_for_page:
                    pages_without_chapter += 1
                    self.log_message(f"تحذير: الصفحة {page_num} لا تنتمي لأي فصل", "WARNING")
                
                # إدراج الصفحة: page_number تسلسلي، internal_index من Access
                try:
                    # النظام الجديد:
                    # page_number: تسلسلي تلقائي (1, 2, 3, 4...)
                    # internal_index: الرقم الأصلي من Access (للمرجعية)
                    sequential_page_number = page_count + 1
                    original_access_page = page_num  # الرقم الأصلي من Access
                    
                    page_query = """
                        INSERT INTO pages (book_id, chapter_id, page_number, internal_index, content, part, created_at, updated_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    """
                    cursor.execute(page_query, (
                        book_id, chapter_id_for_page, sequential_page_number, 
                        str(original_access_page), content_text, part_value, now, now
                    ))
                    
                    page_count += 1
                    
                    # طباعة تقدم كل 100 صفحة
                    if page_count % 100 == 0:
                        self.log_message(f"تم معالجة {page_count} صفحة (page_number: {sequential_page_number}, internal_index: {original_access_page})")
                        
                except Exception as page_error:
                    self.log_message(f"خطأ في إدراج الصفحة (access_page: {page_num}): {str(page_error)}", "ERROR")
                    # نستمر حتى لو فشلت صفحة واحدة
                    continue
            
            # طباعة الإحصائيات النهائية
            self.log_message("=== إحصائيات الربط ===")
            self.log_message(f"إجمالي الصفحات: {page_count}")
            self.log_message(f"إجمالي الفصول: {chapter_count}")
            self.log_message(f"الصفحات بدون فصل: {pages_without_chapter}")
            self.log_message(f"الصفحات المربوطة بفصول: {page_count - pages_without_chapter}")
            
            # طباعة إحصائيات توزيع الصفحات حسب part
            self.log_message("=== إحصائيات توزيع الصفحات حسب الأجزاء ===")
            for part_key in sorted(part_stats.keys()):
                count = part_stats[part_key]
                self.log_message(f"الجزء {part_key}: {count} صفحة")
            
            self.log_message(f"تم إدراج {page_count} صفحة و {chapter_count} فصل للكتاب")
            
            # 3. تحديث نطاقات الفصول لتستخدم page_number التسلسلي الجديد
            self.log_message("بدء تحديث نطاقات الفصول لاستخدام page_number التسلسلي...")
            
            for ch_order, ch_info in chapter_data.items():
                chapter_id = ch_info['db_id']
                try:
                    # البحث عن أول وآخر page_number (التسلسلي) للصفحات في نطاق الفصل
                    cursor.execute("""
                        SELECT MIN(page_number), MAX(page_number)
                        FROM pages 
                        WHERE book_id = %s AND chapter_id = %s
                    """, (book_id, chapter_id))
                    
                    result = cursor.fetchone()
                    if result and result[0] is not None:
                        page_start, page_end = result
                        
                        # تحديث الفصل بنطاق page_number التسلسلي
                        cursor.execute("""
                            UPDATE chapters 
                            SET page_start = %s, page_end = %s, updated_at = %s
                            WHERE id = %s
                        """, (page_start, page_end, now, chapter_id))
                        
                        self.log_message(f"فصل '{ch_info['title']}': page_number من {page_start} إلى {page_end}")
                    else:
                        self.log_message(f"تحذير: لم يتم العثور على صفحات للفصل '{ch_info['title']}'", "WARNING")
                        
                except Exception as chapter_update_error:
                    self.log_message(f"خطأ في تحديث الفصل {chapter_id}: {str(chapter_update_error)}", "ERROR")
            
            # 4. تحديث عدد الصفحات في جدول books
            try:
                update_book_query = """
                    UPDATE books SET page_count = %s, updated_at = %s
                    WHERE id = %s
                """
                cursor.execute(update_book_query, (page_count, now, book_id))
                self.log_message(f"تم تحديث معلومات الكتاب: {page_count} صفحة")
            except Exception as update_error:
                self.log_message(f"تحذير: لم يتم تحديث معلومات الكتاب: {str(update_error)}", "WARNING")
            
        except Exception as e:
            self.log_message(f"خطأ في إدراج الصفحات والفصول: {str(e)}", "ERROR")
    
    def convert_access_file(self, access_file_path: str) -> bool:
        """تحويل ملف Access واحد"""
        try:
            self.log_message(f"بدء تحويل ملف: {os.path.basename(access_file_path)}")
            
            # الاتصال بملف Access
            if not self.connect_access(access_file_path):
                return False
            
            # استخراج معلومات الكتاب
            book_info = self.extract_book_info()
            if not book_info:
                return False
            
            # تحديد أسماء جداول المحتوى والفهرس
            cursor = self.access_conn.cursor()
            tables = [table.table_name for table in cursor.tables(tableType='TABLE') 
                     if not table.table_name.startswith('MSys')]
            
            content_table = None
            index_table = None
            
            for table in tables:
                if table.startswith('b') and table[1:].isdigit():
                    content_table = table
                elif table.startswith('t') and table[1:].isdigit():
                    index_table = table
            
            if not content_table:
                self.log_message("لم يتم العثور على جدول المحتوى", "ERROR")
                return False
            
            # استخراج البيانات
            content_data = self.extract_book_content(content_table)
            index_data = self.extract_book_index(index_table) if index_table else []
            
            if not content_data:
                self.log_message("لا يوجد محتوى للتحويل", "WARNING")
                return False
            
            # إدراج البيانات في MySQL
            author_name = book_info.get('Auth', 'مؤلف غير معروف')
            publisher_name = book_info.get('Publisher', 'ناشر غير معروف')
            
            author_id = self.insert_author(author_name)
            publisher_id = self.insert_publisher(publisher_name)
            book_id = self.insert_book(book_info, author_id, publisher_id)
            
            self.insert_pages_and_chapters(book_id, content_data, index_data)
            
            # إغلاق الاتصال بـ Access
            self.access_conn.close()
            
            self.log_message(f"تم تحويل الملف بنجاح: {os.path.basename(access_file_path)}")
            return True
            
        except Exception as e:
            self.log_message(f"خطأ في تحويل الملف: {str(e)}", "ERROR")
            return False
    
    def convert_file(self, access_file_path: str) -> bool:
        """
        تحويل ملف واحد
        
        Args:
            access_file_path: مسار ملف Access
            
        Returns:
            bool: نجح التحويل أم لا
        """
        try:
            self.log_message(f"INFO: بدء معالجة الملف: {os.path.basename(access_file_path)}")
            
            try:
                # الاتصال بـ MySQL
                self.log_message(f"INFO: محاولة الاتصال بـ MySQL...")
                
                if not self.connect_mysql():
                    self.log_message(f"ERROR: فشل في الاتصال بـ MySQL")
                    return False
                
                # تحويل الملف
                self.log_message(f"INFO: بدء عملية التحويل الفعلية...")
                success = self.convert_access_file(access_file_path)
                
                if success:
                    self.log_message(f"INFO: تم تحويل {os.path.basename(access_file_path)} بنجاح")
                    
                    # التحقق من أن البيانات تم حفظها فعلاً
                    try:
                        cursor = self.mysql_conn.cursor()
                        cursor.execute("SELECT COUNT(*) FROM books")
                        book_count = cursor.fetchone()[0]
                        self.log_message(f"INFO: عدد الكتب في قاعدة البيانات الآن: {book_count}")
                        
                        # حفظ التغييرات
                        self.mysql_conn.commit()
                        self.log_message(f"INFO: تم حفظ التغييرات في قاعدة البيانات")
                        
                    except Exception as e:
                        self.log_message(f"ERROR: خطأ في التحقق من البيانات: {str(e)}")
                else:
                    self.log_message(f"ERROR: فشل تحويل {os.path.basename(access_file_path)}")
                
                return success
                
            finally:
                if self.mysql_conn:
                    self.mysql_conn.close()
                    self.log_message(f"INFO: تم إغلاق اتصال MySQL")
                
        except Exception as e:
            self.log_message(f"ERROR: خطأ في تحويل الملف {os.path.basename(access_file_path)}: {str(e)}")
            return False

    def convert_multiple_files(self, access_files: List[str]) -> Dict[str, bool]:
        """تحويل عدة ملفات Access"""
        results = {}
        
        if not self.connect_mysql():
            return results
        
        try:
            # بدء المعاملة
            self.mysql_conn.start_transaction()
            
            for access_file in access_files:
                file_name = os.path.basename(access_file)
                self.log_message(f"معالجة الملف: {file_name}")
                
                success = self.convert_access_file(access_file)
                results[file_name] = success
                
                if success:
                    self.log_message(f"تم تحويل {file_name} بنجاح")
                else:
                    self.log_message(f"فشل في تحويل {file_name}", "ERROR")
            
            # تأكيد المعاملة
            self.mysql_conn.commit()
            self.log_message("تم حفظ جميع التغييرات في قاعدة البيانات")
            
        except Exception as e:
            # التراجع عن المعاملة في حالة الخطأ
            self.mysql_conn.rollback()
            self.log_message(f"تم التراجع عن التغييرات بسبب خطأ: {str(e)}", "ERROR")
        
        finally:
            if self.mysql_conn:
                self.mysql_conn.close()
        
        return results
    
    def save_log(self, log_file_path: str):
        """حفظ سجل العمليات في ملف"""
        try:
            with open(log_file_path, 'w', encoding='utf-8') as f:
                f.write("\n".join(self.conversion_log))
            print(f"تم حفظ السجل في: {log_file_path}")
        except Exception as e:
            print(f"خطأ في حفظ السجل: {str(e)}")


def main():
    """الدالة الرئيسية"""
    print("=== محول كتب الشاملة من Access إلى MySQL ===")
    print("المطور: مساعد الذكي الاصطناعي")
    print("="*50)
    
    # إعدادات قاعدة البيانات MySQL
    mysql_config = {
        'host': 'srv1800.hstgr.io',
        'port': 3306,
        'user': 'u994369532_test',
        'password': 'Test20205',  # ضع كلمة المرور هنا
        'database': 'u994369532_test',
        'charset': 'utf8mb4',
        'use_unicode': True
    }
    
    # ملفات Access للتحويل
    access_files = [
        r"d:\test3\shamela_book.accdb",
        r"d:\test3\مقدمة الصلاة للفناري 834.accdb"
    ]
    
    # إنشاء المحول
    converter = ShamelaConverter(mysql_config)
    
    # تحويل الملفات
    results = converter.convert_multiple_files(access_files)
    
    # عرض النتائج
    print("\n=== نتائج التحويل ===")
    for file_name, success in results.items():
        status = "نجح" if success else "فشل"
        print(f"{file_name}: {status}")
    
    # حفظ السجل
    log_file = f"conversion_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
    converter.save_log(log_file)
    
    print(f"\nتم الانتهاء من عملية التحويل. راجع ملف السجل: {log_file}")


if __name__ == "__main__":
    main()