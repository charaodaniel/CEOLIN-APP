import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformacoesPessoaisScreen extends StatelessWidget {
  const InformacoesPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informações Pessoais',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTextField(label: 'Nome Completo', initialValue: 'Juliano Ceolin'),
          _buildTextField(label: 'Email', initialValue: 'juliano.ceolin@example.com'),
          _buildTextField(label: 'Telefone', initialValue: '(51) 99999-9999'),
          _buildTextField(label: 'Endereço', initialValue: 'Rua das Flores, 123'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // In a real app, you would save the updated information
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Salvar Alterações',
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
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
}
