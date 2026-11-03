# GitHub deposu ve Windows Release

GitHub CLI (`gh`) kurulu ve hesabınızda oturum açıkken RingKi klasöründe çalıştırın:

```sh
gh auth login
gh repo create RingKi --public --source . --remote origin --push
git tag v0.1.0
git push origin v0.1.0
```

Etiket gönderilince `.github/workflows/build.yml` Windows x86 derlemesini yapar, `RingKi-Windows-x86.zip` taşınabilir paketini ve `RingKi-Setup-Windows-x86.exe` kurulum dosyasını oluşturur, ikisini SHA-256 dosyalarıyla birlikte GitHub Release'e ekler. Derleme tamamlanınca GitHub deposunda **Actions** iş akışının başarılı olduğunu ve **Releases** sayfasında dört paketin bulunduğunu kontrol edin.

Bu proje Windows 7 SP1 uyumlu olacak şekilde Win32 API ve x86 hedefiyle hazırlanmıştır. Gerçek Windows 7 bilgisayarda deneme yapılmadan uyumluluk doğrulanmış sayılmaz.
