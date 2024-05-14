import 'package:adhan/adhan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_schedule_setting.codegen.freezed.dart';

@freezed
class PrayerScheduleSetting with _$PrayerScheduleSetting {
  const factory PrayerScheduleSetting({
    @Default([]) List<PrayerAlarm> alarms,
    @Default(CalculationMethod.egyptian) CalculationMethod calculationMethod,
    @Default(Madhab.shafi) Madhab madhab,
  }) = _PrayerScheduleSetting;
}

@freezed
class PrayerAlarm with _$PrayerAlarm {
  const factory PrayerAlarm({
    DateTime? time,
    Prayer? prayer,
    @Default(false) bool isAlarmActive,
  }) = _PrayerAlarm;
}
