import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class RowText extends StatelessWidget {
  final String title;
  final int? quantity;
  final double price;

  const RowText({super.key,required this.title,required this.price,this.quantity}) ;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: ResponsiveHelper.isWeb() ? 200 : Get.width / 2,
                  child: Text(title,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                ),
                Text( quantity == null ? "" : " x $quantity")
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text('${title.contains('Discount') || title.contains('خصم') ? '(-)': title == 'VAT' || title == 'برميل'? '(+)':''} ${PriceConverter.convertPrice(double.parse(price.toString()),isShowLongPrice:true)}',
              textAlign: TextAlign.right,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
          )
        ],
      ),
    );
  }
}
