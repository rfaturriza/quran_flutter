import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/features/shalat/domain/repositories/prayer_alarm_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_schedule_setting.codegen.dart';

@injectable
class SetPrayerScheduleSettingUseCase extends UseCase<Unit, PrayerScheduleSetting?> {
  final PrayerAlarmRepository _repository;

  SetPrayerScheduleSettingUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(
    PrayerScheduleSetting? params,
  ) async {
    return _repository.setPrayerAlarmSchedule(params);
  }
}
