import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/constants/hive_constants.dart';
import 'package:quranku/core/error/failures.dart';
import 'package:quranku/core/utils/extension/string_ext.dart';
import 'package:quranku/features/bookmark/data/models/juz_bookmark_model.codegen.dart';
import 'package:quranku/features/bookmark/data/models/surah_bookmark_model.codegen.dart';
import 'package:quranku/features/bookmark/data/models/verse_bookmark_model.codegen.dart';
import 'package:quranku/generated/locale_keys.g.dart';

import 'bookmark_local_data_source.dart';

@LazySingleton(as: BookmarkLocalDataSource)
class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  @override
  Future<Either<Failure, Unit>> addJuzBookmark(
      JuzBookmarkModel juzBookmark) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.juzBookmarkBox);
      final key = juzBookmark.number.toString();
      final jsonString = jsonEncode(juzBookmark.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
            message: LocaleKeys.errorAddingJuzBookmark.tr(
          args: [juzBookmark.number.toString()],
        )),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> addSurahBookmark(
    SurahBookmarkModel surahBookmark,
  ) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.surahBookmarkBox);
      final key = surahBookmark.surahName.short ?? emptyString;
      final jsonString = jsonEncode(surahBookmark.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
            message: LocaleKeys.errorAddingSurahBookmark.tr(
          args: [surahBookmark.surahName.short ?? emptyString],
        )),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> addVerseBookmark(
    VerseBookmarkModel verseBookmark,
  ) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.verseBookmarkBox);
      final key = verseBookmark.verseNumber.toString();
      final jsonString = jsonEncode(verseBookmark.toJson());
      await box.put(key, jsonString);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(
            message: LocaleKeys.errorAddingVerseBookmark.tr(
          args: [
            (verseBookmark.surahName?.short ?? emptyString),
            verseBookmark.verseNumber.toString(),
          ],
        )),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteJuzBookmark(
    JuzBookmarkModel juzBookmark,
  ) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.juzBookmarkBox);
      final key = juzBookmark.number.toString();
      await box.delete(key);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(message: LocaleKeys.errorRemovingJuzBookmark.tr(
          args: [juzBookmark.number.toString()],
        )),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSurahBookmark(
    SurahBookmarkModel surahBookmark,
  ) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.surahBookmarkBox);
      final key = surahBookmark.surahName.short;
      await box.delete(key);
      return right(unit);
    } catch (e) {
      return Future.value(
        left(
          CacheFailure(message: LocaleKeys.errorRemovingSurahBookmark.tr(
            args: [surahBookmark.surahName.short ?? emptyString],
          )),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVerseBookmark(
    VerseBookmarkModel verseBookmark,
  ) async {
    try {
      var box = await Hive.openBox(HiveBoxConst.verseBookmarkBox);
      final key = verseBookmark.verseNumber.toString();
      await box.delete(key);
      return right(unit);
    } catch (e) {
      return left(
        CacheFailure(message: LocaleKeys.errorRemovingVerseBookmark.tr(
          args: [
            (verseBookmark.surahName?.short ?? emptyString),
            verseBookmark.verseNumber.toString(),
          ],
        )),
      );
    }
  }

  @override
  Future<Either<Failure, List<JuzBookmarkModel>>> getListJuzBookmark() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.juzBookmarkBox);
      final list = box.values.map((e) => jsonDecode(e)).toList();
      final result = list.map((e) => JuzBookmarkModel.fromJson(e)).toList();
      return Future.value(right(result));
    } catch (e) {
      return Future.value(
        left(
          CacheFailure(message: LocaleKeys.errorGettingJuzBookmarks.tr()),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<SurahBookmarkModel>>> getListSurahBookmark() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.surahBookmarkBox);
      final list = box.values.map((e) => jsonDecode(e)).toList();
      final result = list.map((e) => SurahBookmarkModel.fromJson(e)).toList();
      return Future.value(right(result));
    } catch (e) {
      return Future.value(
        left(
          CacheFailure(message: LocaleKeys.errorGettingSurahBookmarks.tr()),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<VerseBookmarkModel>>> getListVersesBookmark() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.verseBookmarkBox);
      final list = box.values.map((e) => jsonDecode(e)).toList();
      final result = list.map((e) => VerseBookmarkModel.fromJson(e)).toList();
      return Future.value(right(result));
    } catch (e) {
      return Future.value(
        left(
          CacheFailure(message: LocaleKeys.errorGettingVerseBookmarks.tr()),
        ),
      );
    }
  }
}
