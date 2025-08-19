import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class SeeAllPage extends StatefulWidget {
  final String type;

  const SeeAllPage({
    @PathParam('type') required this.type,
    super.key,
  });

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final path = widget.type == 'top'
        ? 'assets/api/top_selling.json'
        : 'assets/api/new_in.json';

    final jsonString = await rootBundle.loadString(path);
    final data = json.decode(jsonString);

    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type == 'top' ? 'Top Selling' : 'New In')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(item['image'], fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(item['name'], maxLines: 1, overflow: TextOverflow.ellipsis),
              Text("\$${item['price']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          );
        },
      ),
    );
  }
}
