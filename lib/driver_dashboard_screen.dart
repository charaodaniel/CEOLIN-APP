import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/profile_picture_screen.dart';
import 'package:myapp/widgets/conversas_tab.dart';
import 'package:myapp/widgets/historico_tab.dart';
import 'package:myapp/widgets/perfil_tab.dart';
import 'package:myapp/widgets/solicitacoes_tab.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  void _showProfilePictureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Foto do perfil',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildOption(
                      context,
                      Icons.remove_red_eye,
                      'Ver Foto',
                      Colors.blue.shade700,
                      () {
                        Navigator.of(context).pop(); // Dismiss bottom sheet
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfilePictureScreen(
                            imageUrl: _image?.path ?? 'https://picsum.photos/200',
                          ),
                        ));
                      },
                    ),
                    const SizedBox(width: 40),
                    _buildOption(
                      context,
                      Icons.photo_library,
                      'Galeria',
                      Colors.green.shade600,
                      () {
                        _pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 40),
                    _buildOption(
                      context,
                      Icons.camera_alt,
                      'Câmera',
                      Colors.purple.shade600,
                      () {
                        _pickImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remover foto', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    _removeImage();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network('https://ceolinmob.vercel.app/icon.png'), // Use a network image for the logo
        ),
        title: Text(
          'Painel do Motorista',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showProfilePictureOptions(context),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image == null
                          ? const NetworkImage('https://picsum.photos/200')
                          : FileImage(File(_image!.path)) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Juliano Ceolin',
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '4.9 (41 corridas)',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Online',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: true,
                          onChanged: (value) {},
                          activeTrackColor: Colors.green.shade200,
                          activeThumbColor: Colors.green.shade600,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Solicitações'),
                Tab(text: 'Conversas'),
                Tab(text: 'Histórico'),
                Tab(text: 'Perfil'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  SolicitacoesTab(),
                  ConversasTab(),
                  HistoricoTab(),
                  PerfilTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
