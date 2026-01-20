import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Chat model
class Chat {
  final String userName;
  final String userPhotoUrl;
  final String lastMessage;
  final String timestamp;

  Chat({
    required this.userName,
    required this.userPhotoUrl,
    required this.lastMessage,
    required this.timestamp,
  });
}

class ConversasTab extends StatelessWidget {
  const ConversasTab({super.key});

  // Mock data for conversations
  static final List<Chat> _chats = [
    Chat(
      userName: 'Mariana Lima',
      userPhotoUrl: 'https://randomuser.me/api/portraits/women/26.jpg',
      lastMessage: 'Já estou no local aguardando!',
      timestamp: '14:32',
    ),
    Chat(
      userName: 'Pedro Almeida',
      userPhotoUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      lastMessage: 'Ok, obrigado!',
      timestamp: '11:05',
    ),
    Chat(
      userName: 'Juliana Costa',
      userPhotoUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
      lastMessage: 'Esqueci meu guarda-chuva no carro.',
      timestamp: 'Ontem',
    ),
    Chat(
      userName: 'Fernando Gomes',
      userPhotoUrl: 'https://randomuser.me/api/portraits/men/50.jpg',
      lastMessage: 'Excelente viagem, muito obrigado!',
      timestamp: 'Sexta-feira',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_chats.isEmpty) {
      return _buildEmptyState();
    } else {
      return ListView.separated(
        itemCount: _chats.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(chat.userPhotoUrl),
            ),
            title: Text(
              chat.userName,
              style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(color: Colors.grey.shade600),
            ),
            trailing: Text(
              chat.timestamp,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey.shade500),
            ),
            onTap: () {
              // In a real app, this would navigate to the chat screen.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abrindo conversa com ${chat.userName}')),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Nenhuma conversa encontrada',
            style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            'Seu histórico de conversas com passageiros aparecerá aqui.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
