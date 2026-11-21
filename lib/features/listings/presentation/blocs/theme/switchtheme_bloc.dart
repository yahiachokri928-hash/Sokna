import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'switchtheme_event.dart';
part 'switchtheme_state.dart';

class SwitchthemeBloc extends Bloc<SwitchthemeEvent, SwitchthemeState> {
  SwitchthemeBloc() : super(const SwitchthemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  void _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<SwitchthemeState> emit,
  ) {
    final nextMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: nextMode));
  }

  void _onSetTheme(
    SetThemeEvent event,
    Emitter<SwitchthemeState> emit,
  ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
