;==============================================================
; Tanning Bed
;==============================================================

#define __SFR_OFFSET 0x00
#include "avr/io.h"
#include "avr/interrupt.h"

.global main

.org 0x0000
  RJMP main
.org 0x0002
  RJMP stop

main:
  RCALL init_pin_interrupt
  RCALL init_SPI
  RCALL init_LED   ; Inisialisasi pin LED
  RCALL init_servo ; Inisialisasi pin servo

loop:
  RCALL shutdown_MAX
  RCALL SPI_MAX7219_init
  RJMP option

backtoStart:
  RJMP loop

;==============================================================
; Memilih Opsi Timer
;==============================================================
;------------------ Pengecekan Button Opsi -------------------
option:
  SBIC PIND,4
  RJMP choose10
  SBIC PIND,5
  RJMP choose20
  SBIC PIND,6
  RJMP choose30
  RJMP option

;------------------ Opsi 10 Menit -------------------
choose10:
  LDI R25,1
  MOV R10,R25
  LDI R17, 0x05
  LDI R18, 1
  RCALL send_bytes
  RJMP waitStart

;------------------ Opsi 20 Menit -------------------
choose20:
  LDI R25,2
  MOV R10,R25
  LDI R17, 0x05
  LDI R18, 2
  RCALL send_bytes
  RJMP waitStart

;------------------ Opsi 30 Menit -------------------
choose30:
  LDI R25,3
  MOV R10,R25
  LDI R17, 0x05
  LDI R18, 3
  RCALL send_bytes
  RJMP waitStart

;==============================================================
; Menunggu Button Start Ditekan
;==============================================================
waitStart:
  CBI PORTD, PD1  ; LED merah mati
  SBI PORTD, PD0  ; LED hijau menyala
  RCALL servo_close
  SBIC PIND, 3   ; Cek apakah tombol start ditekan
  RJMP timer_running  ; Jika ya, lanjut ke logika timer (timer berjalan)
  RJMP waitStart     ; Jika tidak, tetap di dalam loop menunggu tombol start ditekan

timer_running:
  CBI PORTD, PD0  ; LED hijau mati
  SBI PORTD, PD1  ; LED merah menyala
  RCALL servo_open
  SBIC PIND, 2   ; Cek apakah tombol stop ditekan
  RJMP waitStart     ; Jika ya, kembali ke menunggu tombol start (timer berhenti)
  RJMP uptime_logic  ; Jika tidak, lanjutkan ke logika timer (timer berjalan)

;==============================================================
; Inisialisasi PIN dan Interrupt
;==============================================================

init_pin_interrupt:
  // Initialize pins D2 to D6 as input pullup
  LDI r16, 0b00000000   ; set the bit pattern for pins D2 to D6 as input with pull-up resistors enabled
  OUT DDRD, r16         ; set the DDRD register to make the pins inputs
  LDI r16, 0b01111100    ; set the bit pattern for pins D2 to D6 as input with pull-up resistors enabled
  OUT PORTD, r16        ; set the PORTD register to enable pull-up resistors on the input pins
  CLR R16

  LDI R16, (1 << ISC01)   ; Falling Edge mode source = INT0 and INT1?
  STS EICRA, R16
  SBI EIMSK, INT0		; Enable INT0
  SEI				; Enable global interrupts
  RET

;==============================================================
; Konfigurasi MAX7219
;==============================================================

;------------------ Inisialisasi MAX7219 -------------------
SPI_MAX7219_init:
  ;------------
  .equ  SCK, 5  ;clk 13
  .equ  MOSI, 3 ;din 11
  .equ  SS, 2   ;cs 10
  ;--------------------------------------------------------------
  LDI   R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
  OUT   DDRB, R17       ;set MOSI, SCK, SS as o/p
        ;--------------------------------------------------------
  LDI   R17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
  OUT   SPCR, R17       ;enable SPI as master, fsck=fosc/16
        ;--------------------------------------------------------
  LDI   R17, 0x0A       ;set segment intensity (0 to 15)
  LDI   R18, 5          ;intensity level = 8
  RCALL send_bytes      ;send command & data to MAX7219
        ;--------------------------------------------------------
  LDI   R17, 0x09       ;set decoding mode command
  LDI   R18, 0b11011111 ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
        ;--------------------------------------------------------
  LDI   R17, 0x0B       ;set scan limit command
  LDI   R18, 0x07      ;8 digits connected to MAX7219
  RCALL send_bytes      ;send command & data to MAX7219
        ;--------------------------------------------------------
  LDI   R17, 0x0C       ;set turn ON/OFF command
  LDI   R18, 0x01       ;turn ON MAX7219
  RCALL send_bytes      ;send command & data to MAX7219
        ;--------------------------------------------------------
  RET
  
