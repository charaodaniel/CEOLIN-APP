import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/corrida_navigation_screen.dart';

// Ride request model
class RideRequest {
  final String passengerName;
  final String passengerPhotoUrl;
  final String pickupAddress;
  final String destinationAddress;
  final double fare;

  RideRequest({
    required this.passengerName,
    required this.passengerPhotoUrl,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.fare,
  });
}

class SolicitacoesTab extends StatefulWidget {
  const SolicitacoesTab({super.key});

  @override
  State<SolicitacoesTab> createState() => _SolicitacoesTabState();
}

class _SolicitacoesTabState extends State<SolicitacoesTab> {
  final AudioPlayer _player = AudioPlayer();
  final List<RideRequest> _requests = [
    RideRequest(
      passengerName: 'Ana Clara',
      passengerPhotoUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      pickupAddress: 'Rua das Flores, 123',
      destinationAddress: 'Avenida Principal, 456',
      fare: 18.50,
    ),
    RideRequest(
      passengerName: 'Bruno Martins',
      passengerPhotoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      pickupAddress: 'Shopping Central',
      destinationAddress: 'Estação de Metrô',
      fare: 25.00,
    ),
    RideRequest(
      passengerName: 'Carla Souza',
      passengerPhotoUrl: 'https://randomuser.me/api/portraits/women/17.jpg',
      pickupAddress: 'Aeroporto Internacional',
      destinationAddress: 'Hotel Beira Mar',
      fare: 45.75,
    ),
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _showRideNotification() {
    _player.setReleaseMode(ReleaseMode.loop);
    _player.play(AssetSource('audio/olha-a-mensagem.mp3'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nova Corrida!', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
          content: const Text('Você tem uma nova solicitação de corrida.'),
          actions: [
            TextButton(
              onPressed: () {
                _player.stop();
                Navigator.of(context).pop();
              },
              child: const Text('Recusar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                _player.stop();
                Navigator.of(context).pop();
                if (_requests.isNotEmpty) {
                  _handleRideAction(_requests.first, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceitar'),
            ),
          ],
        );
      },
    );
  }

  void _handleRideAction(RideRequest request, bool accepted) {
    if (accepted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CorridaNavigationScreen(rideRequest: request),
        ),
      ).then((_) {
        // After returning from the navigation screen, remove the request
        setState(() {
          _requests.remove(request);
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corrida aceita! Iniciando navegação...'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _requests.remove(request);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corrida recusada.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _requests.isEmpty ? _buildEmptyState() : _buildRideList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRideNotification,
        tooltip: 'Simular Nova Corrida',
        child: const Icon(Icons.notifications_active),
      ),
    );
  }

  Widget _buildRideList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _requests.length,
      itemBuilder: (context, index) {
        return _buildRideRequestCard(context, _requests[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.car_rental, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Nenhuma solicitação no momento',
            style: GoogleFonts.roboto(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aguardando novas corridas...',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideRequestCard(BuildContext context, RideRequest request) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPassengerInfo(request),
            const SizedBox(height: 16),
            _buildRouteInfo(Icons.location_on, Colors.green, 'Partida', request.pickupAddress),
            const SizedBox(height: 10),
            _buildRouteInfo(Icons.flag, Colors.red, 'Destino', request.destinationAddress),
            const Divider(height: 32),
            _buildActionBar(context, request),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerInfo(RideRequest request) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(request.passengerPhotoUrl),
        ),
        const SizedBox(width: 12),
        Text(
          request.passengerName,
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRouteInfo(IconData icon, Color color, String label, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: GoogleFonts.roboto(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, RideRequest request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'R\$ ${request.fare.toStringAsFixed(2)}',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => _handleRideAction(request, false),
              child: const Text('Recusar', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _handleRideAction(request, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Aceitar'),
            ),
          ],
        ),
      ],
    );
  }
}
