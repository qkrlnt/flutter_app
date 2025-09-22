import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const QuotesApp());

enum QuoteCategory { motivation, humor, wisdom }

class Quote {
  final String text;
  final String author;
  final QuoteCategory category;

  Quote(this.text, this.author, this.category);

  @override
  String toString() => '"$text" — $author';
}

class Repository<T> {
  final List<T> _items = [];
  void add(T item) => _items.add(item);
  List<T> get items => _items;
}

extension QuoteCategoryName on QuoteCategory {
  String get label => name[0].toUpperCase() + name.substring(1);
}

Future<List<Quote>> fetchQuotes() async {
  await Future.delayed(const Duration(milliseconds: 700)); // имитация API
  return [
    Quote('Believe in yourself', 'Unknown', QuoteCategory.motivation),
    Quote('Debugging is like being the detective…', 'Unknown', QuoteCategory.humor),
    Quote('Knowledge is power', 'Francis Bacon', QuoteCategory.wisdom),
    Quote('Stay hungry, stay foolish', 'Steve Jobs', QuoteCategory.motivation),
    Quote('To iterate is human, to recurse divine', 'L. Peter Deutsch', QuoteCategory.humor),
  ];
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quotes',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      debugShowCheckedModeBanner: false,
      home: const QuotesPage(),
    );
  }
}

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final Repository<Quote> _repo = Repository<Quote>();
  Quote? _current;
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    fetchQuotes().then((list) {
      for (var q in list) {
        _repo.add(q); // цикл + generics
      }
      _pickRandom();
    });
  }

  void _pickRandom() async {
    await Future.delayed(const Duration(milliseconds: 100000));
    setState(() {
      if (_repo.items.isNotEmpty) {
        _current = _repo.items[_rnd.nextInt(_repo.items.length)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ulybin Alexander PIbd-32')),
      body: Center(
        child: _current == null
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _current!.text,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '— ${_current!.author}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${_current!.category.label}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const Divider(height: 40),
            // анонимная функция для фильтрации всех цитат этой категории
            Text(
              'More ${_current!.category.label} quotes:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (var q in _repo.items.where((q) => q.category == _current!.category))
              Text('• ${q.text}', textAlign: TextAlign.center),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickRandom,
        tooltip: 'New quote',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
