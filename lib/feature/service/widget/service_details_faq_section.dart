import 'package:get/get.dart';
import '../../../utils/core_export.dart';

class ServiceDetailsFaqSection extends StatelessWidget {
  const ServiceDetailsFaqSection({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceDetailsController>(
      builder: (serviceDetailsController){
        if(!serviceDetailsController.isLoading){
          List<Faqs>? faqs = serviceDetailsController.service!.faqs;
          return WebShadowWrap(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: faqs!.length,
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                itemBuilder: (context, index){


                  return CustomExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Text(
                        faqs.elementAt(index).question!,
                        style: robotoRegular.copyWith(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6)),
                      ),
                    ),

                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 35,right: 35,bottom:10),
                        child: Text(
                        faqs.elementAt(index).answer ?? "",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6),
                          ), textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  );
                },),
            ),
          );
        }else{
         return const SizedBox(child: Text("ok"),);
        }
      }
    );
  }
}