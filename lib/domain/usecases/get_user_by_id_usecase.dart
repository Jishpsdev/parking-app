import '../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for getting a user by ID
class GetUserByIdUseCase {
  final UserRepository _repository;
  
  GetUserByIdUseCase(this._repository);
  
  Future<Result<User>> call(String userId) {
    return _repository.getUserById(userId);
  }
}
