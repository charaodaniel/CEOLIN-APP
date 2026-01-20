class RideHistory {
  final String destination;
  final DateTime date;
  final double fare;

  RideHistory({
    required this.destination,
    required this.date,
    required this.fare,
  });

  /// Converte a instância de RideHistory em um mapa compatível com JSON.
  /// Isso é essencial para enviar os dados pela internet.
  Map<String, dynamic> toJson() => {
        'destination': destination,
        'date': date.toIso8601String(), // Usamos um formato padrão (ISO 8601) para a data.
        'fare': fare,
      };
}
