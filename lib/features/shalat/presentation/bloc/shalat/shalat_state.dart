part of 'shalat_bloc.dart';

@freezed
class ShalatState with _$ShalatState {
  const factory ShalatState({
    @Default(Locale("en", "US")) Locale locale,
    LocationStatus? locationStatus,
    Either<Failure, ShalatLocation?>? location,
    Either<Failure, ScheduleByDay?>? scheduleByDay,
    Either<Failure, ScheduleByMonth?>? scheduleByMonth,
    GeoLocation? geoLocation,
    Either<Failure, PrayerScheduleSetting?>? prayerScheduleSetting,
    Either<Failure, GeoLocation?>? manualLocation,
    @Default(false) bool isLoading,
  }) = _ShalatState;
}
