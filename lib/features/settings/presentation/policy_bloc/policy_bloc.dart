// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/settings/domain/entities/policy_entity.dart';
import 'package:careem_app_clean/features/settings/domain/usecase/get_policy.dart';

import 'package:meta/meta.dart';

part 'policy_event.dart';
part 'policy_state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  final GetPolicyUseCase getPolicyUseCase;
  PolicyBloc(
    this.getPolicyUseCase,
  ) : super(PolicyInitial()) {
    on<GetPolicy>((event, emit) async {
      emit(PolicyLoding());

      final failureOrEntity = await getPolicyUseCase.call();

      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = 'Please try again later ..';
            break;
          default:
            message = 'there is no internet';
            break;
        }
        emit(PolicyFailure(message: message));
      }, (policy) {
        emit(PolicySuccess(policy: policy));
      });
    });
  }
}
