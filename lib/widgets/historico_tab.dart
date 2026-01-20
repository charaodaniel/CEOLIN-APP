import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/ride_history_model.dart';
import 'package:myapp/screens/registro_corrida_manual_screen.dart';
import 'package:myapp/services/report_generator.dart';

enum FilterType { none, today, thisWeek, thisMonth, custom }

class HistoricoTab extends StatefulWidget {
  const HistoricoTab({super.key});

  @override
  State<HistoricoTab> createState() => _HistoricoTabState();
}

class _HistoricoTabState extends State<HistoricoTab> {
  final List<RideHistory> _allRides = [
    RideHistory(destination: 'Shopping Iguatemi', date: DateTime.now().subtract(const Duration(hours: 4)), fare: 25.50),
    RideHistory(destination: 'Aeroporto Salgado Filho', date: DateTime.now().subtract(const Duration(days: 1, hours: 2)), fare: 42.80),
    RideHistory(destination: 'Centro Histórico', date: DateTime.now().subtract(const Duration(days: 5)), fare: 18.00),
    RideHistory(destination: 'Barra Shopping Sul', date: DateTime.now().subtract(const Duration(days: 6)), fare: 31.20),
    RideHistory(destination: 'Hospital Moinhos de Vento', date: DateTime.now().subtract(const Duration(days: 8)), fare: 22.75),
    RideHistory(destination: 'Parque da Redenção', date: DateTime.now().subtract(const Duration(days: 15)), fare: 15.00),
    RideHistory(destination: 'PUCRS', date: DateTime.now().subtract(const Duration(days: 32)), fare: 28.50),
  ];

  late List<RideHistory> _filteredRides;
  DateTimeRange? _customDateRange;
  FilterType _activeFilter = FilterType.none;
  final ReportGenerator _reportGenerator = ReportGenerator();

  @override
  void initState() {
    super.initState();
    _filteredRides = List.from(_allRides);
  }

  void _addRide(RideHistory ride) {
    setState(() {
      _allRides.insert(0, ride);
      _applyFilter(_activeFilter, range: _customDateRange);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Corrida registrada com sucesso!')),
      );
    }
  }

  void _navigateToRegisterScreen() async {
    final newRide = await Navigator.of(context).push<RideHistory>(
      MaterialPageRoute(builder: (context) => const RegistroCorridaManualScreen()),
    );
    if (newRide != null) _addRide(newRide);
  }

  void _applyFilter(FilterType filter, {DateTimeRange? range}) {
    setState(() {
      _activeFilter = filter;
      _customDateRange = range;

      DateTime now = DateTime.now();
      DateTime startOfToday = DateTime(now.year, now.month, now.day);

      switch (_activeFilter) {
        case FilterType.today:
          _filteredRides = _allRides.where((ride) => ride.date.isAfter(startOfToday)).toList();
          break;
        case FilterType.thisWeek:
          DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
          _filteredRides = _allRides.where((ride) => ride.date.isAfter(startOfWeek)).toList();
          break;
        case FilterType.thisMonth:
           DateTime startOfMonth = DateTime(now.year, now.month, 1);
          _filteredRides = _allRides.where((ride) => ride.date.isAfter(startOfMonth)).toList();
          break;
        case FilterType.custom:
          if (range != null) {
             final startOfDay = DateTime(range.start.year, range.start.month, range.start.day);
             final endOfDay = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);
            _filteredRides = _allRides.where((ride) => !ride.date.isBefore(startOfDay) && !ride.date.isAfter(endOfDay)).toList();
          } else {
             _filteredRides = List.from(_allRides);
          }
          break;
        case FilterType.none:
          _filteredRides = List.from(_allRides);
          break;
      }
    });
  }

  Future<void> _showCustomFilterDialog() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _customDateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor, onPrimary: Colors.white, onSurface: Colors.black),
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor)),
        ),
        child: child!,
      ),
    );
    if (picked != null) _applyFilter(FilterType.custom, range: picked);
  }

  Future<void> _showExportDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exportar Relatório'),
        content: const Text('Em qual formato você deseja exportar o relatório?'),
        actions: <Widget>[
          TextButton(child: const Text('PDF'), onPressed: () {
              Navigator.of(context).pop();
              _reportGenerator.generatePdf(_filteredRides, context, dateRange: _customDateRange);
          }),
          TextButton(child: const Text('CSV'), onPressed: () {
              Navigator.of(context).pop();
              _reportGenerator.generateCsv(_filteredRides, context);
          }),
          TextButton(child: const Text('Cancelar', style: TextStyle(color: Colors.redAccent)), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCustomFilterActive = _activeFilter == FilterType.custom;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Histórico de Corridas', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list, color: isCustomFilterActive ? Colors.white : Colors.white),
              onPressed: _showCustomFilterDialog,
              tooltip: 'Filtro Personalizado',
            ),
            IconButton(icon: const Icon(Icons.ios_share, color: Colors.white), onPressed: _showExportDialog, tooltip: 'Exportar Relatório'),
          ],
        ),
        body: Column(
          children: [
            _buildFilterChips(),
            Expanded(
              child: _filteredRides.isEmpty ? _buildEmptyState() : _buildHistoryList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToRegisterScreen,
          backgroundColor: Colors.white,
          tooltip: 'Registrar Corrida Manual',
          child: Icon(Icons.add, color: Colors.blue.shade800),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
       color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: FilterType.values.where((ft) => ft != FilterType.custom).map((filter) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                label: Text(filter == FilterType.none ? 'Todos' : toBeginningOfSentenceCase(filter.name.substring(4))!),
                labelStyle: const TextStyle(color: Colors.white),
                selected: _activeFilter == filter,
                onSelected: (bool selected) {
                  if (selected) _applyFilter(filter);
                },
                selectedColor: Colors.white.withOpacity(0.3),
                checkmarkColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.1),
                side: const BorderSide(color: Colors.white54),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: _filteredRides.length,
      itemBuilder: (context, index) {
        final ride = _filteredRides[index];
        final formattedDate = DateFormat('dd/MM/yyyy, HH:mm').format(ride.date);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.blue, size: 36),
            title: Text(ride.destination, style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
            subtitle: Text(formattedDate, style: GoogleFonts.roboto(color: Colors.grey.shade600)),
            trailing: Text('R\$ ${ride.fare.toStringAsFixed(2).replaceAll('.', ',')}', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade700)),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_activeFilter != FilterType.none ? Icons.search_off : Icons.history_toggle_off, size: 80, color: Colors.white70),
          const SizedBox(height: 20),
          Text(
            _activeFilter != FilterType.none ? 'Nenhum resultado encontrado' : 'Nenhum histórico de corridas',
            style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _activeFilter != FilterType.none ? 'Tente um período de data diferente ou limpe o filtro.' : 'Suas corridas concluídas aparecerão aqui.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
