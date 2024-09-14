





class Proposal {
  final String id;
  final String date;
  final String cat;
  final String email;
  final String description;
  final String details;
  final String phone;
    final String price;
    final String status;
    final String time;
    final String image;
    final String title;
    final String user_phone;
    final String user_name;
    final String user_email;


  Proposal({required this.id, 
  required this.cat,
  required this.details,
  required this.user_name,
  required this.email,
  required this.user_phone,
  required this.phone,
  required this.status,
  required this.date,
  required this.image,
  required this.description,required this.price,
  required this.time,required this.title,required this.user_email
  });

  // Factory method to create an Ad instance from a Firestore document snapshot
  factory Proposal.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Proposal(
      id: json['id']??'',
      cat: json['cat'] ?? '',
      user_phone: json['user_phone'] ?? '',
      user_name: json['user_name'] ?? '',
      details: json['details'] ?? '',
      date: json['task_date'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['task_image']?? '',
      status: json['status'] ?? '',
      description: json['task_description'] ?? '',
      price: json['price'] ?? '',
      time: json['task_time'] ?? '',
      title: json['task_title'] ?? '',
      user_email: json['user_email'] ?? '',      
     // Default to empty string if no image
    );
  }
  // Method to convert Ad instance to a Map (useful for uploading data to Firestore)
  
}
