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

class _DriverDashboardScreenState extends State<DriverDashboardScreen> with SingleTickerProviderStateMixin {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  late TabController _tabController;
  final GlobalKey<HistoricoTabState> _historicoTabKey = GlobalKey<HistoricoTabState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      Icons.remove_red_eye,
                      'Ver Foto',
                      Colors.blue.shade700,
                      () {
                        Navigator.of(context).pop();
                        if (_image?.path != null) {
                           Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfilePictureScreen(imageUrl: _image!.path),
                          ));
                        }
                      },
                    ),
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
                if (_image != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Remover foto', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      _removeImage();
                      Navigator.of(context).pop();
                    },
                  )
                ]
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
  bool isHistoryTab = _currentIndex == 2;

  return Stack(
    children: [
      if (isHistoryTab)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      Scaffold(
        backgroundColor: isHistoryTab ? Colors.transparent : Colors.white,
        floatingActionButton: isHistoryTab
            ? FloatingActionButton(
                onPressed: () => _historicoTabKey.currentState?.navigateToRegisterScreen(),
                backgroundColor: Colors.white,
                tooltip: 'Registrar Corrida Manual',
                child: Icon(Icons.add, color: Colors.blue.shade800),
              )
            : null,
        body: DefaultTabController(
          length: 4,
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: _handleRefresh,
              ),
              SliverAppBar(
                backgroundColor: isHistoryTab ? Colors.transparent : Colors.white,
                pinned: true,
                floating: true,
                elevation: isHistoryTab ? 0 : 4,
                expandedHeight: 320.0,
                actions: isHistoryTab
                    ? [
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: () => _historicoTabKey.currentState?.showCustomFilterDialog(),
                          tooltip: 'Filtro Personalizado',
                        ),
                        IconButton(
                          icon: const Icon(Icons.ios_share, color: Colors.white),
                          onPressed: () => _historicoTabKey.currentState?.showExportDialog(),
                          tooltip: 'Exportar Relatório',
                        ),
                      ]
                    : [],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(isHistoryTab),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Solicitações'),
                    Tab(text: 'Conversas'),
                    Tab(text: 'Histórico'),
                    Tab(text: 'Perfil'),
                  ],
                  labelColor: isHistoryTab ? Colors.white : Colors.black,
                  unselectedLabelColor: isHistoryTab ? Colors.white70 : Colors.grey,
                  indicatorColor: isHistoryTab ? Colors.white : Colors.blue,
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const SolicitacoesTab(),
                    const ConversasTab(),
                    HistoricoTab(key: _historicoTabKey),
                    const PerfilTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


  Widget _buildProfileHeader(bool isHistoryTab) {
    Color textColor = isHistoryTab ? Colors.white : Colors.black;
    Color subtextColor = isHistoryTab ? Colors.white70 : Colors.grey.shade600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isHistoryTab ? Colors.transparent : Colors.white,
        boxShadow: isHistoryTab
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
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
            style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 5),
              Text(
                '4.9 (41 corridas)',
                style: GoogleFonts.roboto(fontSize: 16, color: subtextColor),
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
                  style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500, color: textColor),
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
