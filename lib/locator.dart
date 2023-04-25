import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'locator.config.dart';

const dev = Environment('dev');
const production = Environment('prod');

final GetIt locator = GetIt.instance;

@injectableInit
Future<void> initLocator(String environment) async => locator.init(environment: environment);