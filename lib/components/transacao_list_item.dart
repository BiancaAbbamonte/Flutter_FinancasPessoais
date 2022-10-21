import 'package:financas_pessoais/models/tipo_lancamento.dart';
import 'package:financas_pessoais/models/transacao.dart';
import 'package:financas_pessoais/util/helper_colors.dart';
import 'package:financas_pessoais/util/helper_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransacaoListItem extends StatelessWidget {
  final Transacao transacao;
  const TransacaoListItem({Key? key, required this.transacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            HelperColors.mapColors[transacao.categoria.categoriaCor],
        child: Icon(
          HelperIcons.mapIcons[transacao.categoria.categoriaIcone],
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(transacao.descricao),
      subtitle: Text(DateFormat('MM/dd/yyyy').format(transacao.data)),
      trailing: Text(
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(transacao.valor),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: transacao.tipoTransacao == TipoTransacao.despesa
                ? Colors.pink
                : Colors.green),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/transacao-detalhes',
            arguments: transacao);
      },
    );
  }
}
