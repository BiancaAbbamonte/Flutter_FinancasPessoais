import 'package:financas_pessoais/models/tipo_lancamento.dart';
import 'package:financas_pessoais/models/transacao.dart';
import 'package:financas_pessoais/repository/categoria_repository.dart';
import 'package:financas_pessoais/repository/transacao_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

import '../models/categorial.dart';

class TransacaoCadastroPage extends StatefulWidget {
  Transacao? transacaoParaEdicao;
  TransacaoCadastroPage({Key? key, this.transacaoParaEdicao}) : super(key: key);

  @override
  State<TransacaoCadastroPage> createState() => _TransacaoCadastroPageState();
}

class _TransacaoCadastroPageState extends State<TransacaoCadastroPage> {
  final _categoriaRepositor = CategoriaRepository();
  final _transacaoRepository = TransacaoRepository();
  final _valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _observacaoController = TextEditingController();

  Categoria? _categoriaSelecionada;
  TipoTransacao tipoTransacaoSelecionada = TipoTransacao.receita;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();

    final transacao = widget.transacaoParaEdicao;
    if (transacao != null) {
      _categoriaSelecionada = transacao.categoria;
      _descricaoController.text = transacao.descricao;
      tipoTransacaoSelecionada = transacao.tipoTransacao;
      _observacaoController.text = transacao.observacao;
      _valorController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(transacao.valor);
      _dataController.text = DateFormat('MM/dd/yyyy').format(transacao.data);
    }

    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    final categorias = await _categoriaRepositor.listarCategorias();

    setState(() {
      _categorias = categorias
          .where((c) => c.categoriaTipoTransacao == tipoTransacaoSelecionada)
          .toList();
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildDescricao(),
                const SizedBox(height: 20),
                _buildReceitaDespesa(),
                const SizedBox(height: 20),
                _buildValor(),
                const SizedBox(height: 20),
                _buildCategoria(),
                const SizedBox(height: 20),
                _buildData(),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                _buildObservacao(),
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
            final descricao = _descricaoController.text;

            final categoria = _categoriaSelecionada!;
            var observacao = _observacaoController.text;

            final data = DateFormat('dd/MM/yyyy').parse(_dataController.text);
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(_valorController.text.replaceAll('R\$', ''))
                .toDouble();

            final transacao = Transacao(
              descricao: descricao,
              tipoTransacao: tipoTransacaoSelecionada,
              valor: valor,
              data: data,
              observacao: observacao,
              categoria: categoria,
            );

            final tipoTransacao =
                transacao.tipoTransacao == TipoTransacao.receita
                    ? 'Receita'
                    : 'Despesa';

            try {
              if (widget.transacaoParaEdicao != null) {
                transacao.id = widget.transacaoParaEdicao!.id;
                await _transacaoRepository.editarTransacao(transacao);
              } else {
                await _transacaoRepository.cadastrarTransacao(transacao);
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$tipoTransacao cadastrada com sucesso'),
              ));

              Navigator.of(context).pop(true);
            } catch (e) {
              Navigator.of(context).pop(false);
            }
          }
        },
      ),
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: _descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição',
        labelText: 'Descrição',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 30) {
          return 'A Descrição deve entre 5 e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildValor() {
    return TextFormField(
      controller: _valorController,
      decoration: const InputDecoration(
        hintText: 'Informe o valor',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(_valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  DropdownButtonFormField _buildCategoria() {
    return DropdownButtonFormField<Categoria>(
      value: _categoriaSelecionada,
      items: _categorias.map((c) {
        return DropdownMenuItem<Categoria>(
          value: c,
          child: Text(c.categoriaDescricao),
        );
      }).toList(),
      onChanged: (Categoria? categoria) {
        setState(() {
          _categoriaSelecionada = categoria;
        });
      },
      decoration: const InputDecoration(
        hintText: 'Selecione  a categoria',
        labelText: 'Categoria',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null) {
          return 'Informe uma Categoria';
        }
        return null;
      },
    );
  }

  TextFormField _buildData() {
    return TextFormField(
      controller: _dataController,
      decoration: const InputDecoration(
        hintText: 'Informe uma Data',
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

  TextFormField _buildObservacao() {
    return TextFormField(
      controller: _observacaoController,
      decoration: const InputDecoration(
        hintText: 'Informe alguma observação',
        labelText: 'Observação',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
    );
  }

  Widget _buildReceitaDespesa() {
    return Column(
      children: <Widget>[
        RadioListTile<TipoTransacao>(
          title: const Text('Receita'),
          value: TipoTransacao.receita,
          groupValue: tipoTransacaoSelecionada,
          onChanged: (TipoTransacao? value) {
            if (value != null) {
              setState(() {
                tipoTransacaoSelecionada = value;
                _categorias = [];
                _categoriaSelecionada = null;
              });

              carregarCategorias();
            }
          },
        ),
        RadioListTile<TipoTransacao>(
          title: const Text('Despesa'),
          value: TipoTransacao.despesa,
          groupValue: tipoTransacaoSelecionada,
          onChanged: (TipoTransacao? value) {
            if (value != null) {
              setState(() {
                tipoTransacaoSelecionada = value;
                _categorias = [];
                _categoriaSelecionada = null;
              });

              carregarCategorias();
            }
          },
        ),
      ],
    );
  }
}