;------------------ Inisialisasi SPI untuk reset -------------------
init_SPI:
  .equ  SCK, 5  ;clk 13
  .equ  MOSI, 3 ;din 11
  .equ  SS, 2   ;cs 10
  ;--------------------------------------------------------------
  LDI   R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
  OUT   DDRB, R17       ;set MOSI, SCK, SS as o/p
        ;--------------------------------------------------------
  LDI   R17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
  OUT   SPCR, R17       ;enable SPI as master, fsck=fosc/16
  RET

;------------------ Mengirimkan data ke MAX7219 untuk ditampilkan -------------------
send_bytes:
  CBI   PORTB, SS       ;enable slave device MAX7219
  OUT   SPDR, R17       ;transmit command
        ;--------------------------------------------------------
  ll2:  
  IN    R19, SPSR
  SBRS  R19, SPIF       ;wait for byte transmission
  RJMP  ll2             ;to complete
        ;--------------------------------------------------------
  OUT   SPDR, R18       ;transmit data
        ;--------------------------------------------------------
  ll3:  
  IN    R19, SPSR
  SBRS  R19, SPIF       ;wait for byte transmission
  RJMP  ll3             ;to complete
        ;--------------------------------------------------------
  SBI   PORTB, SS       ;disable slave device MAX7219
  RET

;------------------ Untuk set semua digit menjadi 0 -------------------
shutdown_MAX:
  LDI   R17, 0x09       ;set decoding mode command
  LDI   R18, 0x00       ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
  LDI R17, 0x01
  LDI R18, 0x00
  RCALL send_bytes
  LDI   R17, 0x02       ;set decoding mode command
  LDI   R18, 0x00       ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
  LDI R17, 0x03
  LDI R18, 0x00
  RCALL send_bytes
  LDI   R17, 0x04      ;set decoding mode command
  LDI   R18, 0x00       ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
  LDI R17, 0x05
  LDI R18, 0x00
  RCALL send_bytes
  LDI   R17, 0x06       ;set decoding mode command
  LDI   R18, 0x00       ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
  LDI R17, 0x07
  LDI R18, 0x00
  RCALL send_bytes
  LDI   R17, 0x08       ;set decoding mode command
  LDI   R18, 0x00       ;decoding byte
  RCALL send_bytes      ;send command & data to MAX7219
  RET

;==============================================================
; Logika Timer
;==============================================================

uptime_logic:
  LDI R17, 0x05
  MOV R18, R10
  RCALL send_bytes

  RCALL disp_space
  LDI R25, 0
  LDI R17, 0x04
  MOV R18, R25
  RCALL send_bytes

agn3:
  LDI R29,0
  LDI R17, 0x03
  MOV R18, R29
  RCALL send_bytes

agn2:
  LDI R30,0
  LDI R17,0x02
  MOV R18, R30
  RCALL send_bytes

agn1:
  LDI R31,0
;------------------ Detik Satuan -------------------
  loopA:
  LDI R17, 0x01
  MOV R18, R31
  RCALL send_bytes
  INC R31
  CPI R31, 11
  BREQ inc_MSD
  RCALL delay_timer1
  RJMP loopA

;------------------ Detik Puluhan -------------------
inc_MSD:
  RCALL DHT11_sensor
  LDI R17, 0x02
  INC R30
  CPI R30,6
  BREQ inc_min
  MOV R18,R30
  RCALL send_bytes
  RJMP agn1

;------------------ Menit Satuan -------------------
inc_min:
  LDI R17,0x03
  INC R29
  CPI R29,10
  BREQ inc_min2
  MOV R18,R29
  RCALL send_bytes
  RJMP agn2

;------------------ Menit Puluhan -------------------
inc_min2:
  LDI R17,0x04
  INC R25
  CP R25,R10 		;CP R25,R15
  BREQ back
  MOV R18,R25
  RCALL send_bytes
  RJMP agn3

back:
  JMP backtoStart

;==============================================================
; Konfigurasi DHT11
;==============================================================

