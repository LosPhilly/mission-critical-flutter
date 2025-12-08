/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */

// lib\presentation\cubit\user_cubit.dart
// No import of 'user_repository_impl.dart' or 'server_exception.dart'
// MCF Rule 2.4: Logic imports ONLY from Domain, never Data.
import 'package:flightapp/domain/failures/failure.dart';
import 'package:flightapp/domain/repositories/i_user_repository.dart';
import 'package:flightapp/presentation/cubit/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final IUserRepository _repository;

  UserCubit(this._repository) : super(const UserInitial());

  Future<void> loadProfile() async {
    // MCF Rule 6.6: Reentrancy Guard.
    // If we are already loading, ignore the new request to prevent race conditions.
    if (state is UserLoading) return;

    emit(const UserLoading());
    try {
      final user = await _repository.getUserProfile();
      emit(UserLoaded(user));
    } on ServerFailure catch (e) {
      // 1. Handle Domain-defined Server Failure
      emit(UserError('Server Failure: ${e.message}'));
    } on ConnectionFailure catch (e) {
      // 2. Handle Domain-defined Connection Failure
      emit(UserError('Connectivity Issue: ${e.message}'));
    } on FormatFailure catch (e) {
      // 3. Handle Domain-defined Data Integrity Failure
      emit(UserError('Data Error: ${e.message}'));
    } catch (e) {
      // 4. Unknown/Critical Failure (Safety Net)
      emit(UserError('System Failure: ${e.toString()}'));
    }
  }
}
