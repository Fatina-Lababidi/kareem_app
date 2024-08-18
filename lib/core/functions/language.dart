import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

bool isEnglish(BuildContext context) {
  if (context.locale.languageCode == 'en'){
    return true;
  } else {
    return false;
  }
}
