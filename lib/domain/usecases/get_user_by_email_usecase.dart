import '../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use Case for getting a user by their email address
class GetUserByEmailUseCase {
  final UserRepository _repository;

  GetUserByEmailUseCase({
    required UserRepository repository,
  }) : _repository = repository;

  Future<Result<User>> call({required String email}) async {
    return await _repository.getUserByEmail(email);
  }
}
