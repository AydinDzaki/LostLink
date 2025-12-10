import 'package:cloud_firestore/cloud_firestore.dart';

class ClaimModel {
  final String? id;
  final String itemId;
  final String itemTitle;
  final String itemImageUrl;
  final String userId;
  final String userEmail;
  final String proofDescription;
  final String status;
  final DateTime createdAt;
  final String? adminResponse; 

  ClaimModel({
    this.id,
    required this.itemId,
    required this.itemTitle,
    required this.itemImageUrl,
    required this.userId,
    required this.userEmail,
    required this.proofDescription,
    this.status = 'pending',
    required this.createdAt,
    this.adminResponse, 
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemTitle': itemTitle,
      'itemImageUrl': itemImageUrl,
      'userId': userId,
      'userEmail': userEmail,
      'proofDescription': proofDescription,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'adminResponse': adminResponse, 
    };
  }

  factory ClaimModel.fromJson(Map<String, dynamic> json, String id) {
    return ClaimModel(
      id: id,
      itemId: json['itemId'] ?? '',
      itemTitle: json['itemTitle'] ?? '',
      itemImageUrl: json['itemImageUrl'] ?? '',
      userId: json['userId'] ?? '',
      userEmail: json['userEmail'] ?? '',
      proofDescription: json['proofDescription'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      adminResponse: json['adminResponse'], 
    );
  }
}