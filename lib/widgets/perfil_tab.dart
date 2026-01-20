import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    // The main list view now has a slightly grey background like WhatsApp
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          const SizedBox(height: 12),
          // Grouping items in a white container to give the card effect
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildListTile(context, 'Informações Pessoais', Icons.person_outline),
                const Divider(indent: 20, height: 1),
                _buildListTile(context, 'Veículo e Documentos', Icons.directions_car_outlined),
                const Divider(indent: 20, height: 1),
                _buildListTile(context, 'Configurações de Corrida', Icons.settings_outlined),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.white,
            child: _buildListTile(context, 'Sair', Icons.exit_to_app_outlined, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon, {Color? color}) {
    // WhatsApp style ListTile is clean and simple
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 16,
          color: color ?? Colors.black87, // Using a slightly off-black color
        ),
      ),
      onTap: () {
        // Action to be performed on tap
      },
    );
  }
}
