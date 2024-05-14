import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/constants/font_constants.dart';
import 'package:quranku/features/setting/domain/entities/last_read_reminder_mode_entity.dart';
import 'package:quranku/features/setting/domain/usecases/styling/set_arabic_font_size_setting.dart';

import '../../../../../core/constants/hive_constants.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/styling/get_arabic_font_family_setting.dart';
import '../../../domain/usecases/styling/get_arabic_font_size_setting.dart';
import '../../../domain/usecases/styling/get_last_read_reminder_setting.dart';
import '../../../domain/usecases/styling/get_latin_font_size_setting.dart';
import '../../../domain/usecases/styling/get_show_latin_setting.dart';
import '../../../domain/usecases/styling/get_show_translation_setting.dart';
import '../../../domain/usecases/styling/get_translation_font_size_setting.dart';
import '../../../domain/usecases/styling/set_arabic_font_family_setting.dart';
import '../../../domain/usecases/styling/set_last_read_reminder_setting.dart';
import '../../../domain/usecases/styling/set_latin_font_size_setting.dart';
import '../../../domain/usecases/styling/set_show_latin_setting.dart';
import '../../../domain/usecases/styling/set_show_translation_setting.dart';
import '../../../domain/usecases/styling/set_translation_font_size_setting.dart';

part 'styling_setting_bloc.freezed.dart';
part 'styling_setting_event.dart';
part 'styling_setting_state.dart';

