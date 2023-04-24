import 'package:thingsboard_app/core/context/tb_context.dart';
import 'package:thingsboard_app/core/entity/entity_details_page.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

class CustomerDetailsPage extends ContactBasedDetailsPage<Customer> {
  CustomerDetailsPage(TbContext tbContext, String customerId)
      : super(tbContext,
            entityId: customerId,
            defaultTitle: 'Клиент',
            subTitle: 'Информация о клиенте');

  @override
  Future<Customer?> fetchEntity(String customerId) {
    return tbClient.getCustomerService().getCustomer(customerId);
  }
}
