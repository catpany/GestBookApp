import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String? validate(value, String rules) {
    if (value.toString().isNotEmpty) {
      emit(AuthValidationSuccess());
      return null;
    }

    return 'Field is empty';
  }
}
