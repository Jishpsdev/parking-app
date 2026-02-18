import '../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use Case for getting current user with their permissions
class GetCurrentUserUseCase {
  final UserRepository _repository;
  
  GetCurrentUserUseCase({
    required UserRepository repository,
  }) : _repository = repository;
  
  Future<Result<User>> call() async {
    return await _repository.getCurrentUser();
  }
}
