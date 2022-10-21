import 'package:financas_pessoais/components/categoria_list_item.dart';
import 'package:financas_pessoais/repository/categoria_repository.dart';
import 'package:flutter/material.dart';

import '../models/categorial.dart';

class CategoriasListaPage extends StatefulWidget {
  CategoriasListaPage({Key? key}) : super(key: key);

  @override
  State<CategoriasListaPage> createState() => _CategoriasListaPageState();
}

class _CategoriasListaPageState extends State<CategoriasListaPage> {
  final _futureCategorias = CategoriaRepository().listarCategorias();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: FutureBuilder<List<Categoria>>(
          future: _futureCategorias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final categorias = snapshot.data ?? [];
              return ListView.separated(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return CategoriaListItem(categoria: categoria);
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }
            return Container();
          }),
    );
  }
}
