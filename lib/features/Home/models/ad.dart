

class Ad {
  final String id;
  final String imageUrl;

  Ad({required this.id, required this.imageUrl});

  // Factory method to create an Ad instance from a Firestore document snapshot
  factory Ad.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Ad(
      id: documentId,
      imageUrl: json['image'] ?? '', // Default to empty string if no image
    );
  }
  // Method to convert Ad instance to a Map (useful for uploading data to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'image': imageUrl,
    };
  }
}
