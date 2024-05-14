import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/features/shalat/domain/repositories/prayer_alarm_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_schedule_setting.codegen.dart';

@injectable
class GetPrayerScheduleSettingUseCase extends UseCase<PrayerScheduleSetting?, NoParams> {
  final PrayerAlarmRepository _repository;

  GetPrayerScheduleSettingUseCase(this._repository);

  @override
  Future<Either<Failure, PrayerScheduleSetting?>> call(
    NoParams params,
  ) async {
    return _repository.getPrayerAlarmSchedule();
  }
}
