<h1 align="center">TANNING BED</h1>

## Grup SSF 16
- Rizqi Zaidan (2206059342)
- Lavly Rantissa Zunnuraina Rusdi (2206830624)
- Kevin Raihan (2206059704)
- Muhammad Nadhif Fasichul Ilmi (2206813416)

## Daftar Isi
- [Introduction to the problem and the solution](#introduction-to-the-problem-and-the-solution)
  - [Pernyataan Masalah](#pernyataan-masalah)
  - [Solusi](#solusi)
- [Hardware design and implementation details](#hardware-design-and-implementation-details)
  - [Komponen Perangkat Keras](#komponen-perangkat-keras)
  - [Implementasi Hardware](#implementasi-hardware)
- [Software implementation details](#software-implementation-details)
- [Test results and performance evaluation](#test-results-and-performance-evaluation)
  - [Hasil Pengujian](#hasil-pengujian)
  - [Metode Evaluasi Kinerja](#metode-evaluasi-kinerja)
- [Conclusion and future work](#conclusion-and-future-work)
  - [Kesimpulan](#kesimpulan)
  - [Future Work](#future-work)

## Introduction to the problem and the solution
### Pernyataan Masalah
Penggunaan tanning bed untuk mendapatkan kulit yang lebih gelap semakin populer, terutama di daerah dengan sinar matahari terbatas atau selama musim dingin. Namun, penggunaan tanning bed yang tidak tepat dapat menyebabkan masalah kesehatan serius seperti kanker kulit dan penuaan dini. Oleh karena itu, diperlukan sebuah tanning bed yang dapat memastikan keselamatan user sekaligus memberikan pengalaman tanning yang efektif.

### Solusi
Proyek TANNING BED bertujuan untuk merancang dan mengimplementasikan tanning bed yang dilengkapi dengan sensor dan otomatisasi untuk memastikan keselamatan user dan mengoptimalkan sesi tanning. Proyek ini menggabungkan komponen perangkat keras dan perangkat lunak untuk memantau dan mengontrol proses tanning, memberikan pengalaman tanning yang lebih aman dan efisien.

## Hardware design and implementation details
### Komponen Perangkat Keras
1. **Arduino Uno**
2. **DHT11**
3. **Button**
4. **Resistor**
5. **Kabel Jumper**
6. **MAX7219**
7. **Buzzer**
8. **Motor driver**

### Implementasi Hardware
Hardware dirancang dengan tujuan untuk menunjang ide proyek Tanning Bed serta memenuhi kriteria proyek akhir dari Praktikum Sistem Siber Fisik. Maka bahasa Assembly merupakan bahasa utama yang digunakan dalam pemrograman software dari Tanning Bed. Untuk dapat menjalankan kode diperlukan implementasi hardware, maka kami pertama membuat rangkaian Tanning Bed secara virtual menggunakan software Proteus. Rangkaian yang dibuat memiliki 5 button dengan label masing masing yaitu ‘START’, ‘STOP’, ‘10 Menit’, ‘20 Menit’, dan ‘30 Menit’. Mekanisme Tombol ‘STOP’ menggunakan penerapan Interrupt (Modul 7). DHT11 digunakan untuk mengukur suhu dari dalam Tanning Bed, namun pada rangkaian digunakan untuk mengukur suhu ruangan (Sensor Modul 9) karena tidak adanya implementasi pemanas atau heater. Rangkaian menggunakan Serial Port pada implementasinya (Modul 4). Rangkaian juga menggunakan 7-Segment Display yang menunjukkan timer dan suhu diukur dari sensor. Timer merupakan count-up (Timer Modul 6) yang menyesuaikan tombol opsi waktu yang ditekan user, perhitungan timer merupakan implementasi operasi aritmatika pada assembly (Modul 5). Seluruh komponen di-program menggunakan bahasa assembly (Modul 2).

Tanning Bed yang dirancang memiliki 5 button, user pertama akan menekan 1 dari 3 tombol opsi yang disediakan yaitu 10 Menit, 20 Menit, atau 30 Menit, tombol ini menentukan durasi Timer dari Tanning Bed menyalah dan melakukan count up jika tidak ada interrupt. Tombol START ditekan setelah memilih opsi untuk memulai timer, tombol STOP dapat ditekan untuk menginisiasi interrupt dan memberhentikan timer yang sedang jalan. DHT11 mengukur suhu Tanning Bed. 7-Segment Display akan menunjukkan suhu dari Tanning Bed dan timer yang berjalan, jika suhu mencapai 30 derajat celcius maka akan dilakukan interrupt dan timer mati. Jika timer mati, lampu LED hijau akan menyalah, servo menutup kasur dan buzzer berbunyi. Jika timer hidup, lampu LED merah akan menyalah, buzzer berhenti berbunyi, dan servo membuka kasur.

## Software implementation details
Berdasarkan kode, fungsi SPI_MAX7219_init berfungsi untuk melakukan inisialisasi yang mengatur mode SPI dan mengirim beberapa perintah dan data ke MAX7219, chip yang mengendalikan display tujuh segmen. Fungsi ini mempersiapkan pengaturan awal sebelum display dapat digunakan. Fungsi uptime_logic bertanggung jawab untuk mengatur dan mengirimkan data waktu (menit, detik) ke display MAX7219. Fungsi inc_MSD berfungsi untuk mengatur peningkatan digit MSD (Most Significant Digit) yaitu detik hingga 60, fungsi inc_min berfungsi untuk mengatur peningkatan digit menit hingga 10 menit, dan fungsi inc_min2 berfungsi untuk mengatur peningkatan digit menit puluhan sesuai button yang dipilih. Fungsi send_bytes digunakan untuk mengirimkan byte perintah dan data ke MAX7219 melalui komunikasi SPI. Fungsi delay_timer1 digunakan untuk membuat penundaan selama 1 detik menggunakan Timer 1 dan diaplikasikan fungsi uptime_logic untuk membuat timer detik berjalan naik. Fungsi delay_timer0 digunakan untuk membuat penundaan sebesar 10 detik menggunakan Timer 0 dan diaplikasikan ke dalam DHT11_reading untuk memberikan delay dalam pembacaan sensor.

Fungsi convtemp bertanggung jawab untuk mengkonversi dan mengirimkan suhu dalam format desimal ke MAX7219. Fungsi ini melakukan konversi dari byte suhu menjadi digit-desimal dan mengirimkannya ke display tujuan. Konversi dilakukan dengan membagi byte suhu menjadi puluhan dan satuan, kemudian mengirimkan digit-desimal tersebut ke MAX7219. Fungsi DHT11_sensor digunakan untuk membaca data dari sensor DHT11. Fungsi ini mengatur sinyal start dan response yang diperlukan untuk berkomunikasi dengan sensor. Setelah itu, fungsi membaca kelembaban dan suhu dari sensor DHT11 dan menyimpannya dalam register R13 dan R24. Fungsi DHT11_reading digunakan untuk membaca bit-bit data dari sensor DHT11. Fungsi ini mengatur waktu dan membaca sinyal dari sensor untuk mendapatkan bit-bit data yang dikirimkan. Bit-bit tersebut kemudian dikonversi menjadi byte kelembaban dan suhu yang lebih mudah dipahami. Fungsi delay_20ms digunakan untuk melakukan penundaan sebesar 20 milisekon dan diimplementasikan terhadap fungsi DHT11_sensor. Fungsi init_pin_interrupt digunakan untuk menginisialisasi pengaturan interrupt pada mikrokontroler.

Fungsi choose10, choose20, choose30 adalah fungsi yang dipanggil ketika user memilih waktu timer berjalan. Fungsi disp_space digunakan untuk menampilkan spasi pada display MAX7219. Fungsi stop digunakan untuk kembali ke kode setelah fungsi init_pin_interrupt. Fungsi shutdown_MAX digunakan untuk mematikan tanning bed yang sedang berjalan dengan tidak menampilkan apapun pada MAX7219. Fungsi init_SPI bertujuan untuk menginisialisasi modul SPI (Serial Peripheral Interface). Fungsi ini melakukan pengaturan beberapa register untuk mengkonfigurasi modul SPI sebagai master dengan prescaler fsck=fosc/16. Selain itu, fungsi ini juga mengatur intensitas segment, mode dekode, batas pemindaian, dan status on/off pada perangkat MAX7219 yang terhubung melalui SPI. Fungsi init_LED berfungsi untuk menginisalisasi port yang akan dijadikan output untuk dihubungkan dengan LED. Fungsi init_servo berfungsi untuk menginisialisasi port yang akan digunakan untuk servo, port yang dipilih merupakan port yang dapat memberikan sinyal pwm agar dapat mengatur pergerakan motor servo.

## Test results and performance evaluation
### Hasil Pengujian
Setelah dilakukan pengujian, didapatkan beberapa hasil seperti yang diinginkan namun terdapat beberapa kesalahan yang dihasilkan oleh rangkaian. Button start dan stop bekerja dengan baik serta kedua LED dan buzzer yang digunakan juga bekerja sesuai keinginan, informasi yang ditampilkan pada MAX7219 juga sudah sesuai dengan ekspektasi dan counter akan otomatis berhenti ketika suhu melebihi batas yang telah ditentukan. Namun, terdapat beberapa kesalahan di mana ketika button timer dihubungkan ke arduino maka semua button akan menjadi error termasuk button start dan stop, serta fungsionalitas dari motor servo juga tidak bekerja bagaimana semestinya. 

### Metode Evaluasi Kinerja
- **Efektivitas mekanisme keselamatan dalam mencegah overexposure dan overheating.**
- **Akurasi kontrol intensitas UV dan regulasi suhu.**
- **Umpan balik dari pengguna uji mengenai kemudahan penggunaan dan pengalaman keseluruhan.**

## Conclusion and future work
### Kesimpulan
Proyek TANNING BED berhasil menunjukkan kelayakan dari tanning bed yang meningkatkan keselamatan dan pengalaman user melalui integrasi sensor modern dan otomatisasi. Kombinasi komponen perangkat keras dan perangkat lunak menyediakan solusi efektif untuk masalah yang terkait dengan tanning bed tradisional.

### Future Work
- **Mengembangkan aplikasi user yang lebih canggih dengan fitur tambahan.**
- **Mengintegrasikan mekanisme keselamatan yang lebih maju seperti deteksi jenis kulit dan rekomendasi tanning yang dipersonalisasi.**
- **Menjelajahi potensi produksi komersial dan skalabilitas dari tanning bed.**
- **Mengoptimalkan konsumsi energi dari tanning bed untuk keberlanjutan.**
