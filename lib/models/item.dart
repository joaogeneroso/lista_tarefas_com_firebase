class Item {
  String? title;
  bool? done;
  String? id;

  Item({this.title, this.done, this.id});

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['done'] = done;
    return data;
  }
}
