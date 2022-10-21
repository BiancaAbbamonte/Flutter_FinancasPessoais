import 'package:financas_pessoais/util/helper_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/savings.dart';
import '../util/helper_icons.dart';

class SavingListItem extends StatelessWidget {
  final Saving savings;

  const SavingListItem({Key? key, required this.savings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
          Colors.teal,
        child: Icon(
          Icons.savings,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(savings.nome),
      subtitle: Text('Data: ' + DateFormat('MM/dd/yyyy').format(savings.data)),
      trailing: Text('Valor Atual: ' +
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(savings.valorAtual) +
          '\n Valor Final:' +
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(savings.valorFinal),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/saving-detalhes',
            arguments: savings);
      },
    );
  }
}
