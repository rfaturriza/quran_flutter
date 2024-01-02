import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/features/setting/domain/repositories/language_setting_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class GetLatinLanguageSetting extends UseCase<void, NoParams> {
  final LanguageSettingRepository repository;

  GetLatinLanguageSetting(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.getLatinLanguageSetting();
  }
}
