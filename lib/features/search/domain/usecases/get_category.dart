import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/search_repository.dart';

class GetCategory implements UseCase<BaseResponse, GetCategoryParams> {
  final SearchRepository searchRepository;
  GetCategory({required this.searchRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetCategoryParams params,
  ) =>
      searchRepository.getCategory(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetCategoryParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetCategoryParams({
    required this.pageNo,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
