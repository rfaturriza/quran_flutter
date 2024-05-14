import 'dart:ui';

import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/schedule.codegen.dart';

class HelperTimeShalat {
  static List<String> prayerNameByLocale(Locale? locale) {
    switch (locale?.languageCode) {
      case 'en':
        return [
          'Imsak',
          'Fajr',
          'Sunrise',
          'Dhuha',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];
      case 'id':
        return [
          'Imsak',
          'Subuh',
          'Terbit',
          'Dhuha',
          'Dzuhur',
          'Ashar',
          'Maghrib',
          'Isya',
        ];
      case 'ar':
        return [
          'الإمساك',
          'الفجر',
          'الشروق',
          'الضحى',
          'الظهر',
          'العصر',
          'المغرب',
          'العشاء',
        ];

      case 'az':
        return [
          'İmsaq',
          'Fəcr',
          'Günəş',
          'Döhr',
          'Əsr',
          'Məğrib',
          'Axşam',
        ];
      case 'ms':
        return [
          'Imsak',
          'Subuh',
          'Terbit',
          'Dhuha',
          'Zohor',
          'Asar',
          'Maghrib',
          'Isyak',
        ];
      case 'da':
        return [
          'Imsak',
          'Fajr',
          'Solopgang',
          'Dhuha',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];

      case 'de':
        return [
          'Imsak',
          'Fadschr',
          'Sonnenaufgang',
          'Dhuha',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];
      case 'fr':
        return [
          'Imsak',
          'Sobh',
          'Lever du soleil',
          'Dhuha',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];
      case 'tr':
        return [
          'Imsak',
          'Sabah',
          'gündoğumu',
          'Dhuha',
          'Öğle',
          'İkindi',
          'Akşam',
          'Yatsı',
        ];
      case 'ru':
        return [
          'Imsak',
          'Фаджр',
          'Восход',
          'Духа',
          'Зухр',
          'Аср',
          'Магриб',
          'Иша',
        ];
      default:
        return [
          'Imsak',
          'Subuh',
          'Syuruq',
          'Dhuha',
          'Dzuhur',
          'Ashar',
          'Maghrib',
          'Isya'
        ];
    }
  }

  static String getShalatNameByTime(
    Schedule? schedule,
    Locale? locale,
  ) {
    if (schedule == null) return '-';
    final String? timeImsak = schedule.imsak;
    final String? timeSubuh = schedule.subuh;
    final String? timeTerbit = schedule.syuruq;
    final String? timeDhuha = schedule.dhuha;
    final String? timeDzuhur = schedule.dzuhur;
    final String? timeAshar = schedule.ashar;
    final String? timeMaghrib = schedule.maghrib;
    final String? timeIsya = schedule.isya;

    final dateTimeNow = DateTime.now();
    DateTime parseTime(String? time) {
      if (time == null) {
        throw ArgumentError("Time cannot be null");
      }
      final hourAndMinute = (time.contains(' ')) ? time.split(' ')[0] : time;
      final splitTime = hourAndMinute.split(RegExp(r'[.:]'));
      final hour = int.parse(splitTime[0]);
      final minute = int.parse(splitTime[1]);
      final dateTimeNow = DateTime.now();
      final format = DateFormat('yyyy-MM-dd HH:mm');

      return format.parse(
        '${dateTimeNow.year}-${dateTimeNow.month.toString().padLeft(2, '0')}-${dateTimeNow.day.toString().padLeft(2, '0')} $hour:$minute',
      );
    }

    if (timeImsak != null && dateTimeNow.isBefore(parseTime(timeImsak))) {
      return prayerNameByLocale(locale)[0];
    } else if (timeSubuh != null &&
        dateTimeNow.isBefore(parseTime(timeSubuh))) {
      return prayerNameByLocale(locale)[1];
    } else if (timeTerbit != null &&
        dateTimeNow.isBefore(parseTime(timeTerbit))) {
      return prayerNameByLocale(locale)[2];
    } else if (timeDhuha != null &&
        dateTimeNow.isBefore(parseTime(timeDhuha))) {
      return prayerNameByLocale(locale)[3];
    } else if (timeDzuhur != null &&
        dateTimeNow.isBefore(parseTime(timeDzuhur))) {
      return prayerNameByLocale(locale)[4];
    } else if (timeAshar != null &&
        dateTimeNow.isBefore(parseTime(timeAshar))) {
      return prayerNameByLocale(locale)[5];
    } else if (timeMaghrib != null &&
        dateTimeNow.isBefore(parseTime(timeMaghrib))) {
      return prayerNameByLocale(locale)[6];
    } else if (timeIsya != null && dateTimeNow.isBefore(parseTime(timeIsya))) {
      return prayerNameByLocale(locale)[7];
    } else {
      return prayerNameByLocale(locale)[0];
    }
  }

  static String? getShalatTimeByShalatName(
    Schedule? schedule,
    String shalatName,
    Locale? locale,
  ) {
    if (schedule == null) return '-';
    final prayerByLocale =
        prayerNameByLocale(locale).map((e) => e.toLowerCase()).toList();
    final currentPrayer = shalatName.toLowerCase();
    if (currentPrayer == prayerByLocale[0]) {
      return schedule.imsak;
    } else if (currentPrayer == prayerByLocale[1]) {
      return schedule.subuh;
    } else if (currentPrayer == prayerByLocale[2]) {
      return schedule.syuruq;
    } else if (currentPrayer == prayerByLocale[3]) {
      return schedule.dhuha;
    } else if (currentPrayer == prayerByLocale[4]) {
      return schedule.dzuhur;
    } else if (currentPrayer == prayerByLocale[5]) {
      return schedule.ashar;
    } else if (currentPrayer == prayerByLocale[6]) {
      return schedule.maghrib;
    } else if (currentPrayer == prayerByLocale[7]) {
      return schedule.isya;
    } else {
      return '-';
    }
  }

  static String getPrayerNameByEnum(Prayer prayer, Locale? locale) {
    switch (prayer) {
      case Prayer.fajr:
        return prayerNameByLocale(locale)[1];
      case Prayer.sunrise:
        return prayerNameByLocale(locale)[2];
      case Prayer.dhuhr:
        return prayerNameByLocale(locale)[4];
      case Prayer.asr:
        return prayerNameByLocale(locale)[5];
      case Prayer.maghrib:
        return prayerNameByLocale(locale)[6];
      case Prayer.isha:
        return prayerNameByLocale(locale)[7];
      default:
        return '-';
    }
  }
}
