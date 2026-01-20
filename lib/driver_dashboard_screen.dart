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
  int _currentIndex = 0;
  
  // Criamos chaves globais para acessar os métodos dos nossos widgets de abas.
  final GlobalKey<HistoricoTabState> _historicoTabKey = GlobalKey<HistoricoTabState>();
  final GlobalKey<SolicitacoesTabState> _solicitacoesTabKey = GlobalKey<SolicitacoesTabState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
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
                    _buildOption(context, Icons.remove_red_eye, 'Ver Foto', Colors.blue.shade700, () {
                      Navigator.of(context).pop();
                      if (_image?.path != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfilePictureScreen(imageUrl: _image!.path),
                        ));
                      }
                    }),
                    _buildOption(context, Icons.photo_library, 'Galeria', Colors.green.shade600, () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                    _buildOption(context, Icons.camera_alt, 'Câmera', Colors.purple.shade600, () {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    }),
                  ],
                ),
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

  /// Constrói a lista de botões de ação na AppBar dinamicamente,
  /// dependendo da aba que está selecionada.
  List<Widget> _buildActions() {
    // Aba de Solicitações (índice 0)
    if (_currentIndex == 0) { 
      return [
        IconButton(
          icon: const Icon(Icons.notifications_active_outlined),
          onPressed: () => _solicitacoesTabKey.currentState?.showRideNotification(),
          tooltip: 'Simular Nova Corrida',
        ),
      ];
    } 
    // Aba de Histórico (índice 2)
    else if (_currentIndex == 2) { 
      return [
        // BOTÃO DE SINCRONIZAÇÃO
        IconButton(
          icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
          onPressed: () => _historicoTabKey.currentState?.syncToGoogleSheets(),
          tooltip: 'Sincronizar com Planilha Google',
        ),
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
      ];
    }
    // Para as outras abas, não há ações.
    return [];
  }

  @override
  Widget build(BuildContext context) {
    bool isHistoryTab = _currentIndex == 2;

    return Stack(
      children: [
        // Aplica o fundo gradiente apenas quando a aba de histórico está ativa.
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
          appBar: AppBar(
            elevation: isHistoryTab ? 0 : 4,
            backgroundColor: isHistoryTab ? Colors.transparent : Colors.white,
            title: Text('Painel do Motorista', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: isHistoryTab ? Colors.white : Colors.black)),
            actions: _buildActions(), // Ações dinâmicas
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.new_releases), text: 'Solicitações'),
                Tab(icon: Icon(Icons.chat_bubble), text: 'Conversas'),
                Tab(icon: Icon(Icons.history), text: 'Histórico'),
                Tab(icon: Icon(Icons.person), text: 'Perfil'),
              ],
              labelColor: isHistoryTab ? Colors.white : Colors.blue.shade800,
              unselectedLabelColor: isHistoryTab ? Colors.white70 : Colors.grey.shade600,
              indicatorColor: isHistoryTab ? Colors.white : Colors.blue.shade800,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SolicitacoesTab(key: _solicitacoesTabKey),
              const ConversasTab(),
              // Passamos a chave global para a nossa aba de histórico.
              HistoricoTab(key: _historicoTabKey),
              PerfilTab(showProfilePictureOptions: () => _showProfilePictureOptions(context)),
            ],
          ),
          // O botão flutuante só aparece na aba de histórico.
          floatingActionButton: isHistoryTab
              ? FloatingActionButton(
                  onPressed: () => _historicoTabKey.currentState?.navigateToRegisterScreen(),
                  backgroundColor: Colors.white,
                  tooltip: 'Registrar Corrida Manual',
                  child: Icon(Icons.add, color: Colors.blue.shade800),
                )
              : null,
        ),
      ],
    );
  }
}
