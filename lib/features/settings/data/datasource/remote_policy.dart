// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/settings/data/models/policy_model.dart';
import 'package:dio/dio.dart';

class RemotePolicyDataSource {
  Dio dio;
  RemotePolicyDataSource({
    required this.dio,
  });

  Future<PolicyModel> getPolicy() async {
    try {
      Response response =
          await dio.get(EndPoint.getPolicyUrl, options: getHeader(true));
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data['body']);
        print(response.data['body']['id']);
        print(response.data['body']['title']);
        print(response.data['body']['description']);
        PolicyModel policy = PolicyModel(
          id: response.data['body']['id'],
          title: response.data['body']['title'],
          description: response.data['body']['description'],
        );
        return policy;
      } else {
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      throw ServerException(
        errorModel: ErrorModel(
          status: '',
          errorMessage: 'Unexpected error occurred',
        ),
      );
    }
  }
}
