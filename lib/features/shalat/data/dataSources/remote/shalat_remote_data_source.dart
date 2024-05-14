import 'package:dartz/dartz.dart';
import 'package:quranku/core/error/failures.dart';
import 'package:quranku/features/shalat/data/models/schedule_model.codegen.dart';
import 'package:quranku/features/shalat/data/models/shalat_location_model.codegen.dart';

abstract class ShalatRemoteDataSource {
  Future<Either<Failure, ShalatLocationResponseModel>> getShalatLocation(
      String city);

  Future<Either<Failure, ScheduleResponseByDayModel>> getShalatScheduleByDay(
    String cityId,
    int day,
  );

  Future<Either<Failure, ScheduleResponseByMonthModel>>
      getShalatScheduleByMonth(
    String cityId,
    String month,
  );
}
