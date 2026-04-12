# HMS - Web Arayüzü (HotelUI)

Bu klasör, sistemin Python/Flask tabanlı kullanıcı arayüzünü içerir.

## 🛠️ Kurulum

### 1. Gereksinimlerin Yüklenmesi
Önce gerekli kütüphaneleri yükleyin:
```bash
pip install flask mysql-connector-python python-dotenv
```

### 2. Veritabanı Kurulumu
MySQL üzerinde `setup.sql` dosyasını çalıştırarak veritabanı şemasını oluşturun ve örnek verileri yükleyin.

### 3. Ortam Değişkenleri (.env)
Klasör içerisinde bir `.env` dosyası oluşturun ve kendi bilgilerinizle doldurun:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=sifreniz
DB_NAME=hotel_management
SECRET_KEY=rastgele_anahtar
```

## 🚀 Çalıştırma
Uygulamayı başlatmak için:
```bash
python app.py
```
Ardından tarayıcınızdan `http://127.0.0.1:5000` adresine gidebilirsiniz.

## 👤 Test Kullanıcıları
- **İşveren:** Rol: `Employer`, ID: `1`
- **Müşteri:** Rol: `Customer`, ID: `3` (Mehmet Demir)
