import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quranku/core/utils/extension/context_ext.dart';
import 'package:quranku/core/utils/extension/extension.dart';
import 'package:quranku/features/kajian/presentation/bloc/kajian/kajian_bloc.dart';
import 'package:quranku/features/kajian/presentation/screens/kajianhub_screen.dart';

import '../../../../core/components/spacer.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../injection.dart';
import '../../../shalat/presentation/bloc/shalat/shalat_bloc.dart';

class KajianHubCard extends StatelessWidget {
  final bool isNotAvailable;

  const KajianHubCard({
    super.key,
    this.isNotAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShalatBloc, ShalatState>(
      buildWhen: (previous, current) {
        return previous.locationStatus != current.locationStatus ||
            previous.geoLocation != current.geoLocation;
      },
      builder: (context, state) {
        final isLocationNotGranted =
            state.locationStatus?.status.isNotGranted == true;
        final isNotIndonesia =
            state.geoLocation?.country?.toLowerCase() != 'indonesia';
        return InkWell(
          onTap: isLocationNotGranted || isNotIndonesia
              ? null
              : () {
                  context.navigateTo(const KajianHubScreen());
                },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: ShapeDecoration(
              color: context.theme.colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Flexible(
                          flex: 2,
                          child: _KajianHubLogo(),
                        ),
                        const HSpacer(width: 10),
                        if (isNotAvailable) ...[
                          Flexible(
                            flex: 5,
                            child: Center(
                              child: Text(
                                LocaleKeys.notAvailableInYourCountry.tr(),
                                style: context.theme.textTheme.titleSmall,
                              ),
                            ),
                          )
                        ],
                        if (!isNotAvailable) ...[
                          Flexible(
                            flex: 5,
                            child: BlocProvider<KajianBloc>(
                              create: (context) => sl<KajianBloc>(),
                              child: const _RecitationInfo(),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const Flexible(
                    flex: 1,
                    child: TagNavIcon(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _KajianHubLogo extends StatelessWidget {
  const _KajianHubLogo();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.theme.brightness != Brightness.dark;
    return Image.asset(
      isDarkMode ? AssetConst.kajianHubLogoDark : AssetConst.kajianHubLogoLight,
      width: 70,
    );
  }
}

class _RecitationInfo extends StatelessWidget {
  const _RecitationInfo();

  @override
  Widget build(BuildContext context) {
    final shalatBloc = context.read<ShalatBloc>();
    return BlocListener<ShalatBloc, ShalatState>(
      listenWhen: (previous, current) =>
          previous.locationStatus != current.locationStatus,
      listener: (context, state) {
        if (state.locationStatus?.status.isGranted == true) {
          context.read<KajianBloc>().add(
                KajianEvent.fetchNearbyKajian(
                  locale: context.locale,
                ),
              );
        }
      },
      child: BlocBuilder<ShalatBloc, ShalatState>(
        buildWhen: (p, c) => p.locationStatus != c.locationStatus,
        builder: (context, shalatState) {
          return BlocBuilder<KajianBloc, KajianState>(
            buildWhen: (previous, current) =>
                previous.statusRecommended != current.statusRecommended ||
                previous.recommendedKajian != current.recommendedKajian,
            builder: (context, state) {
              if (state.statusRecommended.isInProgress) {
                return const Center(child: LinearProgressIndicator());
              }
              if (shalatState.locationStatus?.status.isNotGranted == true) {
                return Center(
                  child: GestureDetector(
                    onTap: () async {
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
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys.requestAccessLocation.tr(),
                            style: context.theme.textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: '\n',
                            style: context.theme.textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: LocaleKeys.tryAgain.tr(),
                            style: context.theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state.statusRecommended.isFailure) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<KajianBloc>().add(
                            KajianEvent.fetchNearbyKajian(
                              locale: context.locale,
                            ),
                          );
                    },
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys.errorGetKajian.tr(),
                            style: context.theme.textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: '\n',
                            style: context.theme.textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: LocaleKeys.tryAgain.tr(),
                            style: context.theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state.statusRecommended.isSuccess &&
                  state.recommendedKajian == null) {
                return Center(
                  child: Text(
                    LocaleKeys.nearbyKajianEmptyToday.tr(),
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (state.recommendedKajian?.studyLocation.name ?? ''),
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const VSpacer(height: 2),
                  Text(
                    state.recommendedKajian?.ustadz.isNotEmpty ?? false
                        ? state.recommendedKajian?.ustadz.first.name ?? ''
                        : '',
                    style: context.theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const VSpacer(height: 2),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${state.recommendedKajian?.timeStart ?? ''} - ${state.recommendedKajian?.timeEnd ?? ''}',
                          style: context.theme.textTheme.titleSmall,
                        ),
                        TextSpan(
                          text: ' | ',
                          style: context.theme.textTheme.titleSmall,
                        ),
                        TextSpan(
                          text: state.recommendedKajian?.prayerSchedule ?? '',
                          style: context.theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class TagNavIcon extends StatelessWidget {
  const TagNavIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: ShapeDecoration(
            color: context.theme.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            LocaleKeys.nearby.tr(),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        Icon(
          Icons.navigate_next,
          color: context.theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ],
    );
  }
}
