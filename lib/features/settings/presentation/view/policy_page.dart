import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/settings/presentation/policy_bloc/policy_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.01),
                    child: const BackWidget()),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: isEnglish(context)
                          ? const EdgeInsets.only(right: 50)
                          : const EdgeInsets.only(left: 50),
                      child: Text(
                        LocalizationKeys.privacyPolicy.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColor.settingsTitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().fade(duration: .2.seconds, delay: .1.seconds),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            BlocConsumer<PolicyBloc, PolicyState>(
              listener: (context, state) {
                if (state is PolicySuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully retrieved policy'),
                      backgroundColor: AppColor.baseColor,
                    ),
                  );
                } else if (state is PolicyFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColor.snackbarOfflineColor,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is PolicySuccess) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.policy.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.contentSecondaryTextColor,
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 20,
                          state.policy.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.policydescColor,
                          ),
                        )
                      ],
                    ),
                  );
                } else if (state is PolicyFailure || state is PolicyOffline) {
                  return Expanded(
                    child: FailureUi(
                      onTap: () {
                        context.read<PolicyBloc>().add(GetPolicy());
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.baseColor,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
