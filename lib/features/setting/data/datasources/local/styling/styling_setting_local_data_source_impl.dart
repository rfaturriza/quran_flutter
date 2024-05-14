import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/features/setting/data/datasources/local/styling/styling_setting_local_data_source.dart';

import '../../../../../../core/constants/hive_constants.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../domain/entities/last_read_reminder_mode_entity.dart';

@LazySingleton(as: StylingSettingLocalDataSource)
class StylingSettingLocalDataSourceImpl
    implements StylingSettingLocalDataSource {
  final HiveInterface hive;

  StylingSettingLocalDataSourceImpl({
    required this.hive,
  });

  @override
  Future<Either<Failure, String?>> getArabicFontFamily() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final String? fontFamily = await box.get(HiveKeyConst.arabicFontFamilyKey);
      return right(fontFamily);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, double?>> getArabicFontSize() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final double? fontSize = await box.get(HiveKeyConst.arabicFontSizeKey);
      return right(fontSize);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, double?>> getLatinFontSize() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final double? fontSize = await box.get(HiveKeyConst.latinFontSizeKey);
      return right(fontSize);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, double?>> getTranslationFontSize() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final double? fontSize = await box.get(HiveKeyConst.translationFontSizeKey);
      return right(fontSize);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setArabicFontFamily(String fontFamily) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.arabicFontFamilyKey, fontFamily);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setArabicFontSize(double fontSize) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.arabicFontSizeKey, fontSize);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setLatinFontSize(double fontSize) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.latinFontSizeKey, fontSize);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setTranslationFontSize(double fontSize) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.translationFontSizeKey, fontSize);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setLastReadReminder(LastReadReminderModes mode) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.lastReadRemindersModeKey, mode.name);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, LastReadReminderModes>> getLastReadReminder() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final mode = box.get(HiveKeyConst.lastReadRemindersModeKey);
      final LastReadReminderModes isReminders = LastReadReminderModes.values.firstWhere(
        (e) => e.name == mode,
      );
      return right(isReminders);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool?>> getShowLatin() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final bool? isShowLatins = await box.get(HiveKeyConst.latinLanguageKey);
      return right(isShowLatins);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool?>> getShowTranslation() async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      final bool? isShowTranslations =
          await box.get(HiveKeyConst.translationFontSizeKey);
      return right(isShowTranslations);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setShowLatin(bool isShow) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.latinLanguageKey, isShow);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setShowTranslation(bool isShow) async {
    try {
      var box = await hive.openBox(HiveBoxConst.settingBox);
      await box.put(HiveKeyConst.translationFontSizeKey, isShow);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
