abstract class LoginStates{}

class InitialLoginState extends LoginStates{}

////////////////////// Login email and password
class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{}

class LoginErrorState extends LoginStates{}

////////////////////// Login with google
class LoginWithGoogleLoading extends LoginStates{}

class LoginWithGoogleSuccess extends LoginStates{}

class LoginWithGoogleError extends LoginStates{}

////////////////////// Change password Login
class ChangePasswordVisibility extends LoginStates{}

////////////////////// reset password
class SendCodeLoading extends LoginStates{}

class SendCodeSuccess extends LoginStates{}

class SendCodeError extends LoginStates{}

/////////////////////// Logout with email and password
class LogoutLoading extends LoginStates{}

class LogoutSuccess extends LoginStates{}

class LogoutError extends LoginStates{}

///////////////////////// upload image for register
class UploadImageRegisterLoading extends LoginStates{}

class UploadImageRegisterSuccess extends LoginStates{}

class UploadImageRegisterError extends LoginStates{}

//////////////////////////// change password register
class ChangePasswordRegisterVisibility extends LoginStates{}

//////////////////////////// change ensure password
class ChangeEnsurePasswordRegisterVisibility extends LoginStates{}

//////////////////////////// register states
class RegisterLoadingState extends LoginStates{}

class RegisterSuccessState extends LoginStates{}

class RegisterErrorState extends LoginStates{}

////////////////////////// search states
class SearchLoading extends LoginStates{}

class SearchSuccess extends LoginStates{}

class SearchError extends LoginStates{}


