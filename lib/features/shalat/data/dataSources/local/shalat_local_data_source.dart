import 'package:dartz/dartz.dart';
import 'package:quranku/core/error/failures.dart';
import 'package:quranku/features/shalat/data/models/prayer_schedule_setting_model.codegen.dart';
import 'package:quranku/features/shalat/data/models/schedule_model.codegen.dart';

import '../../../domain/entities/geolocation.codegen.dart';

abstract class ShalatLocalDataSource {
  Future<Either<Failure, Unit>> setPrayerScheduleSetting(
    PrayerScheduleSettingModel? model,
  );

  Future<Either<Failure, PrayerScheduleSettingModel?>> getPrayerScheduleSetting();

  Future<Either<Failure, Unit>> setPrayerLocationManual(
    GeoLocation? model,
  );

  Future<Either<Failure, GeoLocation?>> getPrayerLocationManual();
}
