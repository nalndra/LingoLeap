import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/chat_lippo_controller.dart';

class ChatLippoView extends GetView<ChatLippoController> {
  const ChatLippoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E3),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMessageList()),
            _buildSuggestionChip(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2977C7)),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF2977C7), width: 2.5),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                'assets/icons/lippo_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Tanya Lippo',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2977C7),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Message List ─────────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    return Obx(() {
      final msgs = controller.messages;
      final loading = controller.isLoading.value;
      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        itemCount: msgs.length + (loading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == msgs.length) return _buildTypingCard();
          final msg = msgs[index];
          return msg.isUser ? _buildUserBubble(msg.text) : _buildBotCard(msg.text);
        },
      );
    });
  }

  // ─── User Bubble ──────────────────────────────────────────────────────────────

  Widget _buildUserBubble(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 56, bottom: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2977C7),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bot Card ─────────────────────────────────────────────────────────────────

  Widget _buildBotCard(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFBBBDBF),
              blurRadius: 0,
              offset: Offset(4, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2977C7), width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/lippo_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Lippo',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            MarkdownBody(
              data: text,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2977C7),
                  height: 1.5,
                ),
                strong: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A5FAB),
                ),
                listBullet: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2977C7),
                ),
                em: GoogleFonts.outfit(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF2977C7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Typing Card ──────────────────────────────────────────────────────────────

  Widget _buildTypingCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFBBBDBF),
              blurRadius: 0,
              offset: Offset(4, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2977C7), width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/lippo_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Lippo',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _dot(1.0),
                const SizedBox(width: 6),
                _dot(0.6),
                const SizedBox(width: 6),
                _dot(0.3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(double opacity) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: const Color(0xFF2977C7).withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      );

  // ─── Suggestion Chip ──────────────────────────────────────────────────────────

  Widget _buildSuggestionChip() {
    return Obx(() {
      if (controller.isLoading.value || controller.messages.length <= 1) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              controller.textController.text = 'Berikan contoh kalimat';
              controller.sendMessage();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF2977C7),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Aa',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Contoh kalimat',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ─── Input Bar ────────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFD0D0D0), width: 3),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAED),
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: controller.textController,
                onSubmitted: (_) => controller.sendMessage(),
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: const Color(0xFF1A1A1A),
                ),
                decoration: InputDecoration(
                  hintText: 'Tanya Lippo...',
                  hintStyle: GoogleFonts.outfit(
                    color: const Color(0xFF888B92),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : controller.sendMessage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: controller.isLoading.value
                        ? const Color(0xFFCCCCCC)
                        : const Color(0xFF2977C7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: controller.isLoading.value
                        ? Colors.grey
                        : Colors.white,
                    size: 22,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