;------------------ Inisialisasi DHT11 -------------------
DHT11_sensor:
  ;-----------------------------------------------------------------
  ;agn:RCALL delay_2s      ;wait 2s for DHT11 to get ready, bisa diganti ke 3s, mungkin ini gabutuh
  ;-----------------------------------------------------------------
  ;start_signal
  ;------------
  SBI   DDRD, 7       ;pin PD7 as o/p
  CBI   PORTD, 7      ;first, send low pulse
  RCALL delay_20ms    ;for 20ms
  SBI   PORTD, 7      ;then send high pulse
  ;-----------------------------------------------------------------
  ;responce signal
  ;---------------
  CBI   DDRD, 7       ;pin PD7 as i/p
  w1: 
  SBIC  PIND, 7
  RJMP  w1            ;wait for DHT11 low pulse
  w2: 
  SBIS  PIND, 7
  RJMP  w2            ;wait for DHT11 high pulse
  w3: 
  SBIC  PIND, 7
  RJMP  w3            ;wait for DHT11 low pulse
  ;-----------------------------------------------------------------
  RCALL DHT11_reading ;read humidity (1st byte of 40-bit data)
  RCALL DHT11_reading
  RCALL DHT11_reading ;read temp (3rd byte of 40-bit data)
  MOV   R31, R24      ; memindhakan hasil pembacaan suhu ke R31
  CPI R31, 40         ; Bandingkan suhu dengan 40 derajat Celsius
  BRSH back           ; Jika suhu >= 40, menghentikan alat

  ;-----------------------------------------------------------------

  ;-----------------------------------------------------------------
  ;convert temp & humidity bytes to decimal & display on MAX7219
  ;-------------------------------------------------------------
  MOV   R28, R24		;4 line ini bakal ga butuh
      ;LDI   R29, 0x07
      ;LDI   R30, 0x06
      ;-------------------
  RCALL convtemp  ;temp in decimal
      ;-------------------
      ;MOV   R28, R25
      ;LDI   R29, 0x02
      ;LDI   R30, 0x01
      ;-------------------
      ;RCALL convtemp  ;humidity in decimal
      ;-------------------
      ;RJMP  agn           ;go back & get another sensor reading
  RET

;------------------ Membaca Temperatur DHT11 -------------------
DHT11_reading:
  LDI   R16, 8        ;set counter for receiving 8 bits
  CLR   R24           ;clear data register
      ;-------------------------------------------------------
  w4: 
  SBIS  PIND, 7
  RJMP  w4            ;detect data bit (high pulse)
  RCALL delay_timer0  ;wait 50us & then check bit value
      ;-------------------------------------------------------
  SBIS  PIND, 7       ;if received bit=1, skip next inst
  RJMP  skp           ;else, received bit=0, jump to skp
  SEC                 ;set carry flag (C=1)
  ROL   R24           ;shift in 1 into LSB data register
  RJMP  w5            ;jump & wait for low pulse
  skp:
  LSL   R24           ;shift in 0 into LSB data register
      ;-------------------------------------------------------
  w5: 
  SBIC  PIND, 7
  RJMP  w5            ;wait for DHT11 low pulse
      ;-------------------------------------------------------
  DEC   R16           ;decrement counter
  BRNE  w4            ;go back & detect next bit
  
  RET                 ;return to calling subroutine

;------------------ Menerjemahkan ke decimal dan menampilkan ke MAX7219 -------------------
convtemp:		;convert and send temperature
  ;--------------
  CLR   R26             ;set counter1, initial value 0 , ini digit ratusann atau puluhan?
  CLR   R27             ;set counter2, initial value 0 , ini digit puluhan atau satuan?
        ;--------------------------------------------------------
  l70:  
  CPI   R28, 100        ;compare R28 with 100
  Ret: 
  BRMI  l80             ;jump when R28 < 100
  INC   R26             ;increment counter1 by 1
  SUBI  R28, 100        ;R28 = R28 - 100
  RJMP  l70
        ;--------------------------------------------------------
  l80:  
  CPI   R28, 10         ;compare R28 with 10
  BRMI  dsp        ;jump when R28 < 10
  INC   R27             ;increment counter2 by 1
  SUBI  R28, 10         ;R28 = R28 - 10				6+5+4+3+2+1
  RJMP  l80
  RET
        ;--------------------------------------------------------  
  dsp:  
  MOV   R18, R27
  LDI   R17, 0x08        ;select digit, R29 ganti dengan 0x01
  RCALL send_bytes      ;send command & data to MAX7219
        ;--------------------------------------------------------
  MOV   R18, R28
  MOV   R17, 0x07      ;select digit, R30 ganti dengan 0x02
  RCALL send_bytes      ;send command & data to MAX7219    
        ;--------------------------------------------------------
  RET

;------------------ Menampilkan huruf C untuk Celcius -------------------
disp_space:
  LDI R17,0x06
  LDI R18,0x4E
  RCALL send_bytes
  RET
  
;=================================================================
;Delay Subroutines
;=================================================================
delay_20ms:             ;delay 20ms
  LDI   R21, 255
  l3: 
  LDI   R22, 210
  l4: 
  LDI   R23, 2
  l5: 
  DEC   R23
  BRNE  l5
  DEC   R22
  BRNE  l4
  DEC   R21
  BRNE  l3
  RET

