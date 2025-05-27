import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatWithVisitorsPage extends StatefulWidget {
  const ChatWithVisitorsPage({super.key});

  @override
  State<ChatWithVisitorsPage> createState() => _ChatWithVisitorsPageState();
}

class _ChatWithVisitorsPageState extends State<ChatWithVisitorsPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<Visitor> _visitors = [
    Visitor(
      id: 'V1001',
      name: 'Sarah Johnson',
      email: 'sarah@example.com',
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
    ),
    Visitor(
      id: 'V1002',
      name: 'Michael Brown',
      email: 'michael@example.com',
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: false,
    ),
    Visitor(
      id: 'V1003',
      name: 'Emily Davis',
      email: 'emily@example.com',
      lastSeen: DateTime.now().subtract(const Duration(days: 1)),
      isOnline: false,
    ),
  ];
  String _currentVisitorId = 'V1001';

  @override
  void initState() {
    super.initState();
    // Load demo messages
    _messages.addAll([
      ChatMessage(
        sender: 'V1001',
        text: 'Hello, I have a question about my prescription',
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        isFromVisitor: true,
      ),
      ChatMessage(
        sender: 'You',
        text: 'How can I help you today?',
        time: DateTime.now().subtract(const Duration(minutes: 8)),
        isFromVisitor: false,
      ),
      ChatMessage(
        sender: 'V1001',
        text: 'When will my medication be ready for pickup?',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        isFromVisitor: true,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final currentVisitor = _visitors.firstWhere(
          (v) => v.id == _currentVisitorId,
      orElse: () => _visitors.first,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Visitor List Sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.people, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Active Visitors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Visitor List
                Expanded(
                  child: ListView.builder(
                    itemCount: _visitors.length,
                    itemBuilder: (context, index) {
                      final visitor = _visitors[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(visitor.name[0]),
                        ),
                        title: Text(visitor.name),
                        subtitle: Text(
                          visitor.isOnline ? 'Online now' : 'Last seen ${_formatLastSeen(visitor.lastSeen)}',
                          style: TextStyle(
                            color: visitor.isOnline ? Colors.green : Colors.grey,
                          ),
                        ),
                        trailing: visitor.isOnline
                            ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )
                            : null,
                        selected: visitor.id == _currentVisitorId,
                        selectedTileColor: Colors.blue[50],
                        onTap: () {
                          setState(() {
                            _currentVisitorId = visitor.id;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(currentVisitor.name[0]),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentVisitor.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            currentVisitor.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: currentVisitor.isOnline
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () => _showVisitorInfo(currentVisitor),
                      ),
                    ],
                  ),
                ),
                // Messages
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages
                        .where((m) => m.sender == _currentVisitorId || !m.isFromVisitor)
                        .length,
                    itemBuilder: (context, index) {
                      final message = _messages
                          .where((m) => m.sender == _currentVisitorId || !m.isFromVisitor)
                          .toList()
                          .reversed
                          .elementAt(index);
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                // Message Input
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.blue,
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromVisitor = message.isFromVisitor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: isFromVisitor ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isFromVisitor ? Colors.grey[100] : Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.text),
              const SizedBox(height: 4),
              Text(
                DateFormat('h:mm a').format(message.time),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        sender: 'You',
        text: _messageController.text,
        time: DateTime.now(),
        isFromVisitor: false,
      ));
      _messageController.clear();
    });

    // Simulate reply after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          sender: _currentVisitorId,
          text: _getRandomReply(),
          time: DateTime.now(),
          isFromVisitor: true,
        ));
      });
    });
  }

  String _getRandomReply() {
    final replies = [
      'Thanks for your help!',
      'I appreciate your quick response',
      'Can you tell me more about this medication?',
      'When will my prescription be ready?',
      'Do you have this in stock?',
    ];
    return replies[DateTime.now().second % replies.length];
  }

  void _showVisitorInfo(Visitor visitor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Visitor Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${visitor.name}'),
            Text('Email: ${visitor.email}'),
            Text('Status: ${visitor.isOnline ? 'Online' : 'Offline'}'),
            Text('Last seen: ${_formatLastSeen(visitor.lastSeen)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class Visitor {
  final String id;
  final String name;
  final String email;
  final DateTime lastSeen;
  final bool isOnline;

  Visitor({
    required this.id,
    required this.name,
    required this.email,
    required this.lastSeen,
    required this.isOnline,
  });
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime time;
  final bool isFromVisitor;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isFromVisitor,
  });
}