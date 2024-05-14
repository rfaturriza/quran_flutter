import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/error/failures.dart';
import 'package:quranku/features/quran/data/dataSources/local/quran_local_data_source.dart';
import 'package:quranku/features/quran/data/models/detail_juz_model.codegen.dart';
import 'package:quranku/features/quran/data/models/last_read_juz_model.codegen.dart';
import 'package:quranku/features/quran/data/models/last_read_surah_model.codegen.dart';

import '../../../../../core/constants/hive_constants.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../models/detail_surah_model.codegen.dart';
import '../../models/surah_model.codegen.dart';

@LazySingleton(as: QuranLocalDataSource)
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  @override
  Future<Either<Failure, List<DataSurahModel>>> getAllSurah() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.surahBox);
      final listSurah = box.values.map((e) => jsonDecode(e)).toList();
      final result = listSurah.map((e) => DataSurahModel.fromJson(e)).toList();
      result.sort((a, b) {
        if (a.number == null || b.number == null) {
          // Handle cases where either a.number or b.number is null
          // You may decide to place these elements at the beginning or end of the list.
          // For example, to place them at the end:
          if (a.number == null) return 1;
          if (b.number == null) return -1;
        }
        return a.number!.compareTo(b.number!);
      });
      return right(result);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DataDetailJuzModel>> getDetailJuz(
      int juzNumber) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.detailJuzBox);
      final key = juzNumber.toString();
      final jsonString = box.get(key);
      final result = DataDetailJuzModel.fromJson(jsonDecode(jsonString));
      return right(result);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DataDetailSurahModel>> getDetailSurah(
      int surahNumber) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.detailSurahBox);
      final key = surahNumber.toString();
      final jsonString = box.get(key);
      final result = DataDetailSurahModel.fromJson(jsonDecode(jsonString));
      return right(result);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setAllSurah(List<DataSurahModel> surah) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.surahBox);
      for (var item in surah) {
        final key = item.number.toString();
        final jsonString = jsonEncode(item.toJson());
        await box.put(key, jsonString);
      }
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setDetailJuz(DataDetailJuzModel juz) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.detailJuzBox);
      final key = juz.juz.toString();
      final jsonString = jsonEncode(juz.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setDetailSurah(
      DataDetailSurahModel surah) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.detailSurahBox);
      final key = surah.number.toString();
      final jsonString = jsonEncode(surah.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<LastReadJuzModel>>> getLastReadJuz() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadJuzBox);
      final listJuz = box.values.map((e) => jsonDecode(e)).toList();
      final result = listJuz.map((e) => LastReadJuzModel.fromJson(e)).toList();
      return right(result);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<LastReadSurahModel>>> getLastReadSurah() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadSurahBox);
      final listSurah = box.values.map((e) => jsonDecode(e)).toList();
      final result =
          listSurah.map((e) => LastReadSurahModel.fromJson(e)).toList();
      return right(result);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setLastReadJuz(
    LastReadJuzModel juz,
  ) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadJuzBox);
      final key = juz.createdAt.millisecondsSinceEpoch.toString();
      final jsonString = jsonEncode(juz.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> setLastReadSurah(
    LastReadSurahModel surah,) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadSurahBox);
      final key = surah.createdAt.millisecondsSinceEpoch.toString();
      final jsonString = jsonEncode(surah.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllLastReadJuz() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadJuzBox);
      await box.clear();
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllLastReadSurah() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadSurahBox);
      await box.clear();
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLastReadJuz(DateTime createdAt) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadJuzBox);
      final key = createdAt.millisecondsSinceEpoch.toString();
      await box.delete(key);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLastReadSurah(DateTime createdAt) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.lastReadSurahBox);
      final key = createdAt.millisecondsSinceEpoch.toString();
      await box.delete(key);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
          message: LocaleKeys.defaultErrorMessage.tr(),
        ),
      );
    }
  }
}
