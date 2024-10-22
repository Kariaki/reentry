class ReportDto {
  final String? id;
  final String issue;
  final String userId;
  final String reportedUserId;

  const ReportDto(
      {this.id,
      required this.issue,
      required this.userId,
      required this.reportedUserId});

  ReportDto copyWithId(String id) => ReportDto(
      issue: issue, userId: userId, reportedUserId: reportedUserId, id: id);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issue': issue,
      'userId': userId,
      'reportedUserId': reportedUserId,
      'createdAt': DateTime.now().toIso8601String()
    };
  }
}
