import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VeiculoDocumentosScreen extends StatelessWidget {
  const VeiculoDocumentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Veículo e Documentos',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Informações do Veículo'),
          _buildTextField(label: 'Modelo do Veículo', initialValue: 'Toyota Corolla'),
          _buildTextField(label: 'Placa do Veículo', initialValue: 'BRA2E19'),
          const SizedBox(height: 20),
          _buildSectionTitle('Documentos'),
          _buildDocumentTile(context, 'CNH (Carteira Nacional de Habilitação)', 'Aprovado', Colors.green),
          _buildDocumentTile(context, 'CRLV (Certificado de Registro e Licenciamento do Veículo)', 'Pendente', Colors.orange),
          _buildDocumentTile(context, 'Foto do Veículo', 'Rejeitado', Colors.red),
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

  Widget _buildTextField({required String label, required String initialValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTile(BuildContext context, String title, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
        subtitle: Text(status, style: GoogleFonts.roboto(color: statusColor, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // In a real app, this would open a screen to upload/view the document
        },
      ),
    );
  }
}
