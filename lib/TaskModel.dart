// class Todo {
//   int _id;
//
//   String _description;
//   int _isChecked;
//
//   Todo(this._id, this._isChecked, [this._description]);
//
//   Todo.withId(this._id, [this._description]);
//
//   int get id => _id;
//
//   String get description => _description;
//   int get isChecked => _isChecked;
//
//   set description(String newDescription) {
//     if (newDescription.length <= 255) {
//       this._description = newDescription;
//     }
//   }
//
//   // Convert a Note object into a Map object
//   Map<String, dynamic> toMap() {
//     var map = Map<String, dynamic>();
//     if (id != null) {
//       map['id'] = _id;
//     }
//
//     map['description'] = _description;
//     map['isChecked'] = _isChecked;
//
//     return map;
//   }
//
//   // Extract a Note object from a Map object
//   Todo.fromMapObject(Map<String, dynamic> map) {
//     this._id = map['id'];
//
//     this._description = map['description'];
//     this._isChecked = map['isChecked'];
//   }
// }
class Todo {
  int id;
  String title;

  bool isChecked = false;

  Todo({
    this.id,
    this.title,
  });

  set description(String newTitle) {
    if (title.length <= 255) {
      this.title = newTitle;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