@injectable
class StylingSettingBloc
    extends Bloc<StylingSettingEvent, StylingSettingState> {
  final SetArabicFontFamilySetting setArabicFontFamilySetting;
  final GetArabicFontFamilySetting getArabicFontFamilySetting;
  final SetArabicFontSizeSetting setArabicFontSizeSetting;
  final GetArabicFontSizeSetting getArabicFontSizeSetting;
  final SetLatinFontSizeSetting setLatinFontSizeSetting;
  final GetLatinFontSizeSetting getLatinFontSizeSetting;
  final SetTranslationFontSizeSetting setTranslationFontSizeSetting;
  final GetTranslationFontSizeSetting getTranslationFontSizeSetting;
  final GetShowTranslationSetting getShowTranslationSetting;
  final SetShowTranslationSetting setShowTranslationSetting;
  final GetShowLatinSetting getShowLatinSetting;
  final SetShowLatinSetting setShowLatinSetting;
  final GetLastReadReminderSetting getLastReadReminderSetting;
  final SetLastReadReminderSetting setLastReadReminderSetting;

  StylingSettingBloc(
    this.setArabicFontFamilySetting,
    this.getArabicFontFamilySetting,
    this.setArabicFontSizeSetting,
    this.getArabicFontSizeSetting,
    this.setLatinFontSizeSetting,
    this.getLatinFontSizeSetting,
    this.setTranslationFontSizeSetting,
    this.getTranslationFontSizeSetting,
    this.getShowTranslationSetting,
    this.setShowTranslationSetting,
    this.getShowLatinSetting,
    this.setShowLatinSetting,
    this.getLastReadReminderSetting,
    this.setLastReadReminderSetting,
  ) : super(const StylingSettingState()) {
    on<_Init>(_onInit);
    on<_SetArabicFontFamily>(_onSetArabicFontFamily);
    on<_SetArabicFontSize>(_onSetArabicFontSize);
    on<_SetLatinFontSize>(_onSetLatinFontSize);
    on<_SetTranslationFontSize>(_onSetTranslationFontSize);
    on<_GetArabicFontFamily>(_onGetArabicFontFamily);
    on<_GetArabicFontSize>(_onGetArabicFontSize);
    on<_GetLatinFontSize>(_onGetLatinFontSize);
    on<_GetTranslationFontSize>(_onGetTranslationFontSize);
    on<_SetLastReadReminder>(_onSetLastReadReminder);
    on<_GetLastReadReminder>(_onGetLastReadReminder);
    on<_SetShowLatin>(_onSetShowLatin);
    on<_GetShowLatin>(_onGetShowLatin);
    on<_SetShowTranslation>(_onSetShowTranslation);
    on<_GetShowTranslation>(_onGetShowTranslation);
    on<_SetColoredTajweedStatus>(_onSetColoredTajweedStatus);
    on<_GetColoredTajweedStatus>(_onGetColoredTajweedStatus);
  }

  void _onInit(_Init event, emit) {
    add(const _GetArabicFontFamily());
    add(const _GetArabicFontSize());
    add(const _GetLatinFontSize());
    add(const _GetTranslationFontSize());
    add(const _GetLastReadReminder());
    add(const _GetShowLatin());
    add(const _GetShowTranslation());
    add(const _GetColoredTajweedStatus());
  }

  void _onSetArabicFontFamily(_SetArabicFontFamily event, emit) async {
    emit(state.copyWith(
      statusArabicFontFamily: FormzSubmissionStatus.inProgress,
    ));
    final result = await setArabicFontFamilySetting(
      SetArabicFontFamilySettingParams(event.fontFamily),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        statusArabicFontFamily: FormzSubmissionStatus.failure,
      )),
      (_) => emit(state.copyWith(
        statusArabicFontFamily: FormzSubmissionStatus.success,
        fontFamilyArabic: event.fontFamily,
      )),
    );
  }

  void _onSetArabicFontSize(_SetArabicFontSize event, emit) async {
    emit(state.copyWith(
      statusArabicFontSize: FormzSubmissionStatus.inProgress,
    ));
    final result = await setArabicFontSizeSetting(
      SetArabicFontSizeSettingParams(event.fontSize),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        statusArabicFontSize: FormzSubmissionStatus.failure,
      )),
      (_) => emit(state.copyWith(
        statusArabicFontSize: FormzSubmissionStatus.success,
        arabicFontSize: event.fontSize,
      )),
    );
  }

  void _onSetLatinFontSize(_SetLatinFontSize event, emit) async {
    emit(state.copyWith(
      statusLatinFontSize: FormzSubmissionStatus.inProgress,
    ));
    final result = await setLatinFontSizeSetting(
      SetLatinFontSizeSettingParams(event.fontSize),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        statusLatinFontSize: FormzSubmissionStatus.failure,
      )),
      (_) => emit(state.copyWith(
        statusLatinFontSize: FormzSubmissionStatus.success,
        latinFontSize: event.fontSize,
      )),
    );
  }

  void _onSetTranslationFontSize(_SetTranslationFontSize event, emit) async {
    emit(state.copyWith(
      statusTranslationFontSize: FormzSubmissionStatus.inProgress,
    ));
    final result = await setTranslationFontSizeSetting(
      SetTranslationFontSizeSettingParams(event.fontSize),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        statusTranslationFontSize: FormzSubmissionStatus.failure,
      )),
      (_) => emit(state.copyWith(
        statusTranslationFontSize: FormzSubmissionStatus.success,
        translationFontSize: event.fontSize,
      )),
    );
  }

  void _onGetArabicFontFamily(_GetArabicFontFamily event, emit) async {
    final result = await getArabicFontFamilySetting(NoParams());
    result.fold(
      (failure) {},
      (fontFamily) => emit(state.copyWith(
        statusArabicFontFamily: FormzSubmissionStatus.success,
        fontFamilyArabic: fontFamily ?? FontConst.lpmqIsepMisbah,
      )),
    );
  }

  void _onGetArabicFontSize(_GetArabicFontSize event, emit) async {
    final result = await getArabicFontSizeSetting(NoParams());
    result.fold(
      (failure) {},
      (fontSize) => emit(state.copyWith(
        statusArabicFontSize: FormzSubmissionStatus.success,
        arabicFontSize: fontSize ?? FontConst.defaultArabicFontSize,
      )),
    );
  }

  void _onGetLatinFontSize(_GetLatinFontSize event, emit) async {
    final result = await getLatinFontSizeSetting(NoParams());
    result.fold(
      (failure) {},
      (fontSize) => emit(state.copyWith(
        statusLatinFontSize: FormzSubmissionStatus.success,
        latinFontSize: fontSize ?? FontConst.defaultLatinFontSize,
      )),
    );
  }

  void _onGetTranslationFontSize(_GetTranslationFontSize event, emit) async {
    final result = await getTranslationFontSizeSetting(NoParams());
    result.fold(
      (failure) {},
      (fontSize) => emit(state.copyWith(
        statusTranslationFontSize: FormzSubmissionStatus.success,
        translationFontSize: fontSize ?? FontConst.defaultTranslationFontSize,
      )),
    );
  }

  void _onSetLastReadReminder(_SetLastReadReminder event, emit) async {
    final result = await setLastReadReminderSetting(event.mode);
    result.fold(
      (failure) {},
      (_) => emit(state.copyWith(
        lastReadReminderMode: event.mode,
      )),
    );
  }

  void _onGetLastReadReminder(_GetLastReadReminder event, emit) async {
    final result = await getLastReadReminderSetting(NoParams());
    result.fold(
      (failure) {},
      (mode) => emit(state.copyWith(
        lastReadReminderMode: mode,
      )),
    );
  }

  void _onSetShowLatin(_SetShowLatin event, emit) async {
    final result = await setShowLatinSetting(event.isShow);
    result.fold(
      (failure) {},
      (_) => emit(state.copyWith(
        isShowLatin: event.isShow,
      )),
    );
  }

  void _onGetShowLatin(_GetShowLatin event, emit) async {
    final result = await getShowLatinSetting(NoParams());
    result.fold(
      (failure) {},
      (isShow) => emit(state.copyWith(
        isShowLatin: isShow ?? true,
      )),
    );
  }

  void _onSetShowTranslation(_SetShowTranslation event, emit) async {
    final result = await setShowTranslationSetting(event.isShow);
    result.fold(
      (failure) {},
      (_) => emit(state.copyWith(
        isShowTranslation: event.isShow,
      )),
    );
  }

  void _onGetShowTranslation(_GetShowTranslation event, emit) async {
    final result = await getShowTranslationSetting(NoParams());
    result.fold(
      (failure) {},
      (isShow) => emit(state.copyWith(
        isShowTranslation: isShow ?? true,
      )),
    );
  }

  void _onSetColoredTajweedStatus(_SetColoredTajweedStatus event, emit) async {
    emit(state.copyWith(
      isColoredTajweedEnabled: event.isColoredTajweedEnabled,
    ));
  }

  void _onGetColoredTajweedStatus(_GetColoredTajweedStatus event, emit) async {
    final settingBox = await Hive.openBox(HiveBoxConst.settingBox);
    final isColoredTajweedEnabled = settingBox.get(HiveKeyConst.tajweedStatusKey) ?? true;
    emit(state.copyWith(
      isColoredTajweedEnabled: isColoredTajweedEnabled,
    ));
  }
}
