import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/library_repository.dart';

class GetLibrary implements UseCase<BaseResponse, GetLibraryParams> {
  final LibraryRepository libraryRepository;
  GetLibrary({required this.libraryRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetLibraryParams params,
  ) =>
      libraryRepository.getLibrary(
          accessToken: params.accessToken,
          pageNo: params.pageNo,
          type: params.type,);
}

class GetLibraryParams extends Equatable {
  final String accessToken;
  final String type;
  final int pageNo;

  const GetLibraryParams(
      {required this.pageNo, required this.accessToken, required this.type,});

  @override
  List<Object?> get props => [
        accessToken,
        type,
        pageNo,
      ];
}
