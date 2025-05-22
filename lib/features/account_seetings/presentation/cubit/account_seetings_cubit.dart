import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_seetings_state.dart';

class AccountSeetingsCubit extends Cubit<AccountSeetingsState> {
  AccountSeetingsCubit() : super(AccountSeetingsInitial());
}
