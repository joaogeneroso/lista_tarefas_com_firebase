import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_tarefas_sem_firebase/models/item.dart';
import 'package:lista_tarefas_sem_firebase/services/notas_services/tarefas_service.dart';

class TarefasFirebaseService implements TarefasService {
  @override
  Future<void> add(Item item) async {
    final db = FirebaseFirestore.instance;

    await db.collection("tarefas").add({
      "title": item.title,
      "done": item.done,
    });
  }

  @override
  Stream<List<Item>> tarefasStream() {
    final db = FirebaseFirestore.instance;

    final snapShots = db.collection("tarefas").snapshots();

    return Stream<List<Item>>.multi((controler) {
      snapShots.listen((snapshot) {
        List<Item> listaItem = snapshot.docs.map((doc) {
          final data = doc.data();

          final item = Item(
            title: data["title"],
            done: data["done"],
            id: doc.id,
          );

          return item;
        }).toList();
        controler.add(listaItem);
      });
    });
  }

  @override
  Future<void> remove(String id) async {
    final db = FirebaseFirestore.instance.collection("tarefas");

    await db.doc(id).delete();
  }

  @override
  Future<void> edit(String id, bool valor) async {
    final db = FirebaseFirestore.instance.collection("tarefas");

    return db.doc(id).update({'done': valor});
  }
}
