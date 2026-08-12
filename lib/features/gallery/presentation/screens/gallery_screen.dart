import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../mock/mock_data_service.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(mockDataProvider).albums;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_outlined),
            tooltip: 'Upload',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upload uses image_picker/camera once wired to a real device')),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.maxContentWidth),
          child: GridView.builder(
            padding: const EdgeInsets.all(AppConstants.space16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isMobile ? 2 : (context.isTablet ? 3 : 4),
              mainAxisSpacing: AppConstants.space16,
              crossAxisSpacing: AppConstants.space16,
              childAspectRatio: 0.85,
            ),
            itemCount: albums.length,
            itemBuilder: (context, i) {
              final a = albums[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: a.coverColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                      child: Stack(
                        children: [
                          const Center(child: Icon(Icons.photo_library_outlined, color: Colors.white, size: 36)),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(AppConstants.radiusPill)),
                              child: Text('${a.photoCount}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.space8),
                  Text(a.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(a.project, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
