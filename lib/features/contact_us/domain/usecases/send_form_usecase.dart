import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/contact_us/domain/repositories/base_contact_us_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ContactUsUseCase extends UseCase<BaseResponse, ContactUsParams> {
  final BaseContactUsRepository baseContactUsRepository;

  ContactUsUseCase(this.baseContactUsRepository);

  @override
  Future<Either<Failure, BaseResponse>> call(ContactUsParams params) {
    return baseContactUsRepository.getLikedProjects(params: params);
  }
}

class ContactUsParams extends Equatable {
  final String title;
  final String message;
  final String subject;
  final String token;

  const ContactUsParams({
    required this.title,
    required this.token,
    required this.message,
    required this.subject,
  });

  @override
  List<Object?> get props => [
        title,
        token,
        message,
        subject,
      ];
}
