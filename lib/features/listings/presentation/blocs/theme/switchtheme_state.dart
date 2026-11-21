part of 'switchtheme_bloc.dart';

class SwitchthemeState extends Equatable {
  final ThemeMode themeMode;

  const SwitchthemeState({this.themeMode = ThemeMode.light});

  SwitchthemeState copyWith({ThemeMode? themeMode}) {
    return SwitchthemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode];
}
