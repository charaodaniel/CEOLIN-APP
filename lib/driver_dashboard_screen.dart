import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/profile_picture_screen.dart';
import 'package:myapp/widgets/conversas_tab.dart';
import 'package:myapp/widgets/historico_tab.dart';
import 'package:myapp/widgets/perfil_tab.dart';
import 'package:myapp/widgets/solicitacoes_tab.dart';
import 'package:permission_handler/permission_handler.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleRefresh() async {
    // Simulate a network request or data refresh
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, you would fetch new data here
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitações atualizadas!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permissão para acessar a ${source == ImageSource.camera ? 'câmera' : 'galeria'} foi negada.'),
          ),
        );
      }
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
                        Navigator.of(context).pop();
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
      body: DefaultTabController(
        length: 4,
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverRefreshControl(
              onRefresh: _handleRefresh,
            ),
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              floating: true, 
              expandedHeight: 320.0, // Adjust height to fit content
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
              bottom: const TabBar(
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
            ),
            const SliverFillRemaining(
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

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51), // Replaced withOpacity
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40), // Adjust for status bar
          GestureDetector(
            onTap: () => _showProfilePictureOptions(context),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _image == null
                  ? const NetworkImage('https://picsum.photos/200')
                  : FileImage(File(_image!.path)) as ImageProvider,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Juliano Ceolin',
            style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 5),
              Text(
                '4.9 (41 corridas)',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Online',
                  style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
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
        ],
      ),
    );
  }
}
