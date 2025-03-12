import 'package:reentry/data/model/user_dto.dart';

class VerificationRequestDto {
  final String? verificationStatus;
  final String? date;
  final Map<String, String> form;
  final String? rejectionReason;

  VerificationRequestDto({
    this.verificationStatus,
    this.date,
    required this.form,
    this.rejectionReason,
  });

  // CopyWith method
  VerificationRequestDto copyWith({
    String? verificationStatus,
    String? date,
    Map<String, String>? form,
    String? rejectionReason,
  }) {
    return VerificationRequestDto(
      verificationStatus: verificationStatus ?? this.verificationStatus,
      date: date ?? this.date,
      form: form ?? this.form,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  // From JSON
  factory VerificationRequestDto.fromJson(Map<String, dynamic> json) {
    return VerificationRequestDto(
      verificationStatus: json['verificationStatus'] as String?,
      date: json['date'] as String?,
      form: Map<String, String>.from(json['form'] ?? {}),
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'verificationStatus': verificationStatus ?? VerificationStatus.pending,
      'date': date,
      'form': form,
      'rejectionReason': rejectionReason,
    };
  }
}
