import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  const DetailPage({super.key, required this.title, required this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image, size: 64)),
                  ),
                ),
              )
            else
              const Center(child: Icon(Icons.image_not_supported, size: 64)),
            const SizedBox(height: 16),
            Text(description, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            const Text(
              'Пингвины — нелетающие морские птицы. Они отлично плавают и ныряют, '
              'а на суше передвигаются вперевалку. Разные виды живут в разных климатах — '
              'от Антарктики до побережий Южной Америки и Африки.',
            ),
          ],
        ),
      ),
    );
  }
}
