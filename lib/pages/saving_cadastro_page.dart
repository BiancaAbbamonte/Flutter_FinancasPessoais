import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import '../models/savings.dart';
import '../repository/saving_repository.dart';

class SavingCadastroPage extends StatefulWidget {
  Saving? savingParaEdicao;
  SavingCadastroPage({Key? key, this.savingParaEdicao}) : super(key: key);

  @override
  State<SavingCadastroPage> createState() => _SavingCadastroPageState();
}

class _SavingCadastroPageState extends State<SavingCadastroPage> {
  final _savingRepository = SavingRepository();
  final _valorAtualController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final _valorFinalController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();


  @override
  void initState() {
    super.initState();

    final saving = widget.savingParaEdicao;
    if (saving != null) {
      _nomeController.text = saving.nome;
      _descricaoController.text = saving.descricao;
      _valorAtualController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(saving.valorAtual);
      _valorFinalController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(saving.valorFinal);
      _dataController.text = DateFormat('MM/dd/yyyy').format(saving.data);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Piggy Bank'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildNome(),
                const SizedBox(height: 20),
                _buildDescricao(),
                const SizedBox(height: 20),
                _buildValorAtual(),
                const SizedBox(height: 20),
                _buildValorFinal(),
                const SizedBox(height: 20),
                _buildData(),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                _buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Cadastrar'),
        ),
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final nome = _nomeController.text;
            final descricao = _descricaoController.text;
            final data = DateFormat('dd/MM/yyyy').parse(_dataController.text);
            final valorAtual = NumberFormat.currency(locale: 'pt_BR')
                .parse(_valorAtualController.text.replaceAll('R\$', ''))
                .toDouble();
            final valorFinal = NumberFormat.currency(locale: 'pt_BR')
                .parse(_valorFinalController.text.replaceAll('R\$', ''))
                .toDouble();

            final saving = Saving(
              nome: nome,
              descricao: descricao,
              valorAtual: valorAtual,
              valorFinal: valorFinal,
              data: data,
            );

            try {
              if (widget.savingParaEdicao != null) {
                saving.id = widget.savingParaEdicao!.id;
                await _savingRepository.editarSaving(saving);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Saving atualizado com sucesso'),
                ));
              } else {
                await _savingRepository.cadastrarSaving(saving);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Novo saving cadastrado com sucesso'),
                ));
              }

              Navigator.of(context).pop(true);
            } catch (e) {
              Navigator.of(context).pop(false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
               ),
        ),
      );
  }

  TextFormField _buildNome() {
    return TextFormField(
      controller: _nomeController,
      decoration: const InputDecoration(
        hintText: 'Informe o nome do seu Objetivo',
        labelText: 'Nome',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.format_color_text_rounded),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o nome do Objetivo que quer alcançar';
        }
        if (value.length < 5 || value.length > 20) {
          return 'O nome deve entre 5 e 20 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: _descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição',
        labelText: 'Descrição',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 120) {
          return 'A Descrição deve entre 5 e 120 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildValorAtual() {
    return TextFormField(
      controller: _valorAtualController,
      decoration: const InputDecoration(
        hintText: 'Informe o valor que já possui para alcançar o seu objetivo',
        labelText: 'Valor Atual',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o Valor Atual';
        }
        final valorAtual = NumberFormat.currency(locale: 'pt_BR')
            .parse(_valorAtualController.text.replaceAll('R\$', ''));
        if (valorAtual <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  TextFormField _buildValorFinal() {
    return TextFormField(
      controller: _valorFinalController,
      decoration: const InputDecoration(
        hintText: 'Informe o valor que precisa para alcançar o seu objetivo',
        labelText: 'Valor Final',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o Valor Final';
        }
        final valorFinal = NumberFormat.currency(locale: 'pt_BR')
            .parse(_valorFinalController.text.replaceAll('R\$', ''));
        if (valorFinal <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  TextFormField _buildData() {
    return TextFormField(
      controller: _dataController,
      decoration: const InputDecoration(
        hintText: 'Informe a data que vai ter alcançado o seu objetivo',
        labelText: 'Data',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_month),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        DateTime? dataSelecionada = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (dataSelecionada != null) {
          _dataController.text =
              DateFormat('dd/MM/yyyy').format(dataSelecionada);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Data';
        }

        try {
          DateFormat('dd/MM/yyyy').parse(value);
        } on FormatException {
          return 'Formato de data inválida';
        }

        return null;
      },
    );
  }
}
