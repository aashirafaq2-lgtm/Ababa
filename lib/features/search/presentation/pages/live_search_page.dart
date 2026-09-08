import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahmed_baba/features/product_catalog/presentation/bloc/catalog_bloc.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class LiveSearchPage extends StatefulWidget {
  const LiveSearchPage({super.key});

  @override
  State<LiveSearchPage> createState() => _LiveSearchPageState();
}

class _LiveSearchPageState extends State<LiveSearchPage> {
  final _ctrl = TextEditingController();

  void _search(String q) {
    if (q.trim().isEmpty) return;
    context.read<CatalogBloc>().add(SearchProductsEvent(q.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AhmedBabaTokens.primary,
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search 1688 products...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _search(_ctrl.text),
          )
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const Center(child: CircularProgressIndicator(color: AhmedBabaTokens.primary));
          }
          if (state is CatalogError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is CatalogSearchSuccess) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (ctx, i) {
                final p = state.products[i];
                return ListTile(
                  leading: p['picUrl'] != null
                      ? Image.network(p['picUrl'], width: 60, height: 60, fit: BoxFit.cover)
                      : const Icon(Icons.inventory_2_outlined),
                  title: Text(p['title'] ?? 'Product', maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text('\$${p['priceInfo']?['price'] ?? 'N/A'}',
                      style: const TextStyle(color: AhmedBabaTokens.primary, fontWeight: FontWeight.bold)),
                  onTap: () {
                    context.read<CatalogBloc>().add(LoadProductDetailEvent(p['itemId']?.toString() ?? ''));
                  },
                );
              },
            );
          }
          return const Center(child: Text('Search for products from 1688'));
        },
      ),
    );
  }
}
