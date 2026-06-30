# LingoLeap

Aplikasi belajar membaca untuk anak-anak Indonesia yang mengalami disleksia. Pendekatannya berbasis game — anak-anak maju lewat mini-game harian, bukan duduk dengerin pelajaran. Orang tua punya dashboard terpisah untuk memantau perkembangan anak secara nyata.

---

## Apa yang bisa dilakukan

Anak-anak melewati **peta petualangan** yang membuka satu level per hari. Setiap harinya bergiliran antara empat jenis game: menyusun huruf jadi kata, menyusun suku kata, memilih kata yang berima, dan mengidentifikasi fonem berdasarkan posisinya. Mereka mengumpulkan XP, membangun streak login, dan bisa klaim bonus reward dari quest harian setelah mendapat skor sempurna.

Orang tua masuk lewat mode terpisah yang dilindungi PIN dan bisa melihat statistik real-time — akurasi, kecepatan membaca, pengenalan huruf, kata-kata sulit — semuanya diambil dari dokumen Firestore yang sama yang ditulis oleh anak.

### Empat game yang tersedia

**Suku Kata** — ubin huruf diacak, anak mengetuk satu per satu untuk menyusun kata yang benar.

**Kosa Kata** — konsep yang sama tapi menggunakan gelembung suku kata, bukan huruf satuan.

**Rima** — diberi sebuah kata beserta gambarnya, pilih mana dari tiga pilihan yang berima dengannya.

**Fonem** — app membacakan sebuah kata lewat TTS, anak memilih huruf di posisi tertentu (depan, belakang, kedua, dst).

---

## Tech stack

- **Flutter** dengan **GetX** untuk state management dan routing
- **Firebase Auth** — email/password, login persisten
- **Cloud Firestore** — seluruh progres anak, statistik, streak, state quest
- **Firebase Storage** — upload foto profil
- **flutter_tts** — TTS bahasa Indonesia untuk game Fonem
- **image_picker** — pilih foto dari galeri untuk profil
- **shared_preferences** — preferensi suara/getaran lokal, cache PIN

---

## Cara mulai

Butuh Flutter 3.x dan project Firebase yang sudah dikonfigurasi untuk Android dan iOS.

```bash
git clone https://github.com/nalndra/LingoLeap.git
cd lingoleap
flutter pub get
```

Taruh `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS) ke folder platform masing-masing, lalu generate `firebase_options.dart`:

```bash
flutterfire configure
```

Jalankan di perangkat fisik (haptic di emulator kurang terasa — lebih baik pakai HP asli):

```bash
flutter run
```

### Firebase rules

Rules Firestore dan Storage tidak disertakan di repo ini. Minimal kamu butuh authenticated read/write pada `users/{uid}` dan `profile_photos/{uid}.jpg`.

---

## Struktur proyek

```
lib/
  main.dart                         # registrasi service, entry point app
  app/
    services/
      auth_service.dart
      child_progress_service.dart   # state reaktif terpusat untuk statistik anak
      feedback_service.dart         # haptic + feedback suara
      pin_service.dart
    modules/
      home/                         # shell dengan bottom nav + page view
      petualangan/                  # peta petualangan, logika unlock harian
      game_sukukata/
      game_kosakata/
      game_rima/
      game_fonem/
      quest/                        # quest harian, klaim XP berdasarkan rank
      progress/                     # kartu level, bar statistik, perjalanan quest
      setting/                      # edit profil, preferensi, mode orang tua
      edit_profile/                 # nama + upload foto
      parent_dashboard/
      parent_settings/
      ChatLippo/                    # asisten chat berbasis Gemini
    routes/
      app_pages.dart
      app_routes.dart
    widgets/
      header.dart                   # top bar bersama (avatar, XP, hearts, rank)
      adventure_hearts_bar.dart
```

---

## Perilaku penting yang perlu diketahui

**Streak** direset tiap tengah malam. Melewatkan satu hari masih aman — ada grace period 2 hari. Kalau dua hari berturut-turut tidak login, streak kembali ke 1.

**XP petualangan** dikunci pada percobaan pertama di setiap level. Mengulang level untuk mendapat skor sempurna demi quest tidak menghasilkan XP tambahan.

**Quest** baru bisa diklaim setelah mendapat skor sempurna di level petualangan hari itu. Bonus XP bergantung pada rank: Bronze +3, Silver +7, Gold +10. Hanya bisa diklaim sekali per hari.

**Hearts** direset ke 5 setiap hari pukul 06.00. Jawaban salah di mode petualangan mengurangi satu heart.

**devMode** di `petualangan_controller.dart` saat ini bernilai `true` — ini melewati hitungan unlock harian sehingga semua level bisa diakses saat development. Ubah ke `false` sebelum release.

---

## Catatan

- Seluruh app dalam bahasa Indonesia (UI, TTS, konten game).
- Feedback suara menggunakan `SystemSound` bawaan Flutter — tidak butuh file audio tambahan. Di iOS menghasilkan suara klik seperti keyboard; di Android memainkan suara sentuh perangkat jika diaktifkan di pengaturan.
- Foto profil diupload ke Firebase Storage di `profile_photos/{uid}.jpg` dan disimpan sebagai field `photoUrl` di dokumen Firestore pengguna.
