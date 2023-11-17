import 'package:dio/dio.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/cart/cart.dart';
import 'error/empty_error.dart';
import 'error/please_login_first_error.dart';
import 'error_helper.dart';
import 'load_data_result.dart';

class _CartHelperImpl {
  Future<LoadDataResult<List<Cart>>> getCartListIgnoringLoginError(Future<LoadDataResult<List<Cart>>> Function() onLoadCartLoadDataResult) async {
    var result = await onLoadCartLoadDataResult();
    if (result.isFailed) {
      Future<List<Cart>> handlingResult() async {
        try {
          throw result.resultIfFailed!;
        } on DioError catch (e) {
          Error error = ErrorHelper.generatePleaseLoginFirstError(e);
          if (error is PleaseLoginFirstError) {
            return [];
          } else {
            error = ErrorHelper.generateEmptyError(e);
            if (error is EmptyError) {
              return [];
            }
          }
          rethrow;
        } catch (e) {
          rethrow;
        }
      }
      return handlingResult().getLoadDataResult<List<Cart>>();
    } else {
      return result;
    }
  }
}

// ignore: non_constant_identifier_names
final _CartHelperImpl CartHelper = _CartHelperImpl();