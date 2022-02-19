import 'package:flutter/material.dart';
import 'package:lista_tarefas_sem_firebase/services/notas_services/tarefas_service.dart';
import 'models/item.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() async {
    if (newTaskCtrl.text.isEmpty) return;

    final item = Item(
      title: newTaskCtrl.text,
      done: false,
    );

    await TarefasService().add(item);

    setState(() {
      newTaskCtrl.text = "";
    });
  }

  void remove(String id) async {
    await TarefasService().remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: const InputDecoration(
            labelText: "Digite o nome da tarefa:",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Item>>(
          stream: TarefasService().tarefasStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  //print(item.id);
                  return Dismissible(
                    child: CheckboxListTile(
                      title: Text(item.title ?? ''),
                      value: item.done,
                      onChanged: (value) async {
                        item.done = value;
                        await TarefasService().edit(item.id!, item.done!);
                      },
                    ),
                    key: Key(item.title ?? ''),
                    background: Container(
                      color: Colors.red.withOpacity(0.5),
                    ),
                    onDismissed: (direction) {
                      remove(item.id!);
                    },
                  );
                },
              );
            }
            return const Center(
              child: Text("ERROR"),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
