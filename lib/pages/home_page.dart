import 'package:financas_pessoais/pages/categorias_lista_page.dart';
import 'package:financas_pessoais/pages/dashboard_page.dart';
import 'package:financas_pessoais/pages/savings_list_page.dart';
import 'package:financas_pessoais/pages/transacoes_lista_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        children: [
          DashBoardPage(),
          TransacoesListaPage(),
          CategoriasListaPage(),
          SavingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Transações'),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list), label: 'Categorias'),
          BottomNavigationBarItem(
              icon: Icon(Icons.savings), label: 'Savings'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
      ),
    );
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }
}
