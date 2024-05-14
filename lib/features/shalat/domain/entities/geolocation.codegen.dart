import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:quranku/core/utils/extension/string_ext.dart';
import 'package:quranku/features/shalat/domain/entities/schedule.codegen.dart';

import '../../../../core/constants/hive_constants.dart';

part 'geolocation.codegen.freezed.dart';
part 'geolocation.codegen.g.dart';

@freezed
@HiveType(typeId: HiveTypeConst.geoLocation)
class GeoLocation with _$GeoLocation {
  const factory GeoLocation({
    @HiveField(0) List<String?>? cities,
    @HiveField(1) List<String?>? regions,
    @HiveField(2) String? country,
    @HiveField(3) Coordinate? coordinate,
    @HiveField(4) String? url,
  }) = _GeoLocation;

  const GeoLocation._();

  String get city =>
      cities?.firstWhere((city) => city?.isNotEmpty == true,
          orElse: () => emptyString) ??
      emptyString;

  String get region =>
      regions?.firstWhere((region) => region?.isNotEmpty == true,
          orElse: () => emptyString) ??
      emptyString;

  String get place => region == emptyString ? city : '$region, $city';
}
