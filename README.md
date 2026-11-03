# RingKi

Windows için sade okul zil programı. Soldaki menüden **Bugün**, **Zil programı** ve **Sesler ve tören** bölümlerine geçilir. Zil tablosuna istenen gün ve `08:30` gibi 24 saat biçiminde bir saat eklenebilir; program yerel saatle çalışır.

## Özellikler

- Haftanın belirli gününe veya her güne zil ekleme, düzenleme ve silme
- Uygulama içi okul zili, kısa ton ve uzun ton
- 60 saniyelik sessiz saygı duruşundan sonra hazır İstiklâl Marşı kaydı
- Özel MP3/WAV zil dosyalarını içe aktarma ve çizelgedeki her olaya ayrı ses seçme; MP3, projeye gömülü minimp3 çözücüsüyle oynatılır
- Programı başlatma/durdurma; ayarlar `%APPDATA%\RingKi\program.ini` dosyasında saklanır
- Yerel Win32 arayüzü; internet, hesap, kurulum veya üçüncü taraf çalışma zamanı gerekmez

Ses, Windows'un varsayılan ses çıkışını kullanır. Zil programı yalnızca uygulama açık ve **Zil programı çalışıyor** durumundayken tetiklenir. Bilgisayar uyku/kapalı durumdayken kaçan ziller sonradan çalınmaz. Zil saati bilgisayarın yerel saatine göre değerlendirilir.

## Windows paketi

`v*` sürüm etiketi GitHub'a gönderildiğinde Actions hem kurulum gerektirmeyen `RingKi-Windows-x86.zip` dosyasını hem kullanıcı hesabına kurulan `RingKi-Setup-Windows-x86.exe` dosyasını Release'e ekler. Installer yönetici izni istemez; Başlat menüsüne kısayol ekler. Zip seçeneğinde `RingKi.exe` ve `resources` klasörünü aynı klasörde tutun. Kaynaklar ve sesler için üçüncü taraf DLL gerekmez; yalnızca Windows 7 SP1'de bulunan sistem bileşenleri kullanılır. Kullanıcı sesleri ve ayarlar `%APPDATA%\RingKi` altına yazılır; kaldırma sırasında bu kullanıcı verileri korunur.

Bu depo şu anda Windows 7 sanal makinesinde çalıştırılarak doğrulanmış değildir. CI, x86 Windows EXE'sini üretir ve import tablosunda yalnızca Windows sistem DLL'lerine izin verir. Bu denetim tek başına gerçek Windows 7 çalıştırma testinin yerine geçmez.

## Derleme

Windows üzerinde MSYS2 MinGW 32-bit toolchain ile:

```sh
make
```

Derleyici çıktısı `build/RingKi.exe` olur; çalıştırmak için `build/resources` ses klasörünü de yanında tutun. Kaynak kod macOS üzerinde düzenlenebilir; Windows EXE'sini macOS üzerinde çalıştırma iddiası yoktur. GitHub Actions, push ve pull request'lerde Windows x86 EXE'si üretir. GitHub deposunu oluşturma ve ilk Release'i tetikleme adımları [`docs/GitHub-Release.md`](docs/GitHub-Release.md) içindedir.

## Sesler ve kaynaklar

Uygulama zil tonlarını kodla üretir. İstiklâl Marşı WAV kaydı, Commons sayfasında kamu malı olarak işaretlenen ABD Deniz Kuvvetleri Bandosu performansından türetilmiştir. Dosyanın kaynağı/lisans bilgisi [`SOURCES.md`](SOURCES.md) içindedir. Sesler ekranından başka MP3/WAV kaydı seçilebilir.

## Logo

Uygulama ikonu [`resources/ringki.ico`](resources/ringki.ico) dosyasından EXE içine gömülür. SVG/PNG kaynakları [`assets/brand`](assets/brand) klasöründedir.

## Lisans

Kaynak kod MIT lisanslıdır. Gömülü MP3 çözümleyici CC0 1.0'dır; [`LICENSES`](LICENSES) klasörüne bakın. Seslerin kaynak notları `SOURCES.md` içindedir.
