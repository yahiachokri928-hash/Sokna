import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../blocs/listings/listings_bloc.dart';
import '../widgets/post_listing_form.dart';

class PostListingScreen extends StatelessWidget {
  const PostListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(POST_APP_BAR_TITLE),
      ),
      body: SafeArea(
        child: PostListingForm(
          onListingSubmitted: (newListing) {
            context.read<ListingsBloc>().add(AddListingEvent(newListing));

            SnackBarMessage.showSuccessSnackBar(
              context: context,
              message: POST_SUCCESS_MESSAGE,
            );

            context.pop(newListing);
          },
        ),
      ),
    );
  }
}
