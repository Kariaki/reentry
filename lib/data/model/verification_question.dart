class VerificationQuestionDto {
  final String? id;
  final String question;
  final String? createdAt;
  final String? updatedAt;

  VerificationQuestionDto(
      {this.id, required this.question, this.createdAt, this.updatedAt});

  VerificationQuestionDto copyWith(
      {String? id, String? question, String? createdAt, String? updatedAt}) {
    return VerificationQuestionDto(
        id: id ?? this.id,
        question: question ?? this.question,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  factory VerificationQuestionDto.fromJson(Map<String, dynamic> json) {
    return VerificationQuestionDto(
        id: json['id'],
        question: json['question'],
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?);
  }

  Map<String, dynamic> json() {
    return {
      'id': id,
      'question': question,
      'updatedAt': updatedAt,
      'createdAt': createdAt
    };
  }
}
