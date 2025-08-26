import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  const LoadUserProfile();
}

class RefreshUserProfile extends UserProfileEvent {
  const RefreshUserProfile();
}

class UpdateUserProfile extends UserProfileEvent {
  final UserProfile userProfile;

  const UpdateUserProfile(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class SetUserProfile extends UserProfileEvent {
  final UserProfile userProfile;

  const SetUserProfile(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class ClearUserProfile extends UserProfileEvent {
  const ClearUserProfile();
}