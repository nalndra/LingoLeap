import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';
import '../../../services/pin_service.dart';

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}

class ExerciseModel {
  final String id;
  final String title;
  final String description;
  final String icon; // 'puzzle', 'mic', 'lightning', 'magic_wand'
  final RxString status; // 'active', 'locked'
  final List<QuizQuestion> questions;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required String initialStatus,
    required this.questions,
  }) : status = initialStatus.obs;
}

class GameModel {
  final String id;
  final String title;
  final String difficulty; // 'Mudah', 'Sedang', 'Sulit'
  final RxInt stars; // 0 to 3
  final int xpReward;
  final String icon; // 'puzzle', 'mic', 'lightning', 'document'
  final List<QuizQuestion> questions;

  GameModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required int initialStars,
    required this.xpReward,
    required this.icon,
    required this.questions,
  }) : stars = initialStars.obs;
}

class LeaderboardUser {
  final String name;
  final RxInt xp;
  final String avatar;
  final bool isCurrentUser;

  LeaderboardUser({
    required this.name,
    required int initialXp,
    required this.avatar,
    this.isCurrentUser = false,
  }) : xp = initialXp.obs;
}

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  
  final selectedIndex = 0.obs;

  final List<Map<String, dynamic>> levels = [
    {'icon': 'assets/icons/flag.png', 'unlocked': true, 'type': 'start'},
    {'icon': 'assets/icons/puzzle.png', 'unlocked': false, 'type': 'puzzle'},
    {'icon': 'assets/icons/headphones.png', 'unlocked': false, 'type': 'listening'},
    {'icon': 'assets/icons/book.png', 'unlocked': false, 'type': 'reading'},
    {'icon': 'assets/icons/puzzle.png', 'unlocked': false, 'type': 'puzzle'},
    {'icon': Icons.lock, 'unlocked': false, 'type': 'locked'},
    {'icon': 'assets/icons/flag.png', 'unlocked': false, 'type': 'end'},
    {'icon': 'assets/icons/puzzle.png', 'unlocked': false, 'type': 'puzzle'},
  ];

  // Active Tab Index
  final tabIndex = 0.obs;

  // User Stats matching mockups
  final hearts = 5.obs; // 5/5
  final streak = 5.obs; // 5
  final xp = 100.obs;   // 100 XP
  final gems = 150.obs;  // 150 Gems
  final level = 10.obs;  // Lvl 10

  // Rank helpers — call inside Obx() so they stay reactive
  String get rankName {
    if (level.value >= 20) return 'Emas';
    if (level.value >= 10) return 'Perak';
    return 'Perunggu';
  }

  String get rankCardAsset {
    if (level.value >= 20) return 'assets/ranks/card_rank_gold.png';
    if (level.value >= 10) return 'assets/ranks/card_rank_silver.png';
    return 'assets/ranks/card_rank_bronze.png';
  }

  String get rankBadgeAsset {
    if (level.value >= 20) return 'assets/ranks/badge_rank_gold.png';
    if (level.value >= 10) return 'assets/ranks/badge_rank_silver.png';
    return 'assets/ranks/badge_rank_bronze.png';
  }

  Color get rankColor {
    if (level.value >= 20) return const Color(0xFFFFD700);
    if (level.value >= 10) return const Color(0xFF9E9E9E);
    return const Color(0xFFCD7F32);
  }

  // Inventory/Items count
  final streakFreezes = 1.obs;
  final xpDoublers = 0.obs;

  // Exercises list (Screen 2)
  final exercises = <ExerciseModel>[].obs;

  // Games list (Screen 3)
  final games = <GameModel>[].obs;

  // Leaderboard data
  final leaderboard = <LeaderboardUser>[].obs;

  // Active Quiz State
  final isQuizActive = false.obs;
  final activeQuizTitle = ''.obs;
  final activeQuestions = <QuizQuestion>[].obs;
  final currentQuestionIndex = 0.obs;
  final selectedOptionIndex = Rxn<int>();
  final isAnswerChecked = false.obs;
  final isAnswerCorrect = false.obs;
  final quizErrorsCount = 0.obs;

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: tabIndex.value);
    _initializeExercises();
    _initializeGames();
    _initializeLeaderboard();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void logout() async {
    try {
      Get.find<PinService>().clearLocalPin();
    } catch (_) {}
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // Called by bottom nav taps — all tabs allowed, animate the PageView
  void changeTab(int index) {
    _goToPage(index);
  }

  // Called by PageView's onPageChanged — just syncs the indicator
  void onPageSwiped(int index) {
    tabIndex.value = index;
  }

  void _goToPage(int index) {
    tabIndex.value = index;
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  // Predefined Exercises (Screen 2)
  void _initializeExercises() {
    exercises.assignAll([
      ExerciseModel(
        id: 'ex1',
        title: 'Latihan Puzzle Visual',
        description: 'Sihir menyusun kata-kata rahasia.',
        icon: 'puzzle',
        initialStatus: 'active',
        questions: [
          QuizQuestion(
            questionText: 'Susun kata untuk menerjemahkan: "Saya suka belajar"',
            options: ['I like learning', 'Learning likes I', 'I learning like', 'Learning I like'],
            correctOptionIndex: 0,
          ),
          QuizQuestion(
            questionText: 'Lengkapi susunan kata: "He ___ English daily."',
            options: ['speak', 'speaks', 'speaking', 'spoke'],
            correctOptionIndex: 1,
          ),
        ],
      ),
      ExerciseModel(
        id: 'ex2',
        title: 'Latihan Gema Suara',
        description: 'Ucapkan mantra dengan lantang.',
        icon: 'mic',
        initialStatus: 'locked',
        questions: [
          QuizQuestion(
            questionText: 'Bagaimana pengucapan yang benar untuk "Hello"?',
            options: ['He-lo', 'Hel-lo', 'Hai-lo', 'Ha-lo'],
            correctOptionIndex: 1,
          ),
        ],
      ),
      ExerciseModel(
        id: 'ex3',
        title: 'Latihan Fokus Kilat',
        description: 'Melihat cahaya kata dalam sekejap.',
        icon: 'lightning',
        initialStatus: 'locked',
        questions: [
          QuizQuestion(
            questionText: 'Apa kata bahasa Inggris dari "Cepat"?',
            options: ['Slow', 'Fast', 'Heavy', 'Weak'],
            correctOptionIndex: 1,
          ),
        ],
      ),
      ExerciseModel(
        id: 'ex4',
        title: 'Latihan Jurnal Sihir',
        description: 'Tuliskan takdirmu di lembaran emas.',
        icon: 'magic_wand',
        initialStatus: 'locked',
        questions: [
          QuizQuestion(
            questionText: 'Tuliskan terjemahan kata "Buku":',
            options: ['Book', 'Pen', 'Pencil', 'Eraser'],
            correctOptionIndex: 0,
          ),
        ],
      ),
    ]);
  }

  // Predefined Games (Screen 3)
  void _initializeGames() {
    games.assignAll([
      GameModel(
        id: 'g1',
        title: 'Puzzle Kata',
        difficulty: 'Mudah',
        initialStars: 2,
        xpReward: 10,
        icon: 'puzzle',
        questions: [
          QuizQuestion(
            questionText: 'Manakah dari kata berikut yang merupakan kata kerja?',
            options: ['Beautiful', 'Run', 'Apple', 'Quickly'],
            correctOptionIndex: 1,
          ),
          QuizQuestion(
            questionText: 'Terjemahan dari "Apple" adalah...',
            options: ['Pisang', 'Jeruk', 'Apel', 'Mangga'],
            correctOptionIndex: 2,
          ),
        ],
      ),
      GameModel(
        id: 'g2',
        title: 'Gema Suara',
        difficulty: 'Sedang',
        initialStars: 2,
        xpReward: 10,
        icon: 'mic',
        questions: [
          QuizQuestion(
            questionText: 'Kata "Listen" diucapkan dengan huruf "T" yang tidak terdengar (silent).',
            options: ['Benar', 'Salah'],
            correctOptionIndex: 0,
          ),
        ],
      ),
      GameModel(
        id: 'g3',
        title: 'Kilat Baca',
        difficulty: 'Sulit',
        initialStars: 0,
        xpReward: 10,
        icon: 'lightning',
        questions: [
          QuizQuestion(
            questionText: 'Bacalah dengan cepat: "Peter Piper picked a peck of pickled peppers."',
            options: ['Selesai membaca', 'Batal'],
            correctOptionIndex: 0,
          ),
        ],
      ),
      GameModel(
        id: 'g4',
        title: 'Tulis Mantra',
        difficulty: 'Sedang',
        initialStars: 3,
        xpReward: 10,
        icon: 'document',
        questions: [
          QuizQuestion(
            questionText: 'Tulis ejaan yang benar untuk "Mantra":',
            options: ['Spell', 'Spel', 'Speel', 'Sppel'],
            correctOptionIndex: 0,
          ),
        ],
      ),
    ]);
  }

  // Predefined leaderboard users
  void _initializeLeaderboard() {
    leaderboard.assignAll([
      LeaderboardUser(name: 'Nazmi Rio', initialXp: 350, avatar: '😺'),
      LeaderboardUser(name: 'Adit Pratama', initialXp: 210, avatar: '🐼'),
      LeaderboardUser(
        name: currentUser?.displayName ?? 'Nalendra',
        initialXp: xp.value,
        avatar: '🐸', // Frog emoji matching username mascot
        isCurrentUser: true,
      ),
      LeaderboardUser(name: 'Siti Rahma', initialXp: 90, avatar: '🦊'),
      LeaderboardUser(name: 'Budi Santoso', initialXp: 60, avatar: '🦁'),
    ]);
    _sortLeaderboard();
  }

  void _sortLeaderboard() {
    leaderboard.sort((a, b) => b.xp.value.compareTo(a.xp.value));
  }

  // Generic Quiz Starter
  void startQuiz(String title, List<QuizQuestion> questions) {
    if (hearts.value <= 0) {
      Get.snackbar(
        'Nyawa Habis',
        'Kamu tidak memiliki nyawa tersisa. Isi ulang nyawamu di Toko!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    activeQuizTitle.value = title;
    activeQuestions.assignAll(questions);
    currentQuestionIndex.value = 0;
    selectedOptionIndex.value = null;
    isAnswerChecked.value = false;
    isAnswerCorrect.value = false;
    quizErrorsCount.value = 0;
    isQuizActive.value = true;
  }

  void selectOption(int index) {
    if (isAnswerChecked.value) return;
    selectedOptionIndex.value = index;
  }

  void checkAnswer() {
    if (selectedOptionIndex.value == null || isAnswerChecked.value) return;

    final question = activeQuestions[currentQuestionIndex.value];
    isAnswerChecked.value = true;
    
    if (selectedOptionIndex.value == question.correctOptionIndex) {
      isAnswerCorrect.value = true;
    } else {
      isAnswerCorrect.value = false;
      quizErrorsCount.value++;
      // Deduct heart
      hearts.value = (hearts.value - 1).clamp(0, 5);
    }
  }

  void nextQuestion() {
    if (!isAnswerChecked.value) return;

    if (currentQuestionIndex.value < activeQuestions.length - 1) {
      currentQuestionIndex.value++;
      selectedOptionIndex.value = null;
      isAnswerChecked.value = false;
      isAnswerCorrect.value = false;
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    isQuizActive.value = false;

    if (hearts.value > 0) {
      int earnedXp = 10;
      int earnedGems = 5;

      // Double points if XP Doubler is active
      if (xpDoublers.value > 0) {
        earnedXp *= 2;
        xpDoublers.value--;
      }
      
      // Exercises give more XP/Gems
      if (activeQuizTitle.value.startsWith('Latihan') || activeQuizTitle.value.startsWith('Misi')) {
        earnedXp = 20;
        earnedGems = 10;
      }
      
      xp.value += earnedXp;
      gems.value += earnedGems;

      // Update current user's XP in leaderboard
      final userIndex = leaderboard.indexWhere((u) => u.isCurrentUser);
      if (userIndex != -1) {
        leaderboard[userIndex].xp.value = xp.value;
        _sortLeaderboard();
      }

      // Unlock next exercises if visual puzzle completed
      if (activeQuizTitle.value == 'Latihan Puzzle Visual') {
        final exGema = exercises.firstWhereOrNull((ex) => ex.id == 'ex2');
        if (exGema != null && exGema.status.value == 'locked') {
          exGema.status.value = 'active';
        }
      }

      Get.dialog(
        _buildSuccessDialog(earnedXp, earnedGems),
        barrierDismissible: false,
      );
    } else {
      Get.dialog(
        _buildFailureDialog(),
        barrierDismissible: false,
      );
    }
  }

  // Shop purchases
  void buyHeartRefill() {
    if (gems.value < 100) {
      _showShopError('Gems tidak cukup!');
      return;
    }
    if (hearts.value >= 5) {
      _showShopError('Nyawamu sudah penuh!');
      return;
    }

    gems.value -= 100;
    hearts.value = 5;
    _showShopSuccess('Nyawa berhasil diisi penuh!');
  }

  void buyStreakFreeze() {
    if (gems.value < 200) {
      _showShopError('Gems tidak cukup!');
      return;
    }
    gems.value -= 200;
    streakFreezes.value += 1;
    _showShopSuccess('Streak Freeze berhasil dibeli!');
  }

  void buyXpDoubler() {
    if (gems.value < 150) {
      _showShopError('Gems tidak cukup!');
      return;
    }
    gems.value -= 150;
    xpDoublers.value += 1;
    _showShopSuccess('XP Doubler berhasil dibeli!');
  }

  void _showShopError(String message) {
    Get.snackbar(
      'Gagal Membeli',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showShopSuccess(String message) {
    Get.snackbar(
      'Pembelian Berhasil',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Widget _buildSuccessDialog(int earnedXp, int earnedGems) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Center(
        child: Text(
          '🎉 Pelajaran Selesai!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF3DAA4C)),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars, size: 80, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'Hebat sekali, Pahlawan! Kamu menyelesaikan materi ini dengan gemilang.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRewardBadge('⚡ +$earnedXp XP', Colors.orange),
              _buildRewardBadge('💎 +$earnedGems Gems', Colors.cyan),
            ],
          ),
        ],
      ),
      actions: [
        Center(
          child: Container(
            height: 50,
            width: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF2A7C36),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3DAA4C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.back(); // close dialog
                  },
                  child: const Center(
                    child: Text(
                      'SELESAI',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFailureDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Center(
        child: Text(
          '💔 Nyawa Habis!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.red),
        ),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.heart_broken_rounded, size: 80, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Oh tidak! Kamu kehabisan nyawa dalam pelajaran ini. Jangan menyerah, pahlawan! Isi kembali nyawamu di Toko dan coba lagi.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
          ),
        ],
      ),
      actions: [
        Center(
          child: Container(
            height: 50,
            width: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF0F2342),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A6B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.back(); // close dialog
                    tabIndex.value = 2; // switch to Shop tab
                  },
                  child: const Center(
                    child: Text(
                      'KE TOKO',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
