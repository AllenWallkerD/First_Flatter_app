import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/user.dart';
import '../../data/models/user_model.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserApiService _userApiService;

  UserProfileBloc({UserApiService? userApiService})
      : _userApiService = userApiService ?? UserApiService(),
        super(const UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<RefreshUserProfile>(_onRefreshUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ClearUserProfile>(_onClearUserProfile);
    on<SetUserProfile>(_onSetUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event,
      Emitter<UserProfileState> emit,
      ) async {
    if (state is! UserProfileLoaded) {
      emit(const UserProfileLoading());
      await _fetchUserProfile(emit);
    }
  }

  Future<void> _onRefreshUserProfile(
      RefreshUserProfile event,
      Emitter<UserProfileState> emit,
      ) async {
    emit(const UserProfileLoading());
    await _fetchUserProfile(emit);
  }

  void _onUpdateUserProfile(
      UpdateUserProfile event,
      Emitter<UserProfileState> emit,
      ) {
    emit(UserProfileLoaded(event.userProfile));
  }

  void _onSetUserProfile(
      SetUserProfile event,
      Emitter<UserProfileState> emit,
      ) {
    emit(UserProfileLoaded(event.userProfile));
  }

  void _onClearUserProfile(
      ClearUserProfile event,
      Emitter<UserProfileState> emit,
      ) {
    emit(const UserProfileInitial());
  }

  Future<void> _fetchUserProfile(Emitter<UserProfileState> emit) async {
    try {
      final result = await _userApiService.getRandomUser();

      if (result.success && result.data != null) {
        emit(UserProfileLoaded(result.data!));
      } else {
        emit(UserProfileError(result.errorMessage ?? 'Failed to load user profile'));
      }
    } catch (e) {
      emit(UserProfileError('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _userApiService.dispose();
    return super.close();
  }

  UserProfile? get currentUser {
    final currentState = state;
    if (currentState is UserProfileLoaded) {
      return currentState.userProfile;
    }
    return null;
  }

  bool get isUserLoaded => state is UserProfileLoaded;

  bool get isLoading => state is UserProfileLoading;

  String? get errorMessage {
    final currentState = state;
    if (currentState is UserProfileError) {
      return currentState.message;
    }
    return null;
  }
}