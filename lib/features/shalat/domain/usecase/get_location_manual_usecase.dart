import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/features/shalat/domain/entities/geolocation.codegen.dart';
import 'package:quranku/features/shalat/domain/repositories/prayer_alarm_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class GetLocationManualUseCase extends UseCase<GeoLocation, NoParams> {
  final PrayerAlarmRepository _repository;

  GetLocationManualUseCase(this._repository);

  @override
  Future<Either<Failure, GeoLocation?>> call(
    NoParams params,
  ) async {
    return _repository.getPrayerLocationManual();
  }
}
