import 'package:financas_pessoais/models/tipo_lancamento.dart';
import 'package:financas_pessoais/models/transacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransacaoDetalhesPage extends StatelessWidget {
  const TransacaoDetalhesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transacao = ModalRoute.of(context)!.settings.arguments as Transacao;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: transacao.tipoTransacao == TipoTransacao.despesa
            ? Colors.redAccent
            : Colors.greenAccent,
        title: Text(transacao.descricao),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Tipo de Lançamento'),
              subtitle: Text(transacao.tipoTransacao == TipoTransacao.receita
                  ? 'Receita'
                  : 'Despesa'),
            ),
            ListTile(
              title: const Text('Valor'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(transacao.valor)),
            ),
            ListTile(
              title: const Text('Categoria'),
              subtitle: Text(transacao.categoria.categoriaDescricao),
            ),
            ListTile(
              title: const Text('Data do Lançamento'),
              subtitle: Text(DateFormat('MM/dd/yyyy').format(transacao.data)),
            ),
            ListTile(
              title: const Text('Observação'),
              subtitle: Text(
                  transacao.observacao.isEmpty ? '-' : transacao.observacao),
            ),
          ],
        ),
      ),
    );
  }
}
