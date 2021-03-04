class TaskModel {

  String _task;
  bool _isSelect;

  TaskModel({ String task, bool isSelect= false}) {
    this._task = task;
    this._isSelect = isSelect;
  }


  String get task => _task;
  set task(String task) => _task = task;
  bool get isSelect => _isSelect;
  set isSelect(bool isSelect) => _isSelect = isSelect;

  TaskModel.fromJson(Map<String, dynamic> json) {

    _task = json['task'];
    _isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['task'] = this._task;
    data['isSelect'] = this._isSelect;
    return data;
  }
}