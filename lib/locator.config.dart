// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sigest/api/abstract_api.dart' as _i3;
import 'package:sigest/api/api.dart' as _i4;
import 'package:sigest/api/api_mock.dart' as _i5;
import 'package:sigest/stock/abstract_repository.dart' as _i6;
import 'package:sigest/stock/auth.dart' as _i7;
import 'package:sigest/stock/gestures.dart' as _i12;
import 'package:sigest/stock/lessons.dart' as _i8;
import 'package:sigest/stock/saved.dart' as _i13;
import 'package:sigest/stock/settings.dart' as _i9;
import 'package:sigest/stock/units.dart' as _i10;
import 'package:sigest/stock/user.dart' as _i11;

const String _prod = 'prod';
const String _dev = 'dev';

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AbstractApi>(
      () => _i4.Api(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i3.AbstractApi>(
      () => _i5.ApiMock(),
      registerFor: {_dev},
    );
    gh.singleton<_i6.AbstractRepository>(
      _i7.AuthRepository(),
      instanceName: 'auth',
    );
    gh.lazySingleton<_i6.AbstractRepository>(
      () => _i8.LessonRepository(),
      instanceName: 'lessons',
    );
    gh.singleton<_i6.AbstractRepository>(
      _i9.SettingsRepository(),
      instanceName: 'settings',
    );
    gh.lazySingleton<_i6.AbstractRepository>(
      () => _i10.UnitsRepository(),
      instanceName: 'units',
    );
    gh.lazySingleton<_i6.AbstractRepository>(
      () => _i11.UserRepository(),
      instanceName: 'user',
    );
    gh.singleton<_i6.AbstractRepository>(
      _i12.GestureRepository(),
      instanceName: 'gestures',
    );
    gh.singleton<_i6.AbstractRepository>(
      _i13.SavedRepository(),
      instanceName: 'saved',
    );
    return this;
  }
}
