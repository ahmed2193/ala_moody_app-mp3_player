import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/search_repository.dart';

class Search implements UseCase<BaseResponse, SearchParams> {
  final SearchRepository searchRepository;
  Search({required this.searchRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    SearchParams params,
  ) =>
      searchRepository.search(
        accessToken: params.accessToken,
        searchTxt: params.searchTxt,
      );
}

class SearchParams extends Equatable {
  final String accessToken;
  final String searchTxt;

  const SearchParams({
    required this.searchTxt,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        accessToken,
        searchTxt,
      ];
}
