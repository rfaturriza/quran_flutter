import 'dart:async';
import 'dart:ui';

import 'package:adhan/adhan.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/utils/extension/dartz_ext.dart';
import 'package:quranku/core/utils/extension/extension.dart';
import 'package:quranku/features/shalat/domain/entities/geolocation.codegen.dart';
import 'package:quranku/features/shalat/domain/usecase/get_location_manual_usecase.dart';
import 'package:quranku/features/shalat/domain/usecase/set_location_manual_usecase.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../qibla/domain/usecases/stream_permission_location_usecase.dart';
import '../../../domain/entities/prayer_schedule_setting.codegen.dart';
import '../../../domain/entities/schedule.codegen.dart';
import '../../../domain/entities/shalat_location.codegen.dart';
import '../../../domain/usecase/get_current_location_usecase.dart';
import '../../../domain/usecase/get_prayer_schedule_setting_usecase.dart';
import '../../../domain/usecase/get_shalat_cityid_by_citiesname_usecase.dart';
import '../../../domain/usecase/get_shalat_cityid_by_cityname_usecase.dart';
import '../../../domain/usecase/get_shalat_schedule_by_day_usecase.dart';
import '../../../domain/usecase/get_shalat_schedule_by_month_usecase.dart';
import '../../../domain/usecase/set_prayer_schedule_setting_usecase.dart';

part 'shalat_bloc.freezed.dart';
part 'shalat_event.dart';
part 'shalat_state.dart';

@injectable
class ShalatBloc extends Bloc<ShalatEvent, ShalatState> {
  final GetShalatCityIdByCityUseCase getCityId;
  final GetShalatScheduleByDayUseCase getScheduleByDay;
  final GetShalatScheduleByMonthUseCase getScheduleByMonth;
  final GetCurrentLocationUseCase getCurrentLocation;
  final StreamPermissionLocationUseCase streamPermissionLocation;
  final GetShalatCityIdByCitiesUseCase getCityIdByCities;
  final GetLocationManualUseCase _getLocationManual;
  final SetLocationManualUseCase _setLocationManual;
  final GetPrayerScheduleSettingUseCase _getPrayerScheduleSetting;
  final SetPrayerScheduleSettingUseCase _setPrayerScheduleSetting;

  StreamSubscription<Either<Failure, LocationStatus>>?
      _streamPermissionLocation;

  ShalatBloc(
    this._getLocationManual,
    this._setLocationManual,
    this._getPrayerScheduleSetting,
    this._setPrayerScheduleSetting, {
    required this.getCityId,
    required this.getScheduleByDay,
    required this.getScheduleByMonth,
    required this.getCurrentLocation,
    required this.streamPermissionLocation,
    required this.getCityIdByCities,
  }) : super(const ShalatState()) {
    _onStreamPermissionLocation();

    on<_Init>(_onInit);
    on<GetShalatCityIdByCityEvent>(_onShalatCityIdFetch);
    on<GetShalatScheduleByDayEvent>(_onShalatScheduleByDayFetch);
    on<GetShalatScheduleByMonthEvent>(_onShalatScheduleByMonthFetch);
    on<_OnChangedLocationStatusEvent>(_onChangedLocationStatus);
    on<_GetLocationManualEvent>(_onGetLocationManual);
    on<_SetLocationManualEvent>(_onSetLocationManual);
    on<_GetPrayerScheduleSettingEvent>(_onGetPrayerScheduleSetting);
    on<_SetPrayerScheduleSettingEvent>(_onSetPrayerScheduleSetting);
  }

  void _onStreamPermissionLocation() {
    _streamPermissionLocation = streamPermissionLocation(NoParams()).listen(
      (event) {
        final isSuccess = event.isRight();
        if (isSuccess) {
          final locationStatus = event.asRight();
          add(_OnChangedLocationStatusEvent(status: locationStatus));
          final isServiceEnabled = locationStatus.enabled;
          final isPermissionGranted = locationStatus.status.isGranted;
          if (isServiceEnabled && isPermissionGranted) {
            add(GetShalatScheduleByDayEvent(
              day: DateTime.now().day,
            ));
          }
        }
      },
    );
  }

  void _onInit(
    _Init event,
    Emitter<ShalatState> emit,
  ) async {
    emit(state.copyWith(locale: event.locale ?? const Locale('en', 'US')));
  }

  void _onChangedLocationStatus(
    _OnChangedLocationStatusEvent event,
    Emitter<ShalatState> emit,
  ) {
    emit(state.copyWith(locationStatus: event.status));
    if (event.status?.enabled == true &&
        event.status?.status.isGranted == true) {
      add(const GetShalatScheduleByDayEvent());
    }
  }

  void _onShalatCityIdFetch(
    GetShalatCityIdByCityEvent event,
    Emitter<ShalatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getCityId(
      GetShalatCityIdByCityParams(city: event.city),
    );
    emit(state.copyWith(
      isLoading: false,
      location: result.fold(
        (failure) => left(
          GeneralFailure(
            message: failure.message ?? LocaleKeys.locationNotFound.tr(),
          ),
        ),
        (data) => right(data.first),
      ),
    ));
  }

