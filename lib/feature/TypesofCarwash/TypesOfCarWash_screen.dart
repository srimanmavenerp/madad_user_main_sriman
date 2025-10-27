import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/dimensions.dart';
import 'package:madaduser/utils/styles.dart';
import '../vehicle/vehicle/view/vehicle_select_view.dart';
import 'TypesOfCarWash_controller.dart';

class TypesOfCarWashView extends StatelessWidget {
  final String categoryId;

  TypesOfCarWashView({super.key, required this.categoryId});

  final controller = Get.put(TypesOfCarWashController());

  @override
  Widget build(BuildContext context) {
    controller.fetchServicesByCategory(categoryId);

    // Map of categoryId to list of button labels
    final Map<String, List<String>> labelTexts = {
      "afd8745c-2b36-4237-a6c5-65666ff982b0": ['Book', 'Book'],
      "274ceb96-647d-4fd5-8f66-c813fc2d51d6": ['Book', 'Book', 'Book', 'Book'],
      "226716a4-0eb4-43bb-9078-5b4a08db5849": [
        'Book',
        'Coming soon',
        'Coming soon',
        'Coming soon',
        'Coming soon',
        'Coming soon',
      ],
    };

    // Colors for the labels
    final labelColors = [
      Colors.green,
      Colors.purple,
      Colors.deepPurple,
      Colors.pink,
      Colors.orange,
      Colors.indigo,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Available Service'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('home');
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text('Error: ${controller.error.value}'));
        }

        // Fetch services and optionally reorder
        final services = controller.typesOfCarWash.value?.services ?? [];

        // Example: Move “House Maids” to the top
        final reorderedServices = [
          ...services.where((s) => s.name?.toLowerCase() == 'house maids'),
          ...services.where((s) => s.name?.toLowerCase() != 'house maids'),
        ];

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: reorderedServices.length,
          itemBuilder: (context, index) {
            final service = reorderedServices[index];

            // Safely get label for this category and index
            final label = (labelTexts.containsKey(categoryId) &&
                    index < labelTexts[categoryId]!.length)
                ? labelTexts[categoryId]![index]
                : 'Book';

            final color = labelColors.length > index
                ? labelColors[index]
                : Colors.blueGrey;

            return GestureDetector(
              onTap: label != 'Coming soon'
                  ? () {
                      Get.to(
                        () => VehicleSelectView(
                          serviceId: service.id ?? '',
                          subCategoryId: service.subCategoryId ?? '',
                          categoryId: categoryId,
                        ),
                        arguments: {'service': service},
                      );
                    }
                  : null,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              service.coverImageFullPath ??
                                  'https://via.placeholder.com/150',
                              fit: BoxFit.contain,
                              height: 180,
                              width: 180,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.name ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: robotoMedium.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
