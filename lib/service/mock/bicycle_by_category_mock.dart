import 'dart:io';
import 'package:careem_app/models/response/bicycle_by_category_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/real/bicycle_by_category.dart';
import 'package:mockito/mockito.dart';

class MockBicycleByCategory extends Mock implements BycicleByCategoryService {
  @override
  Future<ResultModel> getBicyclesByCategory({
    required double latitude,
    required double longitude,
    required String category,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      Map<String, List<Bicycle>> categoryBicycles = {
        "Road_bikes": [
          Bicycle(
              id: 1,
              modelPrice: PriceModel(id: 1, price: 1800, model: "BMW 1234"),
              size: 18,
              type: "Road_bikes",
              note: "string",
              maintenance: []),
          Bicycle(
            id: 2,
            modelPrice: PriceModel(id: 2, price: 1800, model: "BMW 12342"),
            size: 18,
            type: "Road_bikes",
            note: "string",
            maintenance: [],
          ),
          Bicycle(
            id: 3,
            modelPrice: PriceModel(id: 4, price: 1800, model: "BMW 12342"),
            size: 18,
            type: "Road_bikes",
            note: "bla bla bla",
            maintenance: [],
          ),
          Bicycle(
            id: 4,
            modelPrice: PriceModel(id: 5, price: 1800, model: "BMW 12342"),
            size: 18,
            type: "Road_bikes",
            note: "bla bla ee",
            maintenance: [],
          ),
        ],
        "Mountain_bikes": [
          Bicycle(
            id: 3,
            modelPrice: PriceModel(id: 3, price: 1900, model: "mountain 5678"),
            size: 19,
            type: "Mountain_bikes",
            note: "note for mountain bikes",
            maintenance: [],
          ),
          Bicycle(
            id: 4,
            modelPrice: PriceModel(id: 4, price: 2000, model: "mountain 9101"),
            size: 20,
            type: "Mountain_bikes",
            note: "another note for mountain bikes",
            maintenance: [],
          ),
        ],
        "Hybrid_bikes": [
          Bicycle(
            id: 5,
            modelPrice: PriceModel(id: 5, price: 1600, model: "hh bike 3456"),
            size: 18,
            type: "Hybrid_bikes",
            note: "note for hybrid bikes",
            maintenance: [],
          ),
          Bicycle(
            id: 6,
            modelPrice:
                PriceModel(id: 6, price: 1700, model: "hhh bike 7890"),
            size: 18,
            type: "Hybrid_bikes",
            note: "another note for hybrid bikes",
            maintenance: [],
          ),
        ],
        "e_bikes": [
          Bicycle(
            id: 7,
            modelPrice: PriceModel(id: 7, price: 2500, model: "el 123"),
            size: 18,
            type: "e_bikes",
            note: "note for e bikes",
            maintenance: [],
          ),
          Bicycle(
            id: 8,
            modelPrice: PriceModel(id: 8, price: 2600, model: "bike bike 456"),
            size: 18,
            type: "e_bikes",
            note: "another note for e bikes",
            maintenance: [],
          ),
        ],
      };
      if (categoryBicycles.containsKey(category)) {
        return SuccessModel(
            data: BicycleResponseModel(
                message: "Get bicycles by category",
                status: "ACCEPTED",
                body: categoryBicycles[category]!));
      } else {
        return ErrorModel(message: "No bicycle found for this category");
      }
      // if (category == "Road_bikes") {
      //   return SuccessModel(
      //       data: BicycleResponseModel(
      //           message: "get bicycle by category",
      //           status: "ACCEPTED",
      //           body: [
      //         Bicycle(
      //             id: 1,
      //             modelPrice: PriceModel(id: 1, price: 1800, model: "BMW 1234"),
      //             size: 18,
      //             type: "Road_bikes",
      //             note: "string",
      //             maintenance: []),
      //         Bicycle(
      //           id: 2,
      //           modelPrice: PriceModel(id: 2, price: 1800, model: "BMW 12342"),
      //           size: 18,
      //           type: "Road_bikes",
      //           note: "string",
      //           maintenance: [],
      //         ),
      //         Bicycle(
      //           id: 3,
      //           modelPrice: PriceModel(id: 3, price: 1800, model: "BMW 12343"),
      //           size: 18,
      //           type: "Road_bikes",
      //           note: "string",
      //           maintenance: [],
      //         ),
      //       ]));
    } catch (e) {
      if (e is SocketException) {
        return OfflineModel(message: "no internet connection");
      } else {
        return ExceptionModel(message: e.toString());
      }
    }
  }
}
