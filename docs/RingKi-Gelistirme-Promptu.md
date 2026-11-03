# RingKi — Uygulamayı geliştirecek yapay zekâ için ana prompt

Aşağıdaki isteği baştan sona uygula. Sadece öneri, taslak, ekran maketi veya yapılacaklar listesi verme: çalışan uygulamayı, kaynak kodunu, Windows EXE derlemesini, GitHub deposunu, belgeleri ve sürümleme akışını tamamla. Bir adım teknik olarak mümkün değilse bunu açıkça yaz, eldeki en iyi çalışan alternatifi uygula ve doğrulanmayan özelliği tamamlanmış gibi gösterme.

## Rolün ve hedefin

Windows masaüstü uygulamaları, eski Windows sürümleri, yerel ses oynatma, zamanlayıcı güvenilirliği, erişilebilir arayüz ve GitHub Actions konularında deneyimli bir yazılım mühendisi gibi çalış.

**Ürün adı:** RingKi
**Ürün tanımı:** Okullar için internetsiz çalışan, günlük ders zili ve tören seslerini zamanında oynatan, kurulumsuz ve çok düşük sistem kaynağı kullanan masaüstü programı.
**Arayüz dili:** Öncelikle Türkçe. Tarih biçimi gg.aa.yyyy, saat 24 saatlik. Türkçe karakterler ve Windows kullanıcı/klasör yolları sorunsuz çalışmalı.

## Zorunlu hedef makine ve uyumluluk

Ekli bilgisayar ekran görüntüsündeki hedef makine:

- Windows 7 Ultimate Service Pack 1, 64 bit
- Intel Pentium Dual-Core E6600, yaklaşık 3.06 GHz, 2 çekirdek
- 4 GB RAM

Program ayrıca Windows 7 SP1 32 bit ve 64 bit üzerinde çalışabilecek biçimde tasarlansın. Öncelik **32 bit x86 taşınabilir EXE** olsun; 32 bit Windows’ta da açılabilsin. AVX, SSE4, GPU, internet veya modern işlemci özellikleri isteme. Eski bilgisayarda boşta CPU ve bellek kullanımı çok düşük olsun; sürekli hızlı döngü, animasyon, tarayıcı motoru veya arka planda ağ bağlantısı kullanma.

Bu bilgisayarda ayrıca çalışma zamanı kurulamayacağını ve yanına DLL kopyalanamayacağını varsay:

- Electron, Chromium, WebView2, Windows App SDK, WinUI, .NET, Java, Python çalışma zamanı, Qt çalışma zamanı, VC++ Redistributable veya başka bir runtime isteme.
- Harici codec, font paketi, servis, yönetici yetkisi, internet bağlantısı veya yükleyici gerektirme.
- Yerel Win32 masaüstü arayüzü kullan. Hedef Windows sürümünü derleme ayarlarında Windows 7 SP1 (6.1.7601) olarak belirt; Windows 8/10/11’de eklenen API’lere bağlanma.
- Dış bağımlılık gerekiyorsa yalnızca kaynak kodu projeye dahil edilen, lisansı uygun bir kitaplık kullan ve uygulamayla statik olarak EXE içine derle. Yanında ayrı DLL bırakma.
- Windows’un kendi kurulumunda bulunan sistem DLL’leri/API’leri normaldir. Ancak uygulamanın başka bir bilgisayara kopyalanan klasöründe üçüncü taraf DLL bulunmasın. Çıkan EXE’nin bağımlılıklarını otomatik denetleyen bir CI adımı ekle; harici veya Windows 7’de bulunmayan DLL/API import’u varsa derlemeyi başarısız say.
- Çalıştırılabilir dosyanın Windows 7’de gerçekten açıldığını temiz bir Windows 7 SP1 sanal makinesinde veya fiziksel makinede doğrulamadan “Windows 7’de test edildi” deme. VM yoksa bu sınırlamayı README’de dürüstçe belirt ve EXE’nin statik bağımlılık/import denetimini yine de uygula.
- Güncel araç zincirinin ürettiği dosyanın UCRT güncellemesi, Visual C++ Runtime veya sonradan kurulmuş DLL gerektirmediğini kanıtla. Bunu varsayma; EXE import tablosunu incele ve raporla.
- MP3 çözümü için MP3 kod çözücüsünü EXE içine statik derle (ör. lisans koşulları uygun, küçük ve saf yazılım çözücüsü). Ses çıkışı için Windows 7’de bulunan yerleşik Win32/WinMM ses API’lerini kullan. Seçilen çözümün lisansını depoya ekle. MP3 çalmak için makinedeki harici codec’in varlığına güvenme.
- WAV için en az PCM WAV desteği ver. MP3 ve WAV dosyalarını belleğin tamamına yüklemek yerine parça parça çöz/oynat; uzun dosyalarda bellek tüketimi sınırlı kalsın.
- macOS üzerinde kaynak kodu geliştirmesi yapılabilsin; Windows EXE’si GitHub Actions’ın Windows derleyicisinde üretilebilsin. Mac’te Windows programını çalıştırabildiğini iddia etme.

