import 'dart:async';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final messages = <dynamic>[].obs; // Reactive list of messages
  final chatId = RxnInt(); // Nullable reactive chat ID
  final isLoading = true.obs; // Loading state
  Timer? _pollingTimer;
  final DioClient apiClient = DioClient();

  @override
  void onInit() {
    super.onInit();
    initializeChat();
  }

  void initializeChat() async {
    isLoading.value = true;
    try {
      final response = await apiClient.get('/chat');
      chatId.value = response.data['chat_id'];
      messages.assignAll(response.data['messages']);
      isLoading.value = false;
      _startPolling();
      _scrollToBottom();
    } catch (e) {
      showSnackbar('Error', 'Failed to load chat: $e');
      isLoading.value = false;
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (chatId.value == null) return;
      try {
        final response = await apiClient.get('/chat/${chatId.value}/messages');
        messages.assignAll(response.data['messages']);
        _scrollToBottom();
      } catch (e) {
        // Silent error to avoid spamming user
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void sendMessage() async {
    if (messageController.text.trim().isEmpty || chatId.value == null) return;

    try {
      final response = await apiClient.post(
        '/chat/${chatId.value}/messages',
        data: {
          'chat_id': chatId.value,
          'content': messageController.text.trim()
        },
      );
      messages.add(response.data['message']);
      messageController.clear();
      _scrollToBottom();
    } catch (e) {
      showSnackbar('Error', 'Failed to send message: $e');
    }
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
