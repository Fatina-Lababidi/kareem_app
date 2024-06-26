import 'dart:io';

import 'package:careem_app/models/response/categories_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/real/categories.dart';
import 'package:mockito/mockito.dart';

class MockBicycleCategorisService extends Mock
    implements BicycleCategoriesService {
  @override
  Future<ResultModel> getBycicleCategories() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      List<String> categories = [
        "Road_bikes",
        "Mountain_bikes",
        "Hybrid_bikes",
        "e_bikes",
        "any_think"
      ];
      if (categories.isNotEmpty) {
        return SuccessModel(
          data: CategoriesResponseModel(
            message: "Get all categories",
            status: 'ACCEPTED',
            body: categories,
          ),
        );
      } else {
        return ErrorModel(message: 'Not categories found');
      }
    } catch (e) {
      if (e is SocketException) {
        return OfflineModel(message: "no internet !");
      } else {
        return ExceptionModel(message: e.toString());
      }
    }
  }
}
