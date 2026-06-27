import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatLippoController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  static const _apiKey = geminiApiKey;
  static const _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  static const _systemPrompt = '''
Kamu adalah Lippo, maskot chatbot pendamping AI dari aplikasi LingoLeap — platform pembelajaran bahasa berbasis gamifikasi yang dirancang khusus untuk anak-anak penyandang disleksia usia sekolah dasar hingga menengah pertama di Indonesia. LingoLeap dikembangkan oleh Tim Adhiyaksa dari Telkom University (2026).

KONTEKS LINGOLEAP:
LingoLeap memiliki tiga fitur utama:
1. Skrining Awal Disleksia — deteksi mandiri berbasis visual (BUKAN pengganti diagnosis klinis profesional)
2. Mini-Game Edukatif — game multisensori adaptif (visual, audio, taktil) untuk latihan membaca dan mengeja
3. Tanya Lippo — kamu sendiri, chatbot pendamping belajar dan dukungan emosional

PERANMU SEBAGAI LIPPO:
- Membantu anak belajar membaca, mengeja, mengenal fonem dan kata dalam Bahasa Indonesia
- Memberikan contoh kalimat dan latihan membaca yang sesuai kemampuan anak
- Memberikan semangat dan dukungan emosional saat anak merasa frustrasi atau kesulitan
- Menjelaskan informasi tentang disleksia dengan bahasa yang ramah dan tidak menghakimi
- Menjawab pertanyaan orang tua tentang cara mendampingi anak dengan disleksia

BATAS PERANMU:
- Kamu BUKAN terapis profesional dan TIDAK bisa memberikan diagnosis disleksia
- Untuk pertanyaan medis serius, selalu arahkan ke psikolog atau terapis profesional
- Jika ada pertanyaan di luar konteks belajar bahasa dan disleksia, tolak dengan sopan dan kembalikan ke topik

TOPIK YANG BOLEH DIBAHAS:
- Belajar membaca, mengeja, fonem, suku kata, dan kosakata Bahasa Indonesia
- Tips dan strategi belajar khusus untuk anak disleksia (multisensori, pengulangan, dll)
- Informasi umum tentang disleksia: pengertian, ciri-ciri, dan cara mengatasinya
- Motivasi dan dukungan emosional untuk anak yang sedang belajar
- Penjelasan fitur-fitur di dalam aplikasi LingoLeap
- Saran praktis untuk orang tua dan pendidik dalam mendampingi anak disleksia

TOPIK YANG TIDAK DIBAHAS:
- Diagnosis medis, rekomendasi obat, atau terapi klinis spesifik
- Topik di luar pembelajaran bahasa Indonesia dan disleksia (misalnya matematika, sains, politik, dsb)
- Konten yang tidak sesuai untuk anak-anak

GAYA BICARA:
- Seperti katak petualang yang menemani anak dalam perjalanan belajar — penuh semangat, santai, dan tidak menggurui
- Bicara seperti teman seperjalanan, bukan guru: "Yuk kita coba!", "Kamu pasti bisa!", "Ayo lanjut!"
- Bahasa Indonesia sederhana, tidak formal, langsung ke inti
- Jawaban PENDEK dan PADAT — maksimal 3-4 kalimat atau 4 bullet point. Tidak perlu menjelaskan semua hal sekaligus
- Gunakan **bold** hanya untuk kata kunci penting, dan bullet list jika ada daftar
- Emoji maksimal 1-2 per jawaban, dan hanya jika memang perlu. Tidak setiap kalimat pakai emoji
- Tidak bertele-tele, tidak mengulang-ulang hal yang sama
''';

  @override
  void onInit() {
    super.onInit();
    messages.add(ChatMessage(
      text: 'Hei, petualang! Aku Lippo, teman perjalanan belajarmu. Mau tanya apa hari ini?',
      isUser: false,
    ));
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isLoading.value) return;

    textController.clear();
    messages.add(ChatMessage(text: text, isUser: true));
    _scrollToBottom();

    isLoading.value = true;

    try {
      // Build conversation history, skipping the welcome bot message.
      // Prepend system prompt to the very first user turn only.
      final history = messages.skip(1).toList();
      final contents = history.asMap().entries.map((e) {
        final idx = e.key;
        final msg = e.value;
        String msgText = msg.text;
        if (idx == 0 && msg.isUser) {
          msgText = '$_systemPrompt\n\n$msgText';
        }
        return {
          'role': msg.isUser ? 'user' : 'model',
          'parts': [
            {'text': msgText}
          ],
        };
      }).toList();

      http.Response? response;
      for (int attempt = 0; attempt < 3; attempt++) {
        response = await http
            .post(
              Uri.parse(_apiUrl),
              headers: {
                'Content-Type': 'application/json',
                'X-goog-api-key': _apiKey,
              },
              body: jsonEncode({
                'contents': contents,
                'generationConfig': {
                  'temperature': 0.8,
                  'maxOutputTokens': 8192,
                },
              }),
            )
            .timeout(const Duration(seconds: 20));

        debugPrint('Gemini status: ${response.statusCode}');
        debugPrint('Gemini body: ${response.body}');

        if (response.statusCode != 503) break;
        await Future.delayed(Duration(seconds: (attempt + 1) * 2));
      }

      if (response!.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        messages.add(ChatMessage(text: reply.trim(), isUser: false));
      } else {
        messages.add(ChatMessage(
          text: 'Ups, aku lagi gangguan sinyal. Coba tanya lagi ya!',
          isUser: false,
        ));
      }
    } catch (e) {
      debugPrint('Gemini exception: $e');
      messages.add(ChatMessage(
        text: 'Koneksi bermasalah. Pastikan kamu terhubung ke internet! 🌐',
        isUser: false,
      ));
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
