import 'package:flutter/material.dart';
import 'package:pmu/domain/models/card.dart';
import 'package:pmu/data/repositories/mock_repository.dart';
import 'package:pmu/data/repositories/penguin_repository.dart';

void main() {runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penguin Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF6FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B3D91),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const MyHomePage(title: 'UlybinAA PIbd-32'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _color = const Color(0xFF0B3D91);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.ac_unit),
            const SizedBox(width: 10),
            Text(widget.title),
          ],
        ),
      ),
      body: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<List<CardData>?> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = PenguinRepository().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<CardData>?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Не удалось загрузить пингвинов:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(_reload),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Пингвины не загрузились.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(_reload),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return PenguinsList(items: items);
        },
      ),
    );
  }
}

class _Card extends StatefulWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageUrl;

  const _Card(
      this.text, {
        this.icon = Icons.ac_unit_outlined,
        required this.descriptionText,
        this.imageUrl,
        super.key,
      });

  factory _Card.fromData(CardData data) => _Card(
    data.text,
    icon: data.icon,
    descriptionText: data.descriptionText,
    imageUrl: data.imageUrl,
  );

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLiked
              ? 'Лайк пингвину: "${widget.text}"'
              : 'Лайк удален: "${widget.text}"',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailPage(
          title: widget.text,
          description: widget.descriptionText,
          imageUrl: widget.imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDetails,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFE3F2FD)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF90CAF9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 140,
                width: 100,
                child: Image.network(
                  widget.imageUrl ??
                      'https://via.placeholder.com/100x140?text=Penguin',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Placeholder(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.text,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(widget.icon, size: 22),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.descriptionText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: _toggleLike,
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.redAccent : Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  const DetailPage({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0B3D91),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Placeholder(),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              'Дополнительно:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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


class PenguinsList extends StatefulWidget {
  final List<CardData> items;
  const PenguinsList({super.key, required this.items});

  @override
  State<PenguinsList> createState() => _PenguinsListState();
}

class _PenguinsListState extends State<PenguinsList> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();

    final filtered = q.isEmpty
        ? widget.items
        : widget.items.where((c) {
      final t = c.text.toLowerCase();
      final d = (c.descriptionText ?? '').toLowerCase();
      return t.contains(q) || d.contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Поиск по пингвинам…',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Ничего не найдено'))
              : ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: filtered.length,
            itemBuilder: (context, i) => _Card.fromData(filtered[i]),
          ),
        ),
      ],
    );
  }
}
