// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_add_money_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_create_wallet_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_getWalletInfo_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_valid_code_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/models/create_wallet_model.dart';
import 'package:careem_app_clean/features/wallet/data/models/vaild_code_model.dart';
import 'package:careem_app_clean/features/wallet/data/models/wallet_info_model.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/create_wallet_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/valid_code_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/wallet_info_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:dartz/dartz.dart';

class WalletRepoImp implements WalletRepo {
  final RemoteGetwalletinfoDatasource remoteGetwalletinfoDatasource;
  final RemoteCreateWalletDatasource remoteCreateWalletDatasource;
  final RemoteValidCodeDatasource remoteValidCodeDatasource;
  final RemoteAddMoneyDatasource remoteAddMoneyDatasource;
  final NetworkConnection networkConnection;
  WalletRepoImp({
    required this.remoteGetwalletinfoDatasource,
    required this.remoteCreateWalletDatasource,
    required this.remoteValidCodeDatasource,
    required this.remoteAddMoneyDatasource,
    required this.networkConnection,
  });

  @override
  Future<Either<Failures, WalletInfoEntity>> getMyWalletInfo() async {
    if (await networkConnection.isConnected) {
      try {
        WalletInfoModel walletInfoModel =
            await remoteGetwalletinfoDatasource.getMyWalletInfo();
        return Right(walletInfoModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, String>> createWallet(
      CreateWalletEntity wallet) async {
    if (await networkConnection.isConnected) {
      try {
        final walletMode = CreateWalletModel.fromEntity(wallet);
        String message =
            await remoteCreateWalletDatasource.createWallet(walletMode);
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, ValidCodeEntity>> getValidCode() async {
    if (await networkConnection.isConnected) {
      try {
        ValidCodeModel validCodeModel =
            await remoteValidCodeDatasource.getValidCode();
        return Right(validCodeModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, String>> addMoney(String code) async {
    if (await networkConnection.isConnected) {
      try {
        String message = await remoteAddMoneyDatasource.addMoney(code);
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
