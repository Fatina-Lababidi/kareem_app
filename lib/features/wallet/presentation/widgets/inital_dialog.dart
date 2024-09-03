import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/wallet/presentation/addMoney_bloc/add_money_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InitialDialogAddMoney extends StatelessWidget {
  const InitialDialogAddMoney({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.finalAmount,
    required this.text,
  });

  final double screenWidth;
  final double screenHeight;
  final num finalAmount;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: screenWidth * 0.53, //200,
        height: screenHeight * 0.5, //300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.question_mark_rounded,
                  color: AppColor.buttonColor, size: screenWidth * 0.21 //80,
                  ),
              Text(
                textAlign: TextAlign.center,
                'Are you sure you need to add:',
                style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04, //16,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                '$finalAmount',
                style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.04, //16,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                'from:',
                style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04, //16,
                ),
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.buttonDetailsColor,
                    fontWeight: FontWeight.w300,
                    fontSize: screenWidth * 0.04 //16,
                    ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //here will be the put bloc...
                    GestureDetector(
                      onTap: () {
                        context.read<AddMoneyBloc>().add(AddMoney(code: text));
                      },
                      child: Container(
                        height: screenHeight * 0.08, // 40,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.buttonColor),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'confirm',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04, //15,
                                color: AppColor.whiteColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        'cancel',
                        style: TextStyle(
                          color: AppColor.buttonColor,
                          fontSize: screenWidth * 0.04, // 15
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
