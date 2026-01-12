import 'package:flutter/material.dart';
import 'package:pmu/components/extensions/context_x.dart';
import 'package:pmu/domain/models/card.dart';
import 'package:pmu/presentation/details_page/details_page.dart';

class PenguinCard extends StatefulWidget {
  final CardData data;

  const PenguinCard({super.key, required this.data});

  @override
  State<PenguinCard> createState() => _PenguinCardState();
}

class _PenguinCardState extends State<PenguinCard> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? context.locale.liked : context.locale.disliked),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _openDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailPage(
          title: widget.data.text,
          description: widget.data.descriptionText,
          imageUrl: widget.data.imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _openDetails,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 140,
                  width: 100,
                  child: Image.network(
                    d.imageUrl ?? 'https://via.placeholder.com/100x140?text=Penguin',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Placeholder(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              d.text,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleLike,
                            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                          ),
                        ],
                      ),
                      Text(d.descriptionText, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(children: [Icon(d.icon, size: 18), const SizedBox(width: 6)]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
