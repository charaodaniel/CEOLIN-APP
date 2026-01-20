import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfiguracoesCorridaScreen extends StatefulWidget {
  const ConfiguracoesCorridaScreen({super.key});

  @override
  State<ConfiguracoesCorridaScreen> createState() =>
      _ConfiguracoesCorridaScreenState();
}

class _ConfiguracoesCorridaScreenState
    extends State<ConfiguracoesCorridaScreen> {
  String _tipoTarifa = 'fixa';
  bool _aceitaNegociavel = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações de Corrida',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Tipo de Tarifa'),
          // A Correção Definitiva:
          // O `onChanged` do Radio é nulo, e o estado é alterado no `onTap` do ListTile.
          // Isso está de acordo com as novas regras de lint do Flutter.
          ListTile(
            title: Text('Tarifa Fixa', style: GoogleFonts.roboto()),
            leading: Radio<String>(
              value: 'fixa',
              groupValue: _tipoTarifa,
              // O onChanged é nulo pois a ação é tratada pelo onTap do ListTile.
              onChanged: null,
            ),
            onTap: () {
              setState(() {
                _tipoTarifa = 'fixa';
              });
            },
          ),
          ListTile(
            title: Text('Tarifa por Km', style: GoogleFonts.roboto()),
            leading: Radio<String>(
              value: 'km',
              groupValue: _tipoTarifa,
              // O onChanged é nulo pois a ação é tratada pelo onTap do ListTile.
              onChanged: null,
            ),
            onTap: () {
              setState(() {
                _tipoTarifa = 'km';
              });
            },
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Corridas Negociáveis'),
          SwitchListTile(
            title: Text(
              'Aceitar corridas negociáveis para o interior',
              style: GoogleFonts.roboto(),
            ),
            value: _aceitaNegociavel,
            onChanged: (value) {
              setState(() {
                _aceitaNegociavel = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
