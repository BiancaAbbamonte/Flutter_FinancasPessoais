import 'package:financas_pessoais/components/transacao_list_item.dart';
import 'package:financas_pessoais/models/transacao.dart';
import 'package:financas_pessoais/pages/transacao_cadastro_page.dart';
import 'package:financas_pessoais/repository/transacao_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransacoesListaPage extends StatefulWidget {
  const TransacoesListaPage({Key? key}) : super(key: key);

  @override
  State<TransacoesListaPage> createState() => _TransacoesListaPageState();
}

class _TransacoesListaPageState extends State<TransacoesListaPage> {
  final _transacaoRepository = TransacaoRepository();
  late Future<List<Transacao>> _futureTransacoes;

  @override
  void initState() {
    carregarTransacoes();
    super.initState();
  }

  void carregarTransacoes() {
    _futureTransacoes = _transacaoRepository.listarTransacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transações')),
      body: FutureBuilder<List<Transacao>>(
        future: _futureTransacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final transacoes = snapshot.data ?? [];
            return ListView.separated(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                final transacao = transacoes[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await _transacaoRepository
                              .removerLancamento(transacao.id!);

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Lançamento removido com sucesso')));

                          setState(() {
                            transacoes.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          var success = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TransacaoCadastroPage(
                                transacaoParaEdicao: transacao,
                              ),
                            ),
                          ) as bool?;

                          if (success != null && success) {
                            setState(() {
                              carregarTransacoes();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                    ],
                  ),
                  child: TransacaoListItem(transacao: transacao),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? transacaoCadastrada = await Navigator.of(context)
                .pushNamed('/transacao-cadastro') as bool?;

            if (transacaoCadastrada != null && transacaoCadastrada) {
              setState(() {
                carregarTransacoes();
              });
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