  void _onShalatScheduleByDayFetch(
    GetShalatScheduleByDayEvent event,
    Emitter<ShalatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final geoLocation = await getCurrentLocation(
      GetCurrentLocationParams(locale: state.locale),
    );
    final service = await Geolocator.isLocationServiceEnabled();
    final status = await Geolocator.checkPermission();

    emit(state.copyWith(
      locationStatus: LocationStatus(service, status),
    ));

    if (geoLocation.isLeft()) {
      emit(state.copyWith(
        isLoading: false,
        scheduleByDay: left(
          GeneralFailure(
            message: LocaleKeys.locationNotFound.tr(),
          ),
        ),
      ));
      return;
    }
    final coordinate = Coordinates(
      geoLocation.asRight()?.coordinate?.lat ?? 0,
      geoLocation.asRight()?.coordinate?.lon ?? 0,
      validate: true,
    );
    final prayerScheduleSetting = await _getPrayerScheduleSetting(NoParams());
    final method = prayerScheduleSetting.fold(
          (failure) => CalculationMethod.egyptian,
          (data) => data?.calculationMethod,
        ) ??
        CalculationMethod.egyptian;
    final madhab = prayerScheduleSetting.fold(
          (failure) => Madhab.shafi,
          (data) => data?.madhab,
        ) ??
        Madhab.shafi;
    final params = CalculationMethod.values
        .firstWhere((element) => element == method)
        .getParameters();
    params.madhab = madhab;
    final prayerTimes = PrayerTimes.today(coordinate, params);
    final Either<Failure, ScheduleByDay> resultSchedule = right(
      ScheduleByDay(
          location: geoLocation.asRight()?.country,
          area: geoLocation.asRight()?.regions?.first,
          coordinate: geoLocation.asRight()?.coordinate,
          prayerTimes: prayerTimes,
          schedule: Schedule.fromPrayerTimes(prayerTimes)),
    );
    emit(
      state.copyWith(
        isLoading: false,
        scheduleByDay: resultSchedule,
        geoLocation: geoLocation.getOrElse(() => null),
      ),
    );
  }

  void _onShalatScheduleByMonthFetch(
    GetShalatScheduleByMonthEvent event,
    Emitter<ShalatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getScheduleByMonth(
      GetShalatScheduleByMonthParams(city: event.cityID, month: event.month),
    );
    final service = await Geolocator.isLocationServiceEnabled();
    final status = await Geolocator.checkPermission();

    emit(state.copyWith(
      locationStatus: LocationStatus(service, status),
    ));
    emit(
      state.copyWith(
        isLoading: false,
        scheduleByMonth: result.fold(
          (failure) => left(
            GeneralFailure(
              message: failure.message ?? LocaleKeys.locationNotFound.tr(),
            ),
          ),
          (data) => right(data),
        ),
      ),
    );
  }

  void _onGetLocationManual(
    _GetLocationManualEvent event,
    Emitter<ShalatState> emit,
  ) async {
    final result = await _getLocationManual(NoParams());
    emit(
      state.copyWith(
        manualLocation: result.fold(
          (failure) => left(
            GeneralFailure(
              message: failure.message ?? LocaleKeys.locationNotFound.tr(),
            ),
          ),
          (data) => right(data),
        ),
      ),
    );
  }

  void _onSetLocationManual(
    _SetLocationManualEvent event,
    Emitter<ShalatState> emit,
  ) async {
    final result = await _setLocationManual(
      event.location,
    );
    emit(
      state.copyWith(
        manualLocation: result.fold(
          (failure) => left(
            GeneralFailure(
              message: failure.message ?? LocaleKeys.locationNotFound.tr(),
            ),
          ),
          (data) => right(event.location),
        ),
      ),
    );
  }

  void _onGetPrayerScheduleSetting(
    _GetPrayerScheduleSettingEvent event,
    Emitter<ShalatState> emit,
  ) async {
    final result = await _getPrayerScheduleSetting(NoParams());
    emit(
      state.copyWith(
        prayerScheduleSetting: result.fold(
          (failure) => left(
            GeneralFailure(
              message: failure.message ?? LocaleKeys.locationNotFound.tr(),
            ),
          ),
          (data) => right(data),
        ),
      ),
    );
  }

  void _onSetPrayerScheduleSetting(
    _SetPrayerScheduleSettingEvent event,
    Emitter<ShalatState> emit,
  ) async {
    final result = await _setPrayerScheduleSetting(
      event.model,
    );
    emit(
      state.copyWith(
        prayerScheduleSetting: result.fold(
          (failure) => left(
            GeneralFailure(
              message: failure.message ?? LocaleKeys.locationNotFound.tr(),
            ),
          ),
          (data) => right(event.model),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _streamPermissionLocation?.cancel();
    return super.close();
  }
}
