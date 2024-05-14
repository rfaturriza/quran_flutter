import 'package:adhan/adhan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import '../../domain/entities/prayer_schedule_setting.codegen.dart';

part 'prayer_schedule_setting_model.codegen.freezed.dart';
part 'prayer_schedule_setting_model.codegen.g.dart';

@freezed
@HiveType(typeId: HiveTypeConst.prayerScheduleSettingModel)
class PrayerScheduleSettingModel with _$PrayerScheduleSettingModel {
  const factory PrayerScheduleSettingModel({
    @HiveField(0) @Default([]) List<PrayerAlarmModel> alarms,
    @HiveField(1) @Default('egyptian') String calculationMethod,
    @HiveField(2) @Default('shafi') String madhab,
  }) = _PrayerScheduleSettingModel;

  const PrayerScheduleSettingModel._();

  factory PrayerScheduleSettingModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerScheduleSettingModelFromJson(json);

  factory PrayerScheduleSettingModel.fromEntity(PrayerScheduleSetting? entity) {
    return PrayerScheduleSettingModel(
      calculationMethod: entity?.calculationMethod.name ?? CalculationMethod.egyptian.name,
      madhab: entity?.madhab.name ?? Madhab.shafi.name,
      alarms: entity?.alarms
              .map((e) => PrayerAlarmModel.fromEntity(
                    e,
                  ))
              .toList() ??
          [],
    );
  }

  PrayerScheduleSetting toEntity() {
    return PrayerScheduleSetting(
      alarms: alarms.map((e) => e.toEntity()).toList(),
      calculationMethod: CalculationMethod.values.firstWhere(
        (element) => element.name == calculationMethod,
      ),
      madhab: Madhab.values.firstWhere(
        (element) => element.name == madhab,
      ),
    );
  }
}

@freezed
@HiveType(typeId: HiveTypeConst.prayerAlarmModel)
class PrayerAlarmModel with _$PrayerAlarmModel {
  const factory PrayerAlarmModel({
    @HiveField(0) DateTime? time,
    @HiveField(1) String? prayer,
    @HiveField(2) @Default(false) bool isAlarmActive,
  }) = _PrayerAlarmModel;

  const PrayerAlarmModel._();

  factory PrayerAlarmModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerAlarmModelFromJson(json);

  factory PrayerAlarmModel.fromEntity(PrayerAlarm? entity) {
    return PrayerAlarmModel(
      time: entity?.time,
      prayer: entity?.prayer?.name,
      isAlarmActive: entity?.isAlarmActive ?? false,
    );
  }

  PrayerAlarm toEntity() {
    return PrayerAlarm(
      time: time,
      prayer: Prayer.values.firstWhere(
        (element) => element.name == prayer,
      ),
      isAlarmActive: isAlarmActive,
    );
  }
}
