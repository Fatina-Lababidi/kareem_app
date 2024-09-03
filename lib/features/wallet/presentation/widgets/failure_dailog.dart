import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/wallet/presentation/addMoney_bloc/add_money_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FailureDialogAddMoney extends StatelessWidget {
  const FailureDialogAddMoney({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.text,
    required this.errorMessage,
  });

  final double screenWidth;
  final double screenHeight;
  final String text;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.533,
      height: screenHeight * 0.5, // 0.369,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColor.buttonDetailsColor,
                )),
          ),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: screenWidth * 0.058, //22,
                fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.read<AddMoneyBloc>().add(AddMoney(code: text));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.baseColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    LocalizationKeys.tryAgain.tr(),
                    style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: screenWidth * 0.053 //20,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // child: FailureUi(
      //   onTap: () {
      //     context
      //         .read<AddMoneyBloc>()
      //         .add(AddMoney(code: text));
      //   },
      // ),
    );
  }
}
