class RideModel {
  final String id;
  final String? driver;
  final String? passenger;
  final String passengerAnonymousName;
  final String originAddress;
  final String destinationAddress;
  final double fare;
  final String status;
  final String startedBy;
  final bool isNegotiated;
  final DateTime created;
  final DateTime updated;

  RideModel({
    required this.id,
    this.driver,
    this.passenger,
    required this.passengerAnonymousName,
    required this.originAddress,
    required this.destinationAddress,
    required this.fare,
    required this.status,
    required this.startedBy,
    required this.isNegotiated,
    required this.created,
    required this.updated,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      driver: json['driver'],
      passenger: json['passenger'],
      passengerAnonymousName: json['passenger_anonymous_name'],
      originAddress: json['origin_address'],
      destinationAddress: json['destination_address'],
      fare: (json['fare'] as num).toDouble(),
      status: json['status'],
      startedBy: json['started_by'],
      isNegotiated: json['is_negotiated'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }
}
