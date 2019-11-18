import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/*
 * 工厂模式：void registerFactory<T>(FactoryFunc<T> func) 每次都会返回新的实例。
 * 单例模式：void registerSingleton<T>(T instance) 每次返回同一实例。 这种模式需要手动初始化。
 * 单例模式（懒加载）： void registerLazySingleton<T>(FactoryFunc<T> func) 这种方式只有第一次注入依赖的时候，才会初始化服务，并且每次返回相同实例。
 */
void setupLocator() {
  getIt.registerSingleton(NavigateService());
}

class NavigateService {
  final GlobalKey<NavigatorState> key = GlobalKey(debugLabel: 'navigate_key');

  NavigatorState get navigator => key.currentState;

  get pushNamed => navigator.pushNamed;

  get push => navigator.push;
}
