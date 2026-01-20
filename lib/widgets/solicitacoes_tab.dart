
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SolicitacoesTab extends StatelessWidget {
  const SolicitacoesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      ),
    );
  }
}
