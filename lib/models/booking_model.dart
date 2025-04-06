class BookingModel {
  final String id;
  final String expertName;
  final String expertSpecialty;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime date;
  final String time;
  final double consultationFee;
  final String status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.expertName,
    required this.expertSpecialty,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.date,
    required this.time,
    required this.consultationFee,
    required this.status,
    required this.createdAt,
  });
}
