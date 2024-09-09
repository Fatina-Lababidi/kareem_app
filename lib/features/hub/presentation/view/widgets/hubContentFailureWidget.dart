import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/presentation/hubContent_bloc/hub_content_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HubContentFailureWidget extends StatelessWidget {
  final String failureMessage;
  const HubContentFailureWidget({
    super.key,
    required this.screenWidth,
    required this.failureMessage,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FailureUi(
          onTap: () {
            context.read<HubContentBloc>().add(GetHubContent());
          },
        ),
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Text(
            failureMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: screenWidth * 0.04, //15,
                color: AppColor.buttonDetailsColor,
                fontWeight: FontWeight.w500),
          ),
        ).animate().fade(duration: .2.seconds, delay: .4.seconds)
      ],
    );
  }
}