Teknoloji seçimini bu kısıtlara göre yap. Başlangıç varsayımı C/C++ ile klasik Win32 API’dir. Nihai araç zincirini seçerken Windows 7’de çalışan örnek bir minimal EXE oluştur, bağımlılık tablosunu denetle ve gerekçeni README’de açıkla. Daha modern ve rahat bir çerçeveyi sırf geliştirmesi kolay olduğu için seçme.

## Uygulama işlevleri

### 1. Ana ekran

- Gerçek sistem saati, gün/tarih ve büyük okunaklı geri sayımla sıradaki zil.
- Bugünün zil programı; tamamlanan, sıradaki ve pasif olaylar farklı, anlaşılır durumlarla gösterilsin.
- “Zili şimdi çal”, “sesi dene”, “programı bugün duraklat”, “sessize al” ve “programı etkinleştir” hızlı işlemleri.
- Oynatma sırasında hangi sesin çaldığını, kalan süreyi ve durdur düğmesini göster.
- Uygulamanın zamanlayıcısı çalışmıyorsa veya ses dosyası bulunamıyorsa görünür bir hata durumu göster.

### 2. Ders programı ve ziller

- Haftanın günlerine göre ayrı program; okulun kullandığı günleri seçebilme.
- Her olay için saat, ad, ses veya ses sırası, ses düzeyi, etkin/pasif durumu, açıklama ve isteğe bağlı tekrar/son tarih.
- Aynı gün birden fazla zil, öğle arası, yarım gün ve vardiyalı (sabah/öğleden sonra) çalışma.
- Hızlı ders programı oluşturucu: ilk ders saati, ders süresi, kısa/uzun teneffüs, öğle arası kaçıncı dersten sonra, teneffüs süreleri ve ders sayısı girilsin; oluşan saatler tabloya uygulansın. Oluştuktan sonra her saat elle düzenlenebilsin.
- Birden fazla program profili (ör. normal gün, sabahçı, öğlenci, sınav günü) ve tek tıklamayla profil değiştirme.
- Olayları kopyalama, sıraya göre taşıma, toplu etkinleştirme/devre dışı bırakma.
- Dakika hassasiyetinde planlama. Zamanlayıcı CPU tüketmeden çalışsın; uyku/uyanma, uygulama açılışı ve sistem saatinin değişmesi durumlarında aynı olayı iki kez çalmasın.
- Bilgisayar kapalı/uykuda iken kaçan zili varsayılan olarak sonradan çalma. Kaçırılan olayı kayda geçir; kullanıcıya açıkça bildir. Gecikmiş olayı çalma davranışını ayardan değiştirmek gerekiyorsa seçenek ve güvenli varsayılan sun.
- İki olay aynı zamana gelirse tanımlı bir çakışma kuralı uygula (öncelik, sıraya alma veya birleştirme); aynı anda kontrolsüz iki ses başlatma.

### 3. Törenler: İstiklal Marşı ve saygı duruşu

- Hazır bir **tören profili** ve ayrı bir **İstiklal Marşı ses alanı** oluştur.
- Varsayılan örnek akış: isteğe bağlı kısa uyarı sesi → ayarlanabilir saygı duruşu sessizliği ve geri sayımı → kullanıcının eklediği İstiklal Marşı kaydı. Bu akışın adımları, süreleri, sırası, ses seviyesi ve ses dosyası kullanıcı tarafından değiştirilebilsin.
- Saygı duruşu süresini veya tören biçimini mevzuat gibi sabit ve değiştirilemez sunma; okulun kendi uygulamasına göre ayarlanabilir kıl.
- Tören profili haftalık programa bağlanabilsin ve elle başlatılıp durdurulabilsin. Geri sayım görünür olsun.
- Telifli/izin gerektiren bir İstiklal Marşı kaydını depoya gömme veya internetten indirip uygulamaya ekleme. Kullanıcı kendi yetkili MP3/WAV dosyasını eklesin. Depoda yalnızca uygulama tarafından üretilmiş veya açık lisanslı örnek sesler bulunsun.

### 4. Ses kütüphanesi ve MP3 ekleme

