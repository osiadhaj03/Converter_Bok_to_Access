#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
سكريپت تشخيص مبسط لـ MySQL
"""

import mysql.connector
import json
import traceback

def simple_test():
    """اختبار مبسط للاتصال"""
    
    try:
        # قراءة الإعدادات
        with open("db_settings.json", 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        print(f"✅ تم قراءة إعدادات الاتصال")
        print(f"   الخادم: {config.get('host')}")
        print(f"   المنفذ: {config.get('port')}")
        print(f"   قاعدة البيانات: {config.get('database')}")
        print(f"   المستخدم: {config.get('user')}")
        
        # إعداد الاتصال
        connection_params = {
            'host': config.get('host', '127.0.0.1'),
            'port': config.get('port', 3306),
            'database': config.get('database'),
            'user': config.get('user'),
            'ssl_disabled': True,
            'auth_plugin': 'mysql_native_password'
        }
        
        if config.get('password'):
            connection_params['password'] = config['password']
        
        print(f"\n🔄 محاولة الاتصال...")
        
        # الاتصال
        conn = mysql.connector.connect(**connection_params)
        print(f"✅ نجح الاتصال!")
        
        # اختبار استعلام
        cursor = conn.cursor()
        cursor.execute("SELECT 'Connection successful' as result")
        result = cursor.fetchone()
        print(f"✅ نجح تنفيذ الاستعلام: {result[0]}")
        
        cursor.close()
        conn.close()
        
        return True
        
    except FileNotFoundError:
        print("❌ ملف الإعدادات غير موجود")
        return False
        
    except json.JSONDecodeError as e:
        print(f"❌ خطأ في قراءة ملف JSON: {e}")
        return False
        
    except mysql.connector.Error as e:
        print(f"❌ خطأ MySQL:")
        print(f"   الكود: {e.errno if hasattr(e, 'errno') else 'غير معروف'}")
        print(f"   الرسالة: {e}")
        
        if hasattr(e, 'errno'):
            if e.errno == 2059:
                print("\n💡 حل مقترح: شغل هذا الأمر في MySQL:")
                print("   ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';")
            elif e.errno == 1045:
                print("\n💡 خطأ في المصادقة - تحقق من اسم المستخدم وكلمة المرور")
            elif e.errno == 2003:
                print("\n💡 تأكد من أن MySQL يعمل على المنفذ 3306")
        
        return False
        
    except Exception as e:
        print(f"❌ خطأ عام: {e}")
        print(f"تفاصيل الخطأ:")
        traceback.print_exc()
        return False

if __name__ == "__main__":
    print("🚀 فحص اتصال MySQL المبسط")
    print("=" * 40)
    
    success = simple_test()
    
    print("\n" + "=" * 40)
    if success:
        print("✅ الاتصال يعمل بشكل صحيح!")
    else:
        print("❌ فشل في الاتصال")
