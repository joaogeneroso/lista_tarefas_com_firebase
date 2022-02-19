import 'package:lista_tarefas_sem_firebase/services/notas_services/tarefas_firabase_service.dart';

import '../../models/item.dart';

abstract class TarefasService {
  Stream<List<Item>> tarefasStream();

  Future<void> add(Item item);

  Future<void> remove(String id);

  Future<void> edit(String id, bool value);

  factory TarefasService() {
    return TarefasFirebaseService();
  }
}
