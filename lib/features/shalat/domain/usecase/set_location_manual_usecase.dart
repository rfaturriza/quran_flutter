import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/features/shalat/domain/entities/geolocation.codegen.dart';
import 'package:quranku/features/shalat/domain/repositories/prayer_alarm_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class SetLocationManualUseCase extends UseCase<Unit, GeoLocation> {
  final PrayerAlarmRepository _repository;

  SetLocationManualUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(
    GeoLocation params,
  ) async {
    return _repository.setPrayerLocationManual(params);
  }
}
