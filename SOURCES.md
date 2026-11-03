# Üçüncü taraf ve ses kaynakları

## İstiklâl Marşı kaydı

- Dosya: `resources/istiklal-marsi.wav` (WAV PCM'e dönüştürülmüş mono kopya)
- Kayıt: ABD Deniz Kuvvetleri Bandosu, yaklaşık 2000; Wikimedia Commons'taki `Istiklâl Marsi instrumetal.ogg`
- Kaynak sayfası: https://commons.wikimedia.org/wiki/File:Istikl%C3%A2l_Marsi_instrumetal.ogg
- Sayfa; performansı federal görev sırasında yapılmış ABD Deniz Kuvvetleri Bandosu kaydı olarak tanımlıyor ve performans kaydını Public Domain Mark ile işaretliyor. Sayfa ayrıca İstiklâl Marşı için [9 Aralık 2010 tarihli Resmî Gazete kararına](https://www.resmigazete.gov.tr/eskiler/2010/12/20101209-2.htm) atıf veriyor.
- Dönüşüm: OGG/Vorbis'ten 22,050 Hz, 16-bit, mono PCM WAV'a. Ses içeriği düzenlenmedi.

## MP3 çözücü

`third_party/minimp3/minimp3.h` ve `minimp3_ex.h`, `lieff/minimp3` projesinin CC0 1.0 lisanslı kaynaklarıdır. Sürüm sabitlemesi ve lisans metni [`LICENSES/minimp3-CC0.txt`](LICENSES/minimp3-CC0.txt) içindedir.

## Uygulama üretimi zil sesleri

`zil.wav`, `ton-kisa.wav` ve `ton-uzun.wav`, RingKi için basit sinüs/parçalı tonlar kullanılarak üretilmiştir; üçüncü taraf örnek/kayıt içermez.
