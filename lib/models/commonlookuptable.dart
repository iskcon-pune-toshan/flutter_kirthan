class CommonLookupTable {
  final int id;
  String description;
  String lookupType;

//Typically called form service layer
  CommonLookupTable({this.id, this.description, this.lookupType});

//Typically called from the data_source layer after getting data from an external source.
  factory CommonLookupTable.fromJson(Map<String, dynamic> data) {
    return CommonLookupTable(
      id: data['id'],
      description: data['description'],
      lookupType: data['lookupType'],
    );
  }

  factory CommonLookupTable.fromMap(Map<String, dynamic> map) {
    return CommonLookupTable(
      id: map['id'],
      description: map['description'],
      lookupType: map['lookupType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['lookupType'] = this.lookupType;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "description": this.description,
      "lookupType": this.lookupType,
    };
  }
}
