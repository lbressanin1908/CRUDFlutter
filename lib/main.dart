import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AgendaApp());
}

class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TelaAgenda(),
    );
  }
}

class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key});

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  final TextEditingController _tarefaController = TextEditingController();
  List<String> _agenda = [];

  @override
  void initState() {
    super.initState();
    _adicionarContato();
  }

  void _editarContato(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Contato'),
          content: TextField(
            controller: TextEditingController(text: _agenda[index]),
            decoration: const InputDecoration(labelText: 'Contato'),
            onChanged: (value) {
              setState(() {
                _agenda[index] = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                _salvarContato();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _carregarContato() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _agenda = prefs.getStringList('tarefas') ?? [];
    });
  }

  void _salvarContato() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tarefas', _agenda);
  }

  void _adicionarContato() {
    setState(() {
      final novoctt = _tarefaController.text;
      if (novoctt.isNotEmpty) {
        _agenda.add(novoctt);
        _tarefaController.clear();
        _salvarContato();
      }
    });
  }

  void _removerContato(int index) {
    setState(() {
      _agenda.removeAt(index);
      _salvarContato();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: ListView.builder(
        itemCount: _agenda.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_agenda[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editarContato(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removerContato(index),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Adicionar Contato'),
                content: TextField(
                  controller: _tarefaController,
                  decoration: const InputDecoration(labelText: 'Contato'),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      _adicionarContato();
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
