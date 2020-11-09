
class Temple {
  final int id;
   String templeName;
   String area;
   String city;


//Typically called form service layer
  Temple({this.id, this.templeName, this.area, this.city
    });

//Typically called from the data_source layer after getting data from an external source.
  factory Temple.fromJson(Map<String, dynamic> data) {
    return Temple(
      id: data['id'],
      templeName: data['templeName'],
      area: data['area'],
      city: data['city']

    );
  }

  factory Temple.fromMap(Map<String, dynamic> map) {
    return Temple(
      id: map['id'],
      templeName: map['templeName'],
      area: map['area'],
      city: map['city']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['templeName'] = this.templeName;
    data['area'] = this.area;
    data['city'] = this.city;
       return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "templeName": this.templeName,
      "area": this.area,
      "city": this.city
    };
  }

}