delay_timer1: ; 1 sec delay via timer1
  .EQU value, 62498   ;62498
    ;-------------------------------------------------------
  CLR R20 ; Clear R20 to be 0
  STS TCNT1H, R20 ; Store R20 to High Byte TCNT1
  STS TCNT1L, R20 ;initialize counter TCNT1 = 0
  LDI R20, hi8(value) ; Store high byte from value to R20
  STS OCR1AH, R20 ; Store Content from R20 to OCR1AH
  LDI R20, lo8(value) ; Store low byte from value to R20
  STS OCR1AL, R20 ; Store Content from R20 to OCR1AL
    ;-------------------------------------------------------
  CLR R20 ; Clear R20 to be 0
  STS TCCR1A, R20 ; Store content from R20 to TCCR1A
  LDI R20, 0b00001100 ; Store a byte to R20
  STS TCCR1B, R20 ; CTC mode, prescaler = 256
    ;-------------------------------------------------------
  lo4:
  IN R20, TIFR1 ;get TIFR1 byte & check
  SBRS R20, OCF1A ;if OCF1=1, skip next instruction
  RJMP lo4 ;else, loop back & check OFC flag
    ;-------------------------------------------------------
  LDI R20, 1<<OCF1A 
  OUT TIFR1, R20 ;clear OCF1A and OFC1B flag
    ;-------------------------------------------------------
  CLR R20
  STS TCCR1B, R20 ;stop timer0
  RET

delay_timer0:             ;50 usec delay via Timer 0
      ;---------------------------------------------------------
  CLR   R20
  OUT   TCNT0, R20      ;initialize timer0 with count=0
  LDI   R20, 100
  OUT   OCR0A, R20      ;OCR0 = 100
  LDI   R20, 0b00001010
  OUT   TCCR0B, R20     ;timer0: CTC mode, prescaler 64
      ;---------------------------------------------------------
  l2: 
  IN    R20, TIFR0      ;get TIFR0 byte & check
  SBRS  R20, OCF0A      ;if OCF0=1, skip next instruction
  RJMP  l2              ;else, loop back & check OCF0 flag
      ;---------------------------------------------------------
  CLR   R20
  OUT   TCCR0B, R20     ;stop timer0
      ;---------------------------------------------------------
  LDI   R20, (1<<OCF0A)
  OUT   TIFR0, R20      ;clear OCF0 flag
  RET

;=================================================================
;External Interrupt
;=================================================================
stop:
  SBI EIFR, INTF0   ; Return from interrupt
  RETI

;==============================================================
; Inisialisasi Pin LED
;==============================================================
init_LED:
  LDI R16, (1<<PD0) | (1<<PD1)   ; Set PD0 dan PD1 sebagai output
  OUT DDRD, R16
  RET

;==============================================================
; Inisialisasi Pin Servo
;==============================================================
init_servo:
  LDI R16, (1<<PC0)  ; Set PC0 sebagai output untuk servo
  OUT DDRC, R16
  RET

;==============================================================
; Logika Servo
;==============================================================
servo_open:
  ; Set nilai PWM yang sesuai untuk membuka servo
  LDI R20, 180    ; Nilai PWM untuk posisi terbuka (contoh: 180 derajat)
  RCALL set_pwm   ; Panggil fungsi untuk mengatur PWM
  RET

servo_close:
  ; Set nilai PWM yang sesuai untuk menutup servo
  LDI R20, 0      ; Nilai PWM untuk posisi tertutup (contoh: 0 derajat)
  RCALL set_pwm   ; Panggil fungsi untuk mengatur PWM
  RET

;==============================================================
; Set PWM Value untuk Menggerakkan Servo
;==============================================================
set_pwm:
  ; Hitung nilai OCR1A yang sesuai untuk mengatur PWM
  ; Rumus: OCR1A = ((duty_cycle * (MAX - MIN)) / 180) + MIN
  LDI R21, 255    ; Nilai maksimum PWM (misalnya 255)
  LDI R22, 0      ; Nilai minimum PWM (misalnya 0)
  LDI R23, 180    ; Rentang sudut servo (misalnya 180 derajat)

  MUL R20, R21    ; duty_cycle * MAX
  MOV R24, R0     ; Simpan hasil perkalian ke R24
  MUL R23, R20    ; (duty_cycle * MAX) / 180
  MOV R25, R0     ; Simpan hasil pembagian ke R25
  ADD R24, R22    ; ((duty_cycle * MAX) / 180) + MIN
  ADC R25, R23

  ; Set nilai OCR1A untuk mengatur PWM
  ; OUT OCR1AH, R25 ; Atur byte tinggi OCR1A
  ; OUT OCR1AL, R24 ; Atur byte rendah OCR1A
  RET





