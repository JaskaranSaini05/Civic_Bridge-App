class Complaint {
  final String title;
  final String description;
  final String category;
  final String address;
  final String status;
  final String userId;

  Complaint({
    required this.title,
    required this.description,
    required this.category,
    required this.address,
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'address': address,
      'status': status,
      'userId': userId,
      'createdAt': DateTime.now(),
    };
  }
}
