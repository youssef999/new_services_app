



class WorkerProvider{
  final String id;
  final String image;
  final String cat;
  final String email;
  final String lat;
  final String lng;
  final String name;
  final String details;
  final String price;

  WorkerProvider({required this.id,
   required this.details,
   required this.lat,required this.lng,
  required this.cat,required this.email,required this.image,required this.name,
  required this.price
});

  // Factory method to create an Ad instance from a Firestore document snapshot
  factory WorkerProvider.fromFirestore(Map<String, dynamic> json, String documentId) {
    return WorkerProvider(
      id: documentId,
      details: json['details'] ?? '',
      image: json['image'] ?? '', 
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      cat: json['cat'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'cat': cat,
      'email': email,
      'name': name,
      'price': price,
      'id': id
    };
  }
}
