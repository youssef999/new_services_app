





class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String phone;


  User({required this.id, 
  required this.name,
  required this.image,
  required this.email,required this.phone
  });

  // Factory method to create an Ad instance from a Firestore document snapshot
  factory User.fromFirestore(Map<String, dynamic> json, String documentId) {
    return User(

       id: documentId,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      
    );
  }
}
