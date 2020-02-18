class Note {
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int get id => this._id;

  String get title => this._title;

  String get description => this._description;

  String get date => this._date;

  int get priority => this._priority;

  set title(String newTitle) {
    this._title = newTitle;
  }

  set description(String newDex) {
    this._description = newDex;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set priority(int newP) {
    this._priority = newP;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['Id'] = this._id;
    map['Title'] = this._title;
    map['Description'] = this._description;
    map['Date'] = this._date;
    map['Priority'] = this._priority;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['Id'];
    this._title = map['Title'];
    this._description = map['Description'];
    this._date = map['Date'];
    this._priority = map['Priority'];
  }
}
