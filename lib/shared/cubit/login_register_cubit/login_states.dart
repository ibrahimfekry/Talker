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

////////////////////////// search Chat history screen states
class SearchLoading extends LoginStates{}

class SearchSuccess extends LoginStates{}

class SearchError extends LoginStates{}

///////////////////////// get available group
class GetAvailableGroupsLoading extends LoginStates{}

class GetAvailableGroupsSuccess extends LoginStates{}

class GetAvailableGroupsError extends LoginStates{}

////////////////////////// search Chat history screen states
class SearchGroupNameLoading extends LoginStates{}

class SearchGroupNameSuccess extends LoginStates{}

class SearchGroupNameError extends LoginStates{}

/////////////////////////// Get current user details
class GetCurrentUserDetailsLoading extends LoginStates{}

class GetCurrentUserDetailsSuccess extends LoginStates{}

class GetCurrentUserDetailsError extends LoginStates{}

/////////////////////////// search to add members to group
class AddMemberSearchLoading extends LoginStates{}

class AddMemberSearchSuccess extends LoginStates{}

class AddMemberSearchError extends LoginStates{}

/////////////////////////// on result add members
class OnResultAddMembersLoading extends LoginStates{}

class OnResultAddMembersSuccess extends LoginStates{}

class OnResultAddMembersError extends LoginStates{}

/////////////////////////// remove members from add members screen
class RemoveMemberFromAddMemberLoading extends LoginStates{}

class RemoveMemberFromAddMemberSuccess extends LoginStates{}

class RemoveMemberFromAddMemberError extends LoginStates{}

/////////////////////////// create group
class CreateGroupLoading extends LoginStates{}

class CreateGroupSuccess extends LoginStates{}

class CreateGroupError extends LoginStates{}

/////////////////////////// delete group
class DeleteGroupLoading extends LoginStates{}

class DeleteGroupSuccess extends LoginStates{}

class DeleteGroupError extends LoginStates{}

/////////////////////////// send message group
class SendMessageGroupLoading extends LoginStates{}

class SendMessageGroupSuccess extends LoginStates{}

class SendMessageGroupError extends LoginStates{}

/////////////////////////// get group member
class GetGroupMemberLoading extends LoginStates{}

class GetGroupMemberSuccess extends LoginStates{}

class GetGroupMemberError extends LoginStates{}

/////////////////////////// remove user from group
class RemoveUserGroupLoading extends LoginStates{}

class RemoveUserGroupSuccess extends LoginStates{}

class RemoveUserGroupError extends LoginStates{}

//////////////////////////// leave the group
class LeaveGroupLoading extends LoginStates{}

class LeaveGroupSuccess extends LoginStates{}

class LeaveGroupError extends LoginStates{}

//////////////////////////// on search group info
class OnSearchGroupInfoLoading extends LoginStates{}

class OnSearchGroupInfoSuccess extends LoginStates{}

class OnSearchGroupInfoError extends LoginStates{}

//////////////////////////// add member to group Info
class AddMemberGroupInfoLoading extends LoginStates{}

class AddMemberGroupInfoSuccess extends LoginStates{}

class AddMemberGroupInfoError extends LoginStates{}

//////////////////////////// get profile data
class GetProfileDataLoading extends LoginStates{}

class GetProfileDataSuccess extends LoginStates{}

class GetProfileDataError extends LoginStates{}

//////////////////////////// update profile
class UpdateProfileLoading extends LoginStates{}

class UpdateProfileSuccess extends LoginStates{}

class UpdateProfileError extends LoginStates{}

/////////////////////////// update image
class UpdateImageLoading extends LoginStates{}

class UpdateImageSuccess extends LoginStates{}

class UpdateImageError extends LoginStates{}