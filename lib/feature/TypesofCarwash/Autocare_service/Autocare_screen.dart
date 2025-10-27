// import 'package:flutter/material.dart';
//
// import 'Autocare_service_controller.dart';
// import 'Autocare_service_model.dart';
//
// class AutoCareServiceView extends StatelessWidget {
//   final AutoCareServiceController controller = AutoCareServiceController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Auto Care Services'),
//       ),
//       body: FutureBuilder<AutoCareServiceModel?>(
//         future: controller.fetchAutoCareService(),
//
//
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || snapshot.data == null) {
//             return Center(child: Text('Failed to load data.'));
//           } else {
//             final services = snapshot.data!.data ?? [];
//
//             return ListView.builder(
//               itemCount: services.length,
//               itemBuilder: (context, index) {
//                 final package = services[index];
//                 return ExpansionTile(
//                   title: Text(package.packageName ?? 'No Package Name'),
//                   subtitle: Text('Package ID: ${package.packageId}'),
//                   children: package.variantOptions?.map((variant) {
//                     return ListTile(
//                       title: Text(variant.variant ?? 'Unknown Variant'),
//                       subtitle: Text('Price: ₹${variant.price}'),
//                     );
//                   }).toList() ??
//                       [Text("No Variants Available")],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

import 'Autocare_service_controller.dart';
import 'Autocare_service_model.dart';

class AutoCareServiceView extends StatelessWidget {
  final String serviceId;
  final String zoneId;

  AutoCareServiceView({
    required this.serviceId,
    required this.zoneId,
    Key? key,
  }) : super(key: key);

  final AutoCareServiceController controller = AutoCareServiceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Care Services'),
      ),
      body: FutureBuilder<AutoCareServiceModel?>(
        future: controller.fetchAutoCareService(
          serviceId: serviceId,
          zoneId: zoneId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Failed to load data.'));
          } else {
            final services = snapshot.data!.data ?? [];

            if (services.isEmpty) {
              return Center(child: Text('No services available.'));
            }

            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final package = services[index];
                return ExpansionTile(
                  title: Text(package.packageName ?? 'No Package Name'),
                  subtitle: Text('Package ID: ${package.packageId}'),
                  children: package.variantOptions?.map((variant) {
                    return ListTile(
                      title: Text(variant.variant ?? 'Unknown Variant'),
                      subtitle: Text('Price: ₹${variant.price ?? 'N/A'}'),
                    );
                  }).toList() ??
                      [ListTile(title: Text("No Variants Available"))],
                );
              },
            );
          }
        },
      ),
    );
  }
}