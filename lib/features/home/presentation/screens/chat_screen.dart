import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/features/home/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAuthDetailsController userAuthDetailsController =
        Get.find<UserAuthDetailsController>();
    final userId = userAuthDetailsController.user.value?.id;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Support Chat')),
        body: const Center(child: Text('Please log in to chat')),
      );
    }

    // Initialize the controller
    final ChatController controller = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Chat'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isUser = message['sender_type'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isUser ? Colors.green[200] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['content'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('hh:mm a').format(
                                    DateTime.parse(message['created_at'])),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: controller.sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}