- Dosya seç penceresiyle MP3 ve PCM WAV ekleme; Türkçe karakter ve boşluk içeren yolları destekleme.
- Kullanıcı isterse eklediği dosyayı RingKi veri klasörüne kopyalasın; dışarıdaki dosyayı izleme seçeneği de sun. Kaynağı silinmiş/taşınmış dosyayı bozuk durumuyla göster ve yeniden buldur.
- Ses kütüphanesinde ad, süre, tür, dosya adı, etiket/kategori ve ön dinleme. Ses denemesi sırasında durdur ve ses düzeyi kontrolü.
- Ses ekle, yeniden adlandır, kategorile, favorile, kaldır. Bir programa bağlı bir ses silinmek istenirse önce uyar ve değişiklik yapmadan hangi olayların etkileneceğini göster.
- EXE içine gömülü, kısa ve telifsiz örnek sesler: tek kısa zil, çift zil, uzun zil, yumuşak çan ve ders bitti tonu. Bunları küçük yazılım tonları olarak kendin üret veya lisansı açık örnek kullan; telifli müzik ekleme.
- Ses çıkışı başarısızsa zamanlayıcıyı kilitleme; kullanıcıya anlaşılır hata ver, kayda yaz ve sonraki olayları çalışır durumda tut.
- Çıkış cihazı olarak sistemin varsayılan ses aygıtı yeterlidir; makinede yeni sürücü/aygıt yazılımı kurmayı gerektirme.

### 5. Tatiller ve istisnalar

- Tarih aralığı veya tek tarih için tatil, kar tatili, sınav, yarım gün, etkinlik ve telafi günü tanımlama.
- İstisnanın hangi program profilini kullanacağını seçebilme; normal programı bir gün veya tarih aralığı boyunca devre dışı bırakma.
- Her yıl tekrar eden tarihleri destekle. Değişen takvimli tatilleri kendiliğinden internetten bulduğunu iddia etme; kullanıcı elle ekleyebilsin.
- İstisnaları CSV olarak içe/dışa aktar; hatalı satırları satır numarasıyla raporla ve içe aktarım öncesi önizleme göster.

### 6. Ayarlar, başlangıç ve veri güvenliği

- İsteğe bağlı Windows kullanıcı oturumu açıldığında başlatma ve sistem tepsisinde çalıştırma. Servis kurma, yönetici yetkisi isteme veya başka kullanıcıların kayıt defterini değiştirme.
- Başlangıçta normal pencereyi aç/gizle tercihi; tepsi menüsünden aç, geçici sustur, programı duraklat, hemen çal ve çıkış.
- İsteğe bağlı Windows açılışında zamanlama aktif olsun. Uygulamanın oturum açılmadan önce zil çalamayacağını net şekilde belgele.
- Veriyi kullanıcı profilinde güvenli bir klasörde tut; portable mod istenirse EXE yanındaki data klasörünü kullan. Yazma izni yoksa açıklayıcı mesaj göster. Dosya yollarını sabit disk harfi varsayımıyla saklama.
- Program, programlar ve ayarlar için yedek al/geri yükle. Dosyaya atomik yaz; kapanma veya elektrik kesintisinde son sağlam kayıt korunabilsin. Veri biçimini sürümle ve ileride yükseltme yolu bırak.
- Olay günlüğü: planlanan zil çaldı/atlanmış/çalınamadı, uygulama başlatıldı/kapatıldı, ses dosyası kayıp. Yerel metin/CSV, küçük boyutlu ve döndürülür log; öğrenci veya kişisel veri toplama.
- Varsayılan sessiz çalışma; reklam, telemetri, hesap, bulut, otomatik güncelleme, internet isteği ve analitik yok. Sistem saatini kendiliğinden değiştirme.
- Ayarlar ve yedeklerin dosya izinlerini gözet; uygulamayı standart kullanıcı olarak çalıştır.

### 7. Arayüz ve erişilebilirlik

- Windows 7’nin klasik masaüstünde çalışan sade, güven veren, gözü yormayan bir tasarım. Bu depodaki RingKi logosunu ve ikonunu kullan.
- Ana menü: Genel Bakış, Zil Programı, Sesler, Törenler, Tatil/İstisna, Kayıtlar, Ayarlar.
- En az 1024×768 çözünürlükte kullanılabilir; pencereler yeniden boyutlandırılabilsin. Küçük ekranda içerik taşarsa kaydırma alanı kullan.
- Türkçe Unicode; tarih/saat biçimi sistem bölgesine uygun, saat girişi 24 saat.
- Klavye ile gezinme, anlaşılır odak göstergesi, ikonların yanında metin etiketi, yeterli kontrast, renk dışında metin/şekille durum anlatımı.
- Yalnızca anlamlı yerlerde onay sor; yanlışlıkla programı tümden kapatmayı önle. Fazla animasyon/şeffaflık kullanma. Eski bilgisayarda hızlı açılmalı ve ana ekrana geç gelmemeli.

## Mimari, kalite ve doğrulama

