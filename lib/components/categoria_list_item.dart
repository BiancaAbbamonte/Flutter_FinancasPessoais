import 'package:financas_pessoais/models/categorial.dart';
import 'package:financas_pessoais/models/tipo_lancamento.dart';
import 'package:financas_pessoais/util/helper_colors.dart';
import 'package:financas_pessoais/util/helper_icons.dart';
import 'package:flutter/material.dart';

class CategoriaListItem extends StatelessWidget {
  final Categoria categoria;

  const CategoriaListItem({Key? key, required this.categoria})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: HelperColors.mapColors[categoria.categoriaCor],
        child: Icon(
          HelperIcons.mapIcons[categoria.categoriaIcone],
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(categoria.categoriaDescricao),
      trailing: Text(
        categoria.categoriaTipoTransacao == TipoTransacao.despesa
            ? 'Despesa'
            : 'Receita',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: categoria.categoriaTipoTransacao == TipoTransacao.despesa
              ? Colors.pink
              : Colors.green,
        ),
      ),
    );
  }
}
