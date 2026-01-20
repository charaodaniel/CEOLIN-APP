import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/configuracoes_corrida_screen.dart';
import 'package:myapp/screens/informacoes_pessoais_screen.dart';
import 'package:myapp/screens/veiculo_documentos_screen.dart';

class PerfilTab extends StatelessWidget {
  const PerfilTab({super.key});

  // Function to show a confirmation dialog
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza de que deseja sair?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // In a real app, you would handle the logout logic here.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saindo...')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Profile sections grouped in cards
          _buildProfileCard(
            context,
            [
              _buildListTile(context, 'Informações Pessoais', Icons.person_outline, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InformacoesPessoaisScreen()));
              }),
              _buildListTile(context, 'Veículo e Documentos', Icons.directions_car_outlined, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VeiculoDocumentosScreen()));
              }),
              _buildListTile(context, 'Configurações de Corrida', Icons.settings_outlined, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracoesCorridaScreen()));
              }),
            ],
          ),
          const SizedBox(height: 20),
          _buildProfileCard(
            context,
            [
              _buildListTile(context, 'Ajuda e Suporte', Icons.help_outline, () {}),
              _buildListTile(context, 'Termos de Serviço', Icons.description_outlined, () {}),
            ],
          ),
          const SizedBox(height: 20),
          _buildProfileCard(
            context,
            [
              _buildListTile(
                context, 
                'Sair', 
                Icons.exit_to_app_outlined, 
                () => _showLogoutDialog(context), 
                color: Colors.red,
                hideChevron: true, // No chevron for logout
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to build the card container
  Widget _buildProfileCard(BuildContext context, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index < children.length - 1) const Divider(indent: 16, height: 1),
            ],
          );
        }),
      ),
    );
  }

  // Helper to build a styled ListTile
  Widget _buildListTile(BuildContext context, String title, IconData icon, VoidCallback onTap, {Color? color, bool hideChevron = false}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[600], size: 26),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      trailing: hideChevron ? null : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
