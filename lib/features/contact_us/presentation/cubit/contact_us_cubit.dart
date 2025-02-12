import 'dart:developer';

import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/app_strings.dart';
import 'package:alamoody/features/contact_us/domain/usecases/send_form_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsUseCase likedProjectsUseCase;
  ContactUsCubit({required this.likedProjectsUseCase})
      : super(ContactUsInitial());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
    String? subjectTitle;
  final formKey = GlobalKey<FormState>();

  Future<void> sendMessage({required String token}) async {
    emit(ContactUsLoading());
    log(messageController.value.text);
    log(titleController.value.text);
    log(subjectTitle!);
    final Either<Failure, BaseResponse> response = await likedProjectsUseCase(
      ContactUsParams(
        message: messageController.value.text,
        title: titleController.value.text,
        subject:subjectTitle! ,
        token: token,
      ),
    );
    emit(
      response.fold(
        (failure) => ContactUsError(message: _mapFailureToMsg(failure)),
        (message) {
          return ContactUsLoaded(message: message.message!);
        },
      ),
    );
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;

      default:
        return AppStrings.unexpectedError;
    }
  }
}
