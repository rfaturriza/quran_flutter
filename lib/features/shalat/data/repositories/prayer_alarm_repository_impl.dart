import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/error/failures.dart';
import 'package:quranku/features/shalat/data/models/prayer_schedule_setting_model.codegen.dart';
import 'package:quranku/features/shalat/domain/entities/geolocation.codegen.dart';
import 'package:quranku/features/shalat/domain/entities/prayer_schedule_setting.codegen.dart';

import '../../domain/repositories/prayer_alarm_repository.dart';
import '../dataSources/local/shalat_local_data_source.dart';

@LazySingleton(as: PrayerAlarmRepository)
class PrayerAlarmRepositoryImpl implements PrayerAlarmRepository {
  final ShalatLocalDataSource localDataSource;

  const PrayerAlarmRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PrayerScheduleSetting?>> getPrayerAlarmSchedule() async {
    final result = await localDataSource.getPrayerScheduleSetting();
    return result.fold((error) => left(error), (r) => right(r?.toEntity()));
  }

  @override
  Future<Either<Failure, GeoLocation?>> getPrayerLocationManual() async {
    final result = await localDataSource.getPrayerLocationManual();
    return result;
  }

  @override
  Future<Either<Failure, Unit>> setPrayerAlarmSchedule(
    PrayerScheduleSetting? model,
  ) async {
    final result = await localDataSource
        .setPrayerScheduleSetting(PrayerScheduleSettingModel.fromEntity(model));
    return result.fold((error) => left(error), (r) => right(r));
  }

  @override
  Future<Either<Failure, Unit>> setPrayerLocationManual(
    GeoLocation? location,
  ) async {
    final result = await localDataSource.setPrayerLocationManual(location);
    return result.fold((error) => left(error), (r) => right(r));
  }
}
