class InstitutionalInfoModel {
  final String companyName;
  final String cnpj;
  final String supportContact;
  final String address;

  InstitutionalInfoModel({
    required this.companyName,
    required this.cnpj,
    required this.supportContact,
    required this.address,
  });

  factory InstitutionalInfoModel.fromJson(Map<String, dynamic> json) {
    return InstitutionalInfoModel(
      companyName: json['company_name'],
      cnpj: json['cnpj'],
      supportContact: json['support_contact'],
      address: json['address'],
    );
  }
}
