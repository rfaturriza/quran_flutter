import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:quranku/core/utils/extension/context_ext.dart';
import 'package:quranku/core/utils/extension/dartz_ext.dart';
import 'package:quranku/core/utils/extension/string_ext.dart';
import 'package:quranku/features/quran/presentation/screens/components/app_bar_detail_screen.dart';
import 'package:quranku/features/shalat/domain/entities/prayer_schedule_setting.codegen.dart';
import 'package:quranku/features/shalat/presentation/helper/helper_time_shalat.dart';

import '../bloc/shalat/shalat_bloc.dart';

class PrayerScheduleScreen extends StatelessWidget {
  const PrayerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ShalatBloc>()
        ..add(
          const ShalatEvent.getPrayerScheduleSettingEvent(),
        ),
      child: Scaffold(
        appBar: const AppBarDetailScreen(
          title: 'Jadwal Shalat',
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _InfoSection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Notifikasi Jadwal Shalat',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const _PrayerScheduleSection(),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    final dateString = DateFormat(
      'EEEE, dd MMMM yyyy',
      context.locale.languageCode,
    ).format(dateNow);
    final hijriDate = JHijri.now();
    final hijriDateString =
        '${hijriDate.day} ${englishHMonth(hijriDate.month)} ${hijriDate.year}';
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              dateString,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(hijriDateString),
          ),
          BlocBuilder<ShalatBloc, ShalatState>(
            builder: (context, state) {
              return ListTile(
                title: Text(
                  'Lokasi',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle:
                    Text(state.geoLocation?.place ?? 'Lokasi tidak ditemukan'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_location_alt),
                  onPressed: () {},
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const _LocationSettingPickerDialog();
                    },
                  );
                },
              );
            },
          ),
          BlocBuilder<ShalatBloc, ShalatState>(
            buildWhen: (p, c) =>
                p.prayerScheduleSetting != c.prayerScheduleSetting,
            builder: (context, state) {
              return ListTile(
                title: Text(
                  'Perhitungan',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Metode - ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: state.prayerScheduleSetting
                                    ?.asRight()
                                    ?.calculationMethod
                                    .name
                                    .capitalizeEveryWord() ??
                                '-',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Mazhab - ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: state.prayerScheduleSetting
                                    ?.asRight()
                                    ?.madhab
                                    .name
                                    .capitalizeEveryWord() ??
                                '-',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return const _BottomSheetCalculationSetting();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomSheetCalculationSetting extends StatelessWidget {
  const _BottomSheetCalculationSetting();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShalatBloc, ShalatState>(
      builder: (context, state) {
        return SafeArea(
          child: Wrap(children: [
            Column(
              children: [
                ListTile(
                  title: Text(
                    'Metode Perhitungan',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    state.prayerScheduleSetting
                            ?.asRight()
                            ?.calculationMethod
                            .name
                            .capitalizeEveryWord() ??
                        '-',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const _CalculationMethodPickerDialog();
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Mazhab',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    state.prayerScheduleSetting
                            ?.asRight()
                            ?.madhab
                            .name
                            .capitalizeEveryWord() ??
                        '-',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const _MadhabPickerDialog();
                      },
                    );
                  },
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}

class _LocationSettingPickerDialog extends StatelessWidget {
  const _LocationSettingPickerDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ListTile.divideTiles(
          color: context.theme.dividerColor,
          context: context,
          tiles: [
            'Auto',
            'Manual',
          ].map((mode) {
            return ListTile(
              tileColor: mode == 'Auto'
                  ? context.theme.primaryColor.withOpacity(0.1)
                  : null,
              title: Text(
                mode,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}

class _CalculationMethodPickerDialog extends StatelessWidget {
  const _CalculationMethodPickerDialog();

  @override
  Widget build(BuildContext context) {
    final setting =
        context.read<ShalatBloc>().state.prayerScheduleSetting?.asRight();
    final calculationMethod = setting?.calculationMethod;
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ListTile.divideTiles(
          color: context.theme.dividerColor,
          context: context,
          tiles: CalculationMethod.values.map((val) {
            return ListTile(
              tileColor: val.name == calculationMethod?.name
                  ? context.theme.primaryColor.withOpacity(0.1)
                  : null,
              title: Text(
                val.name.capitalizeEveryWord(),
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                context.read<ShalatBloc>().add(
                      ShalatEvent.setPrayerScheduleSettingEvent(
                        model: setting?.copyWith(
                          calculationMethod: val,
                        ),
                      ),
                    );
                Navigator.pop(context);
              },
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}

class _MadhabPickerDialog extends StatelessWidget {
  const _MadhabPickerDialog();

  @override
  Widget build(BuildContext context) {
    final setting =
        context.read<ShalatBloc>().state.prayerScheduleSetting?.asRight();
    final madhab = setting?.madhab;
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ListTile.divideTiles(
          color: context.theme.dividerColor,
          context: context,
          tiles: Madhab.values.map((val) {
            return ListTile(
              tileColor: val.name == madhab?.name
                  ? context.theme.primaryColor.withOpacity(0.1)
                  : null,
              title: Text(
                val.name.capitalizeEveryWord(),
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                context.read<ShalatBloc>().add(
                      ShalatEvent.setPrayerScheduleSettingEvent(
                        model: setting?.copyWith(
                          madhab: val,
                        ),
                      ),
                    );
                Navigator.pop(context);
              },
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}

class _PrayerScheduleSection extends StatelessWidget {
  const _PrayerScheduleSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShalatBloc, ShalatState>(
      buildWhen: (p, c) => p.prayerScheduleSetting != c.prayerScheduleSetting,
      builder: (context, state) {
        if (state.prayerScheduleSetting?.isLeft() == true) {
          return Card(
            child: ListTile(
              title: Text(
                state.prayerScheduleSetting?.asLeft().message ??
                    'Tidak ada jadwal shalat',
              ),
            ),
          );
        }
        final schedule = state.prayerScheduleSetting?.asRight();
        final alarms = schedule?.alarms ?? [];
        return Card(
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: Prayer.values.map((prayer) {
                if (prayer == Prayer.none) return const SizedBox();
                final time = () {
                  final params = CalculationMethod.egyptian.getParameters();
                  params.madhab = Madhab.shafi;
                  final coordinate = Coordinates(
                    state.geoLocation?.coordinate?.lat ?? 0,
                    state.geoLocation?.coordinate?.lon ?? 0,
                    validate: true,
                  );
                  final prayerTimes = PrayerTimes(
                    coordinate,
                    DateComponents.from(DateTime.now()),
                    params,
                  );
                  return prayerTimes;
                }();
                return ListTile(
                  title: Text(
                    HelperTimeShalat.getPrayerNameByEnum(
                      prayer,
                      context.locale,
                    ),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    () {
                      if (time.timeForPrayer(prayer) == null) return '';
                      return DateFormat('HH:mm')
                          .format(time.timeForPrayer(prayer)!);
                    }(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.primaryColor,
                    ),
                  ),
                  trailing: Switch(
                    value: () {
                      final alarm = alarms.firstWhere(
                        (e) => e.prayer == prayer,
                        orElse: () => PrayerAlarm(
                          prayer: prayer,
                          isAlarmActive: false,
                        ),
                      );
                      return alarm.isAlarmActive;
                    }(),
                    onChanged: (value) {
                      context.read<ShalatBloc>().add(
                            ShalatEvent.setPrayerScheduleSettingEvent(
                              model: schedule?.copyWith(
                                alarms: alarms.map((e) {
                                  if (e.prayer == prayer) {
                                    return e.copyWith(isAlarmActive: value);
                                  }
                                  return e;
                                }).toList(),
                              ),
                            ),
                          );
                    },
                  ),
                );
              }).toList(),
            ).toList(),
          ),
        );
      },
    );
  }
}
