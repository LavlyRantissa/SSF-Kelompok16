# TANNING BED

## Grup SSF 16
- Rizqi Zaidan (2206059342)
- Lavly Rantissa Zunnuraina Rusdi (2206830624)
- Kevin Raihan (2206)
- Muhammad Nadhif Fasichul Ilmi (2206813416)

## Pendahuluan Mengenai Masalah dan Solusinya
### Pernyataan Masalah
Penggunaan tanning bed untuk mendapatkan kulit yang lebih gelap semakin populer, terutama di daerah dengan sinar matahari terbatas atau selama musim dingin. Namun, penggunaan tanning bed yang tidak tepat dapat menyebabkan masalah kesehatan serius seperti kanker kulit dan penuaan dini. Oleh karena itu, diperlukan sebuah tanning bed pintar yang dapat memastikan keselamatan pengguna sekaligus memberikan pengalaman tanning yang efektif.

### Gambaran Solusi
Proyek TANNING BED bertujuan untuk merancang dan mengimplementasikan tanning bed pintar yang dilengkapi dengan sensor dan otomatisasi untuk memastikan keselamatan pengguna dan mengoptimalkan sesi tanning. Proyek ini menggabungkan komponen perangkat keras dan perangkat lunak untuk memantau dan mengontrol proses tanning, memberikan pengalaman tanning yang lebih aman dan efisien.

## Rancangan dan Implementasi Perangkat Keras
### Komponen Perangkat Keras
1. **Lampu UV**: Lampu UV dengan efisiensi tinggi untuk tanning yang terkontrol.
2. **Sensor**: Sensor UV untuk memantau intensitas radiasi UV, sensor suhu untuk memastikan kenyamanan pengguna, dan sensor gerak untuk mendeteksi keberadaan pengguna.
3. **Mikrokontroler**: Arduino atau mikrokontroler serupa untuk memproses data sensor dan mengontrol tanning bed.
4. **Sistem Pendingin**: Kipas atau mekanisme pendingin untuk menjaga suhu optimal.
5. **Mekanisme Keselamatan**: Saklar pemutus darurat dan pelindung.

### Desain Sirkuit
- **Sumber Daya**: Memastikan penyediaan daya yang stabil untuk semua komponen.
- **Integrasi Sensor**: Menghubungkan sensor UV, suhu, dan gerak ke mikrokontroler.
- **Sirkuit Kontrol**: Merancang sirkuit untuk lampu UV dan sistem pendingin yang dikontrol oleh mikrokontroler.
- **Fitur Keselamatan**: Mengintegrasikan saklar pemutus darurat dan mekanisme keselamatan lainnya ke dalam sirkuit.

## Rincian Implementasi Perangkat Lunak
### Firmware
Mikrokontroler diprogram dengan fitur-fitur berikut:
- **Pemrosesan Data Sensor**: Membaca data dari sensor UV, suhu, dan gerak.
- **Algoritma Kontrol**: Algoritma untuk menyesuaikan intensitas lampu UV dan sistem pendingin berdasarkan input sensor.
- **Protokol Keselamatan**: Menerapkan pemutusan darurat dan langkah-langkah keselamatan lainnya dalam firmware.
- **Antarmuka Pengguna**: Antarmuka dasar bagi pengguna untuk mengatur preferensi tanning dan melihat informasi status.

### Aplikasi Pengguna
Aplikasi mobile atau web yang menyediakan fungsionalitas berikut:
- **Kustomisasi Sesi**: Memungkinkan pengguna untuk menyesuaikan sesi tanning (durasi, intensitas, dll.).
- **Pemantauan Waktu Nyata**: Menampilkan data waktu nyata dari sensor tanning bed.
- **Pemberitahuan dan Notifikasi**: Mengirim pemberitahuan jika kondisi tidak aman atau sesi tanning selesai.

## Hasil Pengujian dan Evaluasi Kinerja
### Prosedur Pengujian
- **Pengujian Komponen**: Pengujian individu lampu UV, sensor, mikrokontroler, dan sistem pendingin.
- **Pengujian Integrasi**: Memastikan semua komponen perangkat keras berfungsi dengan baik secara bersama-sama.
- **Pengujian Perangkat Lunak**: Pengujian fitur firmware dan aplikasi pengguna.

### Metode Evaluasi Kinerja
- **Keselamatan**: Efektivitas mekanisme keselamatan dalam mencegah overexposure dan overheating.
- **Efisiensi**: Akurasi kontrol intensitas UV dan regulasi suhu.
- **Pengalaman Pengguna**: Umpan balik dari pengguna uji mengenai kemudahan penggunaan dan pengalaman keseluruhan.

### Hasil
- **Keselamatan**: Berhasil mencegah kondisi tidak aman selama pengujian.
- **Efisiensi**: Mencapai kontrol yang tepat atas intensitas tanning dan menjaga suhu yang nyaman.
- **Umpan Balik Pengguna**: Umpan balik positif tentang kemudahan penggunaan dan fitur keselamatan.

## Kesimpulan dan Pekerjaan Masa Depan
### Kesimpulan
Proyek TANNING BED berhasil menunjukkan kelayakan dari tanning bed pintar yang meningkatkan keselamatan dan pengalaman pengguna melalui integrasi sensor modern dan otomatisasi. Kombinasi komponen perangkat keras dan perangkat lunak menyediakan solusi efektif untuk masalah yang terkait dengan tanning bed tradisional.

### Pekerjaan Masa Depan
- **Antarmuka Pengguna yang Ditingkatkan**: Mengembangkan aplikasi pengguna yang lebih canggih dengan fitur tambahan.
- **Fitur Keselamatan Lanjutan**: Mengintegrasikan mekanisme keselamatan yang lebih maju seperti deteksi jenis kulit dan rekomendasi tanning yang dipersonalisasi.
- **Skalabilitas**: Menjelajahi potensi produksi komersial dan skalabilitas dari tanning bed pintar.
- **Efisiensi Energi**: Mengoptimalkan konsumsi energi dari tanning bed untuk keberlanjutan.

README.md ini menyediakan gambaran menyeluruh mengenai proyek TANNING BED, yang mencakup masalah, solusi, implementasi perangkat keras dan perangkat lunak, hasil pengujian, serta pekerjaan masa depan.
