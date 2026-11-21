import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/messages.dart';
import '../blocs/theme/switchtheme_bloc.dart';

class ToolbarActionThemeWidget extends StatelessWidget {
  const ToolbarActionThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchthemeBloc, SwitchthemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          tooltip: THEME_TOGGLE_TOOLTIP,
          onPressed: () {
            context.read<SwitchthemeBloc>().add(const ToggleThemeEvent());
          },
        );
      },
    );
  }
}
