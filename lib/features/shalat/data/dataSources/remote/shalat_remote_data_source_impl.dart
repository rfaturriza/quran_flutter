import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/error/failures.dart';
import 'package:quranku/core/network/dio_config.dart';
import 'package:quranku/features/shalat/data/models/schedule_model.codegen.dart';
import 'package:quranku/features/shalat/data/models/shalat_location_model.codegen.dart';

import 'shalat_remote_data_source.dart';

@LazySingleton(as: ShalatRemoteDataSource)
class ShalatRemoteDataSourceImpl implements ShalatRemoteDataSource {
  static final dio = NetworkConfig.getDioCustom(NetworkConfig.baseUrlShalat);

  @override
  Future<Either<Failure, ShalatLocationResponseModel>> getShalatLocation(
      String city) async {
    final endpoint = 'v1/sholat/kota/cari/$city';
    try {
      final result = await dio.get(endpoint);
      if (result.data['status'] == false) {
        return Left(ServerFailure(message: result.data['message']));
      }
      return Right(ShalatLocationResponseModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ScheduleResponseByDayModel>> getShalatScheduleByDay(
    String cityId,
    int day,
  ) async {
    final dateTime = DateTime.now();
    final yearNow = dateTime.year;
    final monthNow = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final endpoint = 'v1/sholat/jadwal/$cityId/$yearNow/$monthNow/$day';
    try {
      final result = await dio.get(endpoint);
      return Right(ScheduleResponseByDayModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ScheduleResponseByMonthModel>>
      getShalatScheduleByMonth(String cityId, String month) async {
    final dateTime = DateTime.now();
    final yearNow = dateTime.year;
    final month2 = month.padLeft(2, '0');
    final endpoint = 'v1/sholat/jadwal/$cityId/$yearNow/$month2';
    try {
      final result = await dio.get(endpoint);
      return Right(ScheduleResponseByMonthModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
