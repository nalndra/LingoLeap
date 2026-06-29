# LingoLeap

A reading-learning app built for Indonesian children with dyslexia. The approach is game-first — kids progress through daily mini-games instead of sitting through lessons. Parents get a separate dashboard to track how their child is actually doing.

---

## What it does

Kids go through an **adventure map** that unlocks one level per day. Each day cycles through a different game type: arranging letters into words, sorting syllables, picking rhyming words, and identifying phonemes by position. They earn XP, build a login streak, and can claim bonus rewards from the daily quest once they hit a perfect score.

Parents log in through a separate PIN-protected mode and see real-time stats — accuracy, reading speed, phoneme recognition, difficult words — all pulled from the same Firestore document the child writes to.

### The four games

**Suku Kata** — letter tiles are shuffled, child taps them into order to spell a word.

**Kosa Kata** — same concept but with syllable bubbles instead of single letters.

**Rima** — given a word and its image, pick which of three options rhymes with it.

**Fonem** — the app reads a word aloud (TTS), child picks the letter at a specific position (first, last, second, etc.).

---

## Tech stack

- **Flutter** with **GetX** for state + routing
- **Firebase Auth** — email/password, persistent login
- **Cloud Firestore** — all child progress, stats, streak, quest state
- **Firebase Storage** — profile photo uploads
- **flutter_tts** — Indonesian TTS for the Fonem game
- **image_picker** — gallery photo selection for profile
- **shared_preferences** — local sound/vibration prefs, PIN cache

---

## Getting started

You need Flutter 3.x and a Firebase project configured for Android and iOS.

```bash
git clone https://github.com/nalndra/LingoLeap.git
cd lingoleap
flutter pub get
```

Drop your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) into the platform folders, then generate `firebase_options.dart`:

```bash
flutterfire configure
```

Run on a device (emulator haptics are weak — real device recommended):

```bash
flutter run
```

### Firebase rules

Firestore and Storage rules are not included in this repo. At minimum you'll want authenticated read/write on `users/{uid}` and `profile_photos/{uid}.jpg`.

---

## Project structure

```
lib/
  main.dart                         # service registration, app entry
  app/
    services/
      auth_service.dart
      child_progress_service.dart   # central reactive state for child stats
      feedback_service.dart         # haptic + sound feedback
      pin_service.dart
    modules/
      home/                         # shell with bottom nav + page view
      petualangan/                  # adventure map, daily unlock logic
      game_sukukata/
      game_kosakata/
      game_rima/
      game_fonem/
      quest/                        # daily quest, rank-based XP claim
      progress/                     # level card, stat bars, quest journey
      setting/                      # profile edit, preferensi, parent mode
      edit_profile/                 # name + photo upload
      parent_dashboard/
      parent_settings/
      ChatLippo/                    # Gemini-powered chat assistant
    routes/
      app_pages.dart
      app_routes.dart
    widgets/
      header.dart                   # shared top bar (avatar, XP, hearts, rank)
      adventure_hearts_bar.dart
```

---

## Key behaviors worth knowing

**Streak** resets at midnight. Missing one day is fine — there's a 2-day grace period. Miss two consecutive days and it resets to 1.

**Adventure XP** is locked to the first attempt on each level. Replaying a level to get a perfect score for the quest doesn't earn extra XP.

**Quest** becomes claimable only after a perfect score on today's adventure level. Bonus XP is rank-dependent: Bronze +3, Silver +7, Gold +10. It can only be claimed once per day.

**Hearts** reset to 5 every day at 06:00. Wrong answers in adventure mode cost a heart.

**devMode** in `petualangan_controller.dart` is currently `true` — it bypasses the daily unlock count so all levels are accessible during development. Set it to `false` before releasing.

---

## Notes

- The app is in Indonesian throughout (UI, TTS, game content).
- Sound feedback uses Flutter's built-in `SystemSound` — no audio assets needed. On iOS this plays a keyboard-style click; on Android it plays the device touch sound if the user has touch sounds enabled.
- Profile photos are uploaded to Firebase Storage at `profile_photos/{uid}.jpg` and stored as `photoUrl` in the user's Firestore document.
