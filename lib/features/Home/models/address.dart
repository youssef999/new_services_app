




class Address {
  final String id;
  final String country;
  final String name;


  Address({required this.id, required this.country,required this.name});


  factory Address.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Address(
      id: documentId,
      name:json['name'] ?? '',
      country: json['county'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'name': name,
    };
  }
}
