import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  final String sectionTitle;
  final List<NotificationItem> notifications;

  const NotificationSection({
    required this.sectionTitle,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        ...notifications.map((notification) => notification).toList(),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, color: Colors.red, size: 12.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 14.0, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4.0),
                Text(timestamp,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 12.0, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
