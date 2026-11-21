part of 'switchtheme_bloc.dart';

abstract class SwitchthemeEvent extends Equatable {
  const SwitchthemeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends SwitchthemeEvent {
  const ToggleThemeEvent();
}

class SetThemeEvent extends SwitchthemeEvent {
  final ThemeMode themeMode;

  const SetThemeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
