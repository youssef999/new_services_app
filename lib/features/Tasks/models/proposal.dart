import 'package:cloud_firestore/cloud_firestore.dart';

class Proposal {
  final String id;
  final String details;
  final String email;
  final String name;
  final String phone;
  final String price;
  final String status;
  final String taskCat;
  final String taskDate;
  final String taskDescription;
  final String taskId;
  final String taskImage;
  final String taskTime;
  final String taskTitle;
  final String userEmail;
  final String userName;
  final String userPhone;

  Proposal({
    required this.id,
    required this.details,
    required this.email,
    required this.name,
    required this.phone,
    required this.price,
    required this.status,
    required this.taskCat,
    required this.taskDate,
    required this.taskDescription,
    required this.taskId,
    required this.taskImage,
    required this.taskTime,
    required this.taskTitle,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
  });

  // Factory constructor to create a Proposal from a Firestore document
  factory Proposal.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Proposal(
      id: doc.id,
      details: data['details'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      price: data['price'] ?? '',
      status: data['status'] ?? '',
      taskCat: data['task_cat'] ?? '',
      taskDate: data['task_date'] ?? '',
      taskDescription: data['task_description'] ?? '',
      taskId: data['task_id'] ?? '',
      taskImage: data['task_image'] ?? '',
      taskTime: data['task_time'] ?? '',
      taskTitle: data['task_title'] ?? '',
      userEmail: data['user_email'] ?? '',
      userName: data['user_name'] ?? '',
      userPhone: data['user_phone'] ?? '',
    );
  }

  // Method to convert Proposal object into a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'details': details,
      'email': email,
      'name': name,
      'phone': phone,
      'price': price,
      'status': status,
      'task_cat': taskCat,
      'task_date': taskDate,
      'task_description': taskDescription,
      'task_id': taskId,
      'task_image': taskImage,
      'task_time': taskTime,
      'task_title': taskTitle,
      'user_email': userEmail,
      'user_name': userName,
      'user_phone': userPhone,
    };
  }
}
