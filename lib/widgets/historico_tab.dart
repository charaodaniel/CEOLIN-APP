import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Ride History model
class RideHistory {
  final String destination;
  final String date;
  final double fare;

  RideHistory({
    required this.destination,
    required this.date,
    required this.fare,
  });
}

class HistoricoTab extends StatelessWidget {
  const HistoricoTab({super.key});

  // Mock data for ride history
  static final List<RideHistory> _rideHistory = [
    RideHistory(
      destination: 'Shopping Iguatemi',
      date: 'Hoje, 10:45',
      fare: 25.50,
    ),
    RideHistory(
      destination: 'Aeroporto Salgado Filho',
      date: 'Ontem, 18:20',
      fare: 42.80,
    ),
    RideHistory(
      destination: 'Centro Histórico',
      date: '15 de Julho',
      fare: 18.00,
    ),
    RideHistory(
      destination: 'Barra Shopping Sul',
      date: '14 de Julho',
      fare: 31.20,
    ),
    RideHistory(
      destination: 'Hospital Moinhos de Vento',
      date: '12 de Julho',
      fare: 22.75,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_rideHistory.isEmpty) {
      return _buildEmptyState();
    } else {
      return ListView.builder(
        itemCount: _rideHistory.length,
        itemBuilder: (context, index) {
          final ride = _rideHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.directions_car,
                color: Colors.blue,
                size: 36,
              ),
              title: Text(
                ride.destination,
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                ride.date,
                style: GoogleFonts.roboto(color: Colors.grey.shade600),
              ),
              trailing: Text(
                'R\$ ${ride.fare.toStringAsFixed(2).replaceAll('.', ',')}',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.green.shade700,
                ),
              ),
              onTap: () {
                // In a real app, this could show ride details
              },
            ),
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
          const Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Nenhum histórico de corridas',
            style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            'Suas corridas concluídas aparecerão aqui.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
