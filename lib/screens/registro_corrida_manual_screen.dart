import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/ride_history_model.dart';

class RegistroCorridaManualScreen extends StatefulWidget {
  const RegistroCorridaManualScreen({super.key});

  @override
  State<RegistroCorridaManualScreen> createState() =>
      _RegistroCorridaManualScreenState();
}

class _RegistroCorridaManualScreenState
    extends State<RegistroCorridaManualScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _partidaController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();
  TimeOfDay _horaSelecionada = TimeOfDay.now();

  @override
  void dispose() {
    _partidaController.dispose();
    _destinoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSelecionada,
    );
    if (picked != null && picked != _horaSelecionada) {
      setState(() {
        _horaSelecionada = picked;
      });
    }
  }

  void _saveRide() {
    if (_formKey.currentState!.validate()) {
      final combinedDateTime = DateTime(
        _dataSelecionada.year,
        _dataSelecionada.month,
        _dataSelecionada.day,
        _horaSelecionada.hour,
        _horaSelecionada.minute,
      );

      final newRide = RideHistory(
        destination: _destinoController.text,
        date: combinedDateTime, // Pass the DateTime object directly
        fare: double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0,
      );
      
      // Pop the screen and return the new ride object
      Navigator.of(context).pop(newRide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Corrida Manual',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextField(_partidaController, 'Endereço de Partida'),
              const SizedBox(height: 16),
              _buildTextField(_destinoController, 'Endereço de Destino'),
              const SizedBox(height: 16),
              _buildTextField(
                _valorController, 
                'Valor da Corrida (R\$)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),
              _buildDateTimePickers(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveRide,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Salvar Corrida',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    {TextInputType keyboardType = TextInputType.text}
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo.';
        }
        if (label.contains('Valor') && double.tryParse(value.replaceAll(',', '.')) == null) {
          return 'Por favor, insira um valor numérico válido.';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePickers() {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
               decoration: InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}'),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context),
            child: InputDecorator(
               decoration: InputDecoration(
                labelText: 'Hora',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(_horaSelecionada.format(context)),
            ),
          ),
        ),
      ],
    );
  }
}
