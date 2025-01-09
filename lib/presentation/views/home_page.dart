import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Manager'),
        actions: [
          if (Platform.isWindows)
            IconButton(
              icon: const Icon(Icons.folder_open),
              onPressed: () => controller.fetchPhotos(),
              tooltip: 'Select Folder',
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.photos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo_library_outlined,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('No Photos Selected',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                if (Platform.isWindows)
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchPhotos(),
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Select Folder'),
                  ),
              ],
            ),
          );
        }

        if (Platform.isWindows) {
          return Row(
            children: [
              // Main photo view (70% of screen)
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    // Photo counter
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Photo ${controller.currentIndex.value + 1} of ${controller.photos.length}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Main photo swiper
                    Expanded(
                      child: Swiper(
                        itemBuilder: (context, index) {
                          final photo = controller.photos[index];
                          return Hero(
                            tag: 'photo_${photo.id}',
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(photo.path),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: controller.photos.length,
                        onIndexChanged: (index) =>
                            controller.currentIndex.value = index,
                        control: const SwiperControl(
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                    ),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => controller.swipeLeft(),
                            icon: const Icon(Icons.delete_forever),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => controller.swipeRight(),
                            icon: const Icon(Icons.favorite),
                            label: const Text('Keep'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Thumbnail preview list (30% of screen)
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.photos.length,
                  itemBuilder: (context, index) {
                    final photo = controller.photos[index];
                    return GestureDetector(
                      onTap: () => controller.currentIndex.value = index,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.currentIndex.value == index
                                ? Colors.green
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(photo.path),
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // Mobile UI
        return const Center(
          child: Text('Mobile UI not implemented yet'),
        );
      }),
    );
  }
}
