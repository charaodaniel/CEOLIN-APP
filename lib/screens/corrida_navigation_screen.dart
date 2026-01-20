import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/solicitacoes_tab.dart';

class CorridaNavigationScreen extends StatefulWidget {
  final RideRequest rideRequest;

  const CorridaNavigationScreen({super.key, required this.rideRequest});

  @override
  State<CorridaNavigationScreen> createState() => _CorridaNavigationScreenState();
}

class _CorridaNavigationScreenState extends State<CorridaNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Em Corrida'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Container no lugar do GoogleMap
          Container(
            color: Colors.grey[200], // Um fundo simples
          ),
          _buildPassengerInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildPassengerInfoPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPassengerHeader(),
            const Divider(height: 24),
            _buildRideActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(widget.rideRequest.passengerPhotoUrl),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.rideRequest.passengerName,
                style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Aguardando no local de partida',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const Icon(Icons.phone, color: Colors.blue, size: 28),
      ],
    );
  }

  Widget _buildRideActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Lógica para iniciar a corrida
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Corrida iniciada!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text('Iniciar Corrida', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            // Lógica para cancelar a corrida
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
