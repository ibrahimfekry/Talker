abstract class LoginStates{}

class InitialLoginState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{}

class LoginErrorState extends LoginStates{}

class LoginWithGoogleLoading extends LoginStates{}

class LoginWithGoogleSuccess extends LoginStates{}

class LoginWithGoogleError extends LoginStates{}

class ChangePasswordVisibility extends LoginStates{}

class SendCodeLoading extends LoginStates{}

class SendCodeSuccess extends LoginStates{}

class LogoutLoading extends LoginStates{}

class LogoutSuccess extends LoginStates{}

class LogoutError extends LoginStates{}

class SendCodeError extends LoginStates{}

class ChangePasswordRegisterVisibility extends LoginStates{}

class ChangeEnsurePasswordRegisterVisibility extends LoginStates{}

class RegisterLoadingState extends LoginStates{}

class RegisterSuccessState extends LoginStates{}

class RegisterErrorState extends LoginStates{}

class SearchLoading extends LoginStates{}

class SearchSuccess extends LoginStates{}

class SearchError extends LoginStates{}



