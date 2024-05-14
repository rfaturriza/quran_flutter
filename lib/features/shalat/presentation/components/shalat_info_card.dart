import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quranku/core/components/dialog.dart';
import 'package:quranku/core/utils/extension/context_ext.dart';
import 'package:quranku/core/utils/extension/dartz_ext.dart';
import 'package:quranku/core/utils/extension/extension.dart';
import 'package:quranku/core/utils/extension/string_ext.dart';
import 'package:quranku/features/quran/presentation/bloc/lastRead/last_read_cubit.dart';
import 'package:quranku/features/quran/presentation/screens/history_read_screen.dart';
import 'package:quranku/features/setting/presentation/bloc/language_setting/language_setting_bloc.dart';
import 'package:quranku/generated/locale_keys.g.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../quran/domain/entities/juz.codegen.dart';
import '../../../quran/domain/entities/surah.codegen.dart';
import '../../../quran/presentation/screens/components/juz_list.dart';
import '../../../quran/presentation/screens/components/surah_list.dart';
import '../bloc/shalat/shalat_bloc.dart';
import '../helper/helper_time_shalat.dart';
import '../screens/prayer_schedule_screen.dart';

class ShalatInfoCard extends StatelessWidget {
  const ShalatInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final shalatBloc = context.read<ShalatBloc>();
    return BlocListener<ShalatBloc, ShalatState>(
      listener: (context, state) {
        if (state.locationStatus?.status.isNotGranted == true) {
          AppDialog.showPermissionDialog(
            context,
            content: LocaleKeys.permissionMessageLocation.tr(),
            onOk: () async {
              final p = await Geolocator.requestPermission();
              shalatBloc.add(
                ShalatEvent.onChangedLocationStatusEvent(
                  status: LocationStatus(
                    true,
                    p,
                  ),
                ),
              );
            },
          );
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: ShapeDecoration(
              image: const DecorationImage(
                image: CachedNetworkImageProvider(
                  AssetConst.backgroundShalatTimeCardNetwork,
                ),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  context.theme.colorScheme.surfaceContainer.withAlpha(200),
                  context.theme.colorScheme.surfaceContainer.withAlpha(180)
                ], // Customize your gradient colors
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17.5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: const _PrayTimeInfo(),
                    onTap: () {
                      context.navigateTo(const PrayerScheduleScreen());
                    },
                  ),
                  const Divider(thickness: 2),
                  const _LastReadInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayTimeInfo extends StatelessWidget {
  const _PrayTimeInfo();

  @override
  Widget build(BuildContext context) {
    final shalatBloc = context.read<ShalatBloc>();
    return BlocBuilder<LanguageSettingBloc, LanguageSettingState>(
      buildWhen: (p, c) => p.languagePrayerTime != c.languagePrayerTime,
      builder: (context, languageSettingState) {
        return BlocBuilder<ShalatBloc, ShalatState>(
          builder: (context, state) {
            final shalat = () {
              if (state.scheduleByDay?.isRight() == true) {
                return HelperTimeShalat.getShalatNameByTime(
                  state.scheduleByDay?.asRight()?.schedule,
                  languageSettingState.languagePrayerTime,
                );
              }
              return emptyString;
            }();

            final shalatTime = () {
              if (state.scheduleByDay?.isRight() == true) {
                return HelperTimeShalat.getShalatTimeByShalatName(
                  state.scheduleByDay?.asRight()?.schedule,
                  shalat,
                  languageSettingState.languagePrayerTime,
                );
              }
              return emptyString;
            }();

            final place = state.geoLocation?.place ?? '-';
            if (state.isLoading) {
              return const Center(child: LinearProgressIndicator());
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.scheduleByDay?.isRight() == true) ...[
                        Text(
                          shalat.capitalize(),
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          shalatTime ?? '-',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                      if (state.scheduleByDay?.isLeft() == true) ...[
                        IconButton(
                          onPressed: () {
                            context.read<ShalatBloc>().add(
                                  const ShalatEvent
                                      .getShalatScheduleByDayEvent(),
                                );
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                      if (state.locationStatus?.status.isNotGranted ==
                          true) ...[
                        IconButton(
                          onPressed: () async {
                            final p = await Geolocator.requestPermission();
                            shalatBloc.add(
                              ShalatEvent.onChangedLocationStatusEvent(
                                status: LocationStatus(
                                  true,
                                  p,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.autorenew_rounded),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (state.scheduleByDay?.isLeft() == true) ...[
                        Text(
                          state.scheduleByDay?.asLeft().message ?? emptyString,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                      if (state.scheduleByDay?.isRight() == true) ...[
                        Text(
                          place,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: context.theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                      if (state.locationStatus?.status.isNotGranted ==
                          true) ...[
                        Text(
                          LocaleKeys.requestAccessLocation.tr(),
                          style: context.textTheme.titleSmall?.copyWith(
                            color: context.theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _LastReadInfo extends StatelessWidget {
  const _LastReadInfo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LastReadCubit, LastReadState>(
      builder: (context, state) {
        if (state.lastReadSurah.isEmpty && state.lastReadJuz.isEmpty) {
          return const SizedBox();
        }
        var lastReadSurah =
            state.lastReadSurah.isEmpty ? null : state.lastReadSurah.last;
        var lastReadJuz =
            state.lastReadJuz.isEmpty ? null : state.lastReadJuz.last;
        var lastReadText = emptyString;
        void setLastReadTextSurah() {
          lastReadText = LocaleKeys.yourLastSurahReading.tr(
            args: [
              lastReadSurah?.surahName?.transliteration?.asLocale(
                    context.locale,
                  ) ??
                  emptyString,
              lastReadSurah?.versesNumber.inSurah.toString() ?? emptyString,
            ],
          );
        }

        void setLastReadTextJuz() {
          lastReadText = LocaleKeys.yourLastJuzReading.tr(
            args: [
              lastReadJuz?.name ?? emptyString,
              lastReadJuz?.versesNumber.inSurah.toString() ?? emptyString,
            ],
          );
        }

        if (lastReadSurah != null && lastReadJuz != null) {
          if (lastReadSurah.createdAt.isAfter(lastReadJuz.createdAt)) {
            setLastReadTextSurah();
          }
          if (lastReadSurah.createdAt.isBefore(lastReadJuz.createdAt)) {
            setLastReadTextJuz();
          }
        } else {
          if (lastReadSurah != null) {
            setLastReadTextSurah();
          } else {
            setLastReadTextJuz();
          }
        }

        final progress = lastReadSurah?.progress ?? lastReadJuz?.progress ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastReadText.split(':').first,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  lastReadText.split(':').last,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.navigateTo(const HistoryReadScreen());
                  },
                  icon: const Icon(
                    Icons.list_alt_rounded,
                  ),
                  color: context.theme.colorScheme.onSurface,
                ),
                InkWell(
                  onTap: () {
                    if (!lastReadText.contains('Juz')) {
                      SurahList.onTapSurah(
                        context,
                        Surah(
                          number: lastReadSurah?.surahNumber,
                          name: lastReadSurah?.surahName,
                        ),
                        jumpToVerse: lastReadSurah?.versesNumber.inSurah ?? 0,
                      );
                    } else {
                      JuzList.onTapJuz(
                        context,
                        JuzConstant(
                          number: lastReadJuz?.number ?? 0,
                          name: lastReadJuz?.name ?? emptyString,
                          description: lastReadJuz?.description ?? emptyString,
                        ),
                        jumpToVerse: lastReadJuz?.versesNumber.inQuran ?? 0,
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          foregroundColor:
                              context.theme.colorScheme.onTertiaryContainer,
                          backgroundColor: context
                              .theme.colorScheme.tertiaryContainer
                              .withAlpha(150),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
