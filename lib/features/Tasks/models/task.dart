



class Task {
  final String id;
  final String date;
  final String cat;
  final String description;
  final String end_time;
    final String maxPrice;
    final String minPrice;
    final String time;
    final String image;
    final String title;
    final String user_email;


  Task({required this.id, 
  required this.cat,
  required this.date,
  required this.image,
  required this.description,required this.end_time,required this.maxPrice,required this.minPrice,
  required this.time,required this.title,required this.user_email
  });

  // Factory method to create an Ad instance from a Firestore document snapshot
  factory Task.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Task(
      id: json['id']??'',
      cat: json['cat'] ?? '',
      date: json['date'] ?? '',
      image: json['image']?? '',
      description: json['description'] ?? '',
      end_time: json['end_time'] ?? '',
      maxPrice: json['maxPrice'] ?? '',
      minPrice: json['minPrice'] ?? '',
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      user_email: json['user_email'] ?? '',
     // Default to empty string if no image
    );
  }
  // Method to convert Ad instance to a Map (useful for uploading data to Firestore)
  
}
