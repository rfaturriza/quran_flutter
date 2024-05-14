import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:quranku/core/constants/hive_constants.dart';
import 'package:quranku/features/shalat/data/models/schedule_model.codegen.dart';

part 'schedule.codegen.freezed.dart';
part 'schedule.codegen.g.dart';

@freezed
class ScheduleByDay with _$ScheduleByDay {
  const factory ScheduleByDay({
    String? id,
    String? location,
    String? area,
    Coordinate? coordinate,
    Schedule? schedule,
    PrayerTimes? prayerTimes,
  }) = _ScheduleByDay;

  const ScheduleByDay._();

  DataScheduleByDayModel toModel() => DataScheduleByDayModel(
        id: id,
        location: location,
        area: area,
        coordinate: coordinate?.toModel(),
        schedule: schedule?.toModel(),
      );
}

@freezed
class ScheduleByMonth with _$ScheduleByMonth {
  const factory ScheduleByMonth({
    String? id,
    String? location,
    String? area,
    Coordinate? coordinate,
    List<Schedule>? schedule,
  }) = _ScheduleByMonth;

  const ScheduleByMonth._();

  DataScheduleByMonthModel toModel() => DataScheduleByMonthModel(
        id: id,
        location: location,
        area: area,
        coordinate: coordinate?.toModel(),
        schedule: schedule?.map((e) => e.toModel()).toList(),
      );
}

@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    String? date,
    String? imsak,
    String? subuh,
    String? syuruq,
    String? dhuha,
    String? dzuhur,
    String? ashar,
    String? maghrib,
    String? isya,
  }) = _Schedule;

  const Schedule._();

  ScheduleModel toModel() => ScheduleModel(
        date: date,
        imsak: imsak,
        subuh: subuh,
        syuruq: syuruq,
        dhuha: dhuha,
        dzuhur: dzuhur,
        ashar: ashar,
        maghrib: maghrib,
        isya: isya,
      );

  factory Schedule.fromPrayerTimes(PrayerTimes prayerTimes) => Schedule(
        date: DateTime.now().timeZoneName,
        imsak:
            "${DateFormat.Hm().format(prayerTimes.fajr.subtract(const Duration(minutes: 10)))} ${prayerTimes.fajr.timeZoneName}",
        subuh:
            "${DateFormat.Hm().format(prayerTimes.fajr)} ${prayerTimes.fajr.timeZoneName}",
        syuruq:
            "${DateFormat.Hm().format(prayerTimes.sunrise)} ${prayerTimes.sunrise.timeZoneName}",
        dhuha:
            "${DateFormat.Hm().format(prayerTimes.sunrise.add(const Duration(minutes: 30)))} ${prayerTimes.sunrise.timeZoneName}",
        dzuhur:
            "${DateFormat.Hm().format(prayerTimes.dhuhr)} ${prayerTimes.dhuhr.timeZoneName}",
        ashar:
            "${DateFormat.Hm().format(prayerTimes.asr)} ${prayerTimes.asr.timeZoneName}",
        maghrib:
            "${DateFormat.Hm().format(prayerTimes.maghrib)} ${prayerTimes.maghrib.timeZoneName}",
        isya:
            "${DateFormat.Hm().format(prayerTimes.isha)} ${prayerTimes.isha.timeZoneName}",
      );
}

@freezed
@HiveType(typeId: HiveTypeConst.coordinate)
class Coordinate with _$Coordinate {
  const factory Coordinate({
    @HiveField(0) double? lat,
    @HiveField(1) double? lon,
    @HiveField(2) String? latitude,
    @HiveField(3) String? longitude,
  }) = _Coordinate;

  const Coordinate._();

  CoordinateModel toModel() => CoordinateModel(
        lat: lat,
        lon: lon,
        latitude: latitude,
        longitude: longitude,
      );
}
