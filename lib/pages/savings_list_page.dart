import 'package:financas_pessoais/pages/saving_cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/saving_list_item.dart';
import '../models/savings.dart';
import '../repository/saving_repository.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({Key? key}) : super(key: key);

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final _savingsRepository = SavingRepository();
  late Future<List<Saving>> _futureSavings;

  @override
  void initState() {
    carregarSavings();
    super.initState();
  }

  void carregarSavings() {
    _futureSavings = _savingsRepository.listarSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Savings'),
          backgroundColor: Colors.teal
      ),
      body: FutureBuilder<List<Saving>>(
        future: _futureSavings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final savings = snapshot.data ?? [];
            return ListView.separated(
              itemCount: savings.length,
              itemBuilder: (context, index) {
                final saving = savings[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await _savingsRepository
                              .removerSaving(saving.id!);

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Saving removido com sucesso')));

                          setState(() {
                            savings.removeAt(index);
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
                                  SavingCadastroPage(
                                    savingParaEdicao: saving,
                                  ),
                            ),
                          ) as bool?;

                          if (success != null && success) {
                            setState(() {
                              carregarSavings();
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
                  child: SavingListItem(savings: saving),
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
            bool? savingCadastrada = await Navigator.of(context)
                .pushNamed('/saving-cadastro') as bool?;

            if (savingCadastrada != null && savingCadastrada) {
              setState(() {
                carregarSavings();
              });
            }
          },
          child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),

    );
  }
}