- Zamanlayıcı, ses oynatımı, veri saklama ve arayüzü ayrı modüllere ayır; UI iş parçacığını uzun MP3 çözme veya dosya yazma işlemiyle dondurma.
- Kodda zaman/ses çakışması ve yeniden başlatma hatalarına odaklan. Saat ilerlemesini yalnızca UI yenileme sayacına bağlama; her olay için tarih + saat + profil kimliği üzerinden tekilleştirme yap.
- Tüm Windows API kullanımlarını hedef Windows 7 SP1’e göre kontrol et. Derleme hedefini ve gerekli manifesti açıkça ekle. EXE import tablosunu CI’da denetle; dış DLL, UCRT, WebView, runtime veya yalnızca yeni Windows’ta olan API görülürse build geçmesin.
- Birim testleri: saat sırası ve gece yarısı, hafta günleri, tatil/istisna, profil değişimi, yaz saati geçişi, aynı dakikadaki çakışma, tekrarlı tetiklemeyi önleme, bozuk/kayıp ses dosyası, yedek/geri yükleme ve programın kapalı olduğu sırada kaçan olay.
- GitHub Actions: push ve PR’da derleme + test + bağımlılık/import denetimi. Etiket v* olduğunda Windows x86 taşınabilir EXE’sini ve RingKi.exe, Türkçe README, lisanslar ve kullanım notlarını içeren ZIP’i GitHub Release’e koy. SHA-256 özetini üret. Üretilen EXE’nin yanında çalışması için DLL veya kurulum dosyası bırakma.
- Windows 7 VM’si yoksa bunu açıkça belgele; Windows 10/11’de başarılı derlemenin Windows 7 uyumluluğunu kanıtlamadığını söyle. Import tablosu kontrolünü ve Windows 7’de manuel doğrulama talimatlarını ekle.

## GitHub deposu ve teslim

- Mevcut çalışma klasöründe başka bir proje varsa onu değiştirme. RingKi için ayrı bir RingKi proje klasörü aç; mevcut Git deposunu kullanma.
- GitHub CLI (gh) kimlik doğrulamasını kontrol et. Kimlik doğrulanmışsa GitHub’da RingKi adlı yeni depo oluştur, yerel origin bağlantısını ayarla ve ilk commit’i gönder. Görünürlük belirtilmediği için depoyu varsayılan olarak **private** oluştur; public olması gerekiyorsa bunu kullanıcıdan ayrıca netleştir. GitHub kimliği yoksa yerel projeyi ve commit’i tamamla, depo oluşturulamadığını açıkça yaz ve kullanıcıya tek satırlık doğru komut ver; başarılıymış gibi davranma.
- Depoya README.md (Türkçe hızlı başlangıç, hedef sistem, kurulum/kullanım, sınırlamalar), LICENSE (MIT kaynak kodu), kullanılan üçüncü taraf kitaplıkların lisansları, örnek seslerin kaynak/lisans bilgileri, CONTRIBUTING.md, ikon/logo kaynakları, CI ve Release workflow’ları ekle.
- Uygulama için yeni, tutarlı Git geçmişi oluştur; başka projenin commitlerini veya sırlarını taşıma. .gitignore içinde build çıktıları ve kullanıcı sesleri/yedekleri dışarıda tut.
- EXE dosyasını depoya kaynak gibi commit etme; Actions artifact/Release olarak sun. Depodaki ilk README’de EXE’nin hangi Windows sürümünde gerçekten test edildiğini doğru yaz.

## Öncelik sırası

Önce Windows 7’de açılabilen en küçük gerçek uygulama iskeletini ve onun harici DLL istemeyen EXE’sini oluşturup doğrula. Sonra sırayla ses motoru, tek bir planla zamanlayıcı, veri kaydı, istisnalar/tören profili ve arayüzü tamamla. Her aşamada kodu çalışır bırak. En son import denetimi, testler, README, GitHub Actions ve Release paketlemesini bitir. Herhangi bir kısıt değişikliği gerekiyorsa bunu sessizce gevşetme; nedenini ve doğrulayabildiğin kapsamı teslim notunda belirt.

## Son teslim raporu

İş bittiğinde kısa ve kanıtlanabilir biçimde raporla:

1. GitHub repo URL’si ve görünürlüğü (oluşturulamadıysa sebebi).
2. Ana işlevler ve kaynak kodu klasörü.
3. EXE ve ZIP konumu/Release bağlantısı.
4. Build/test sonucu ve kullanılan Windows sürümü.
5. EXE import/bağımlılık denetiminin çıktısı; Windows 7’de gerçek VM testi yapıldıysa sonucu.
6. Eski makinede gerekecek herhangi bir Windows güncellemesi veya sistem bileşeni olup olmadığı. Varsa, “tek EXE” şartının karşılanmadığını açıkça belirt.
