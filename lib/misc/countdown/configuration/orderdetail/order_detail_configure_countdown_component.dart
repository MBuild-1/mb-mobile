import '../../../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../countdown_component_data.dart';
import '../configure_countdown_component.dart';
import 'orderdetailsummaryvaluesource/order_detail_summary_value_source.dart';

class OrderDetailConfigureCountdownComponent extends ConfigureCountdownComponent {
  OrderTransactionResponse orderTransactionResponse;
  OrderDetailSummaryValueSource orderDetailSummaryValueSource;
  CountdownComponentData countdownComponentData;

  OrderDetailConfigureCountdownComponent({
    required this.orderTransactionResponse,
    required this.orderDetailSummaryValueSource,
    required this.countdownComponentData
  });
}