import '../models/savings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingDetalhesPage extends StatelessWidget {
  const SavingDetalhesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saving = ModalRoute.of(context)!.settings.arguments as Saving;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.teal,
        title: Text(saving.nome),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Detalhe'),
              subtitle: Text(saving.descricao),
            ),
            ListTile(
              title: const Text('Valor Atual'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(saving.valorAtual)),
            ),
            ListTile(
              title: const Text('Valor Final'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(saving.valorFinal)),
            ),
            ListTile(
              title: const Text('Data Final'),
              subtitle: Text(DateFormat('MM/dd/yyyy')
                  .format(saving.data)),
            ),
          ],
        ),
      ),
    );
  }
}
