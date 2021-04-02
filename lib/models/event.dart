
class EventRequest {
  final int id;
  String eventTitle;
  String eventDescription;
  String eventDate;
  String eventDuration;
  String eventLocation;
  String eventType;
  int phoneNumber;
  String addLineOne;
  String addLineTwo;
  String addLineThree;
  String locality;
  String city;
  int pincode;
  String state;
  String country;
  bool isProcessed;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String approvalStatus;
  String approvalComments;
  double sourceLongitude;
  double sourceLatitude;
  double destinationLongitude;
  double destinationLatitude;
  String eventMobility;
  String eventTime;



//Typically called form service layer to create a new user
  EventRequest(
      {this.id, this.eventTitle, this.eventDescription, this.eventDate, this.eventDuration,
        this.eventLocation,
        this.eventType,
        this.phoneNumber,
        this.addLineOne,
        this.addLineTwo,
        this.addLineThree,
        this.locality,
        this.city,
        this.pincode,
        this.state,
        this.country,
        this.isProcessed,
        this.createdBy,
        this.updatedBy,
        this.createdTime,
        this.updatedTime,
        this.approvalStatus,
        this.approvalComments,
        this.sourceLongitude,
        this.sourceLatitude,
        this.destinationLongitude,
        this.destinationLatitude,
        this.eventMobility,
      this.eventTime,});

//Typically called from the data_source layer after getting data from an external source.
  factory EventRequest.fromJson(Map<String, dynamic> data) {
    return EventRequest(
      id: data['id'],
      eventTitle: data['eventTitle'],
      eventDescription: data['eventDescription'],
      eventDate: data['eventDate'],
      eventDuration: data['eventDuration'],
      eventLocation: data['eventLocation'],
      eventType: data['eventType'],
      phoneNumber: data['phoneNumber'],
      addLineOne: data['addLineOne'],
      addLineTwo: data['addLineTwo'],
      addLineThree: data['addLineThree'],
      locality: data['locality'],
      city: data['city'],
      pincode: data['pincode'],
      state: data['state'],
      country: data['country'],
      isProcessed: data['isProcessed'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      approvalStatus: data['approvalStatus'],
      approvalComments: data['approvalComments'],
      sourceLongitude: data['sourceLongitude'],
      sourceLatitude: data['sourceLatitude'],
      destinationLongitude: data['destinationLongitude'],
      destinationLatitude: data['destinationLatitude'],
      eventMobility: data['eventMobility'],
      eventTime: data['eventTime'],
    );
  }

  factory EventRequest.fromMap(Map<String, dynamic> map) {
    return EventRequest(
      id: map['id'],
      eventTitle: map['eventTitle'],
      eventDescription: map['eventDescription'],
      eventDate: map['eventDate'],
      eventDuration: map['eventDuration'],
      eventLocation: map['eventLocation'],
      eventType: map['eventType'],
      phoneNumber: map['phoneNumber'],
      addLineOne: map['addLineOne'],
      addLineTwo: map['addLineTwo'],
      addLineThree: map['addLineThree'],
      locality: map['locality'],
      city: map['city'],
      pincode: map['pincode'],
      state: map['state'],
      country: map['country'],
      isProcessed: map['isProcessed'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      approvalStatus: map['approvalStatus'],
      approvalComments: map['approvalComments'],
      sourceLongitude: map['sourceLongitude'],
      sourceLatitude: map['sourceLatitude'],
      destinationLongitude: map['destinationLongitude'],
      destinationLatitude: map['destinationLatitude'],
      eventMobility: map['eventMobility'],
      eventTime: map['eventTime']
    );
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventTitle'] = this.eventTitle;
    data['eventDescription'] = this.eventDescription;
    data['eventDate'] = this.eventDate;
    data['eventDuration'] = this.eventDuration;
    data['eventLocation'] = this.eventLocation;
    data['eventType'] = this.eventType;
    data['phoneNumber'] = this.phoneNumber;
    data['addLineOne'] = this.addLineOne;
    data['addLineTwo'] = this.addLineTwo;
    data['addLineThree'] = this.addLineThree;
    data['locality'] = this.locality;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['country'] = this.country;
    data['isProcessed'] = this.isProcessed;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime']=this.createdTime;
    data['approvalStatus'] = this.approvalStatus;
    data['approvalComments'] = this.approvalComments;
    data['sourceLongitude'] = this.sourceLongitude;
    data['sourceLatitude'] = this.sourceLatitude;
    data['destinationLongitude'] = this.destinationLongitude;
    data['destinationLatitude'] = this.destinationLatitude;
    data['eventMobility'] = this.eventMobility;
    data['eventTime'] = this.eventTime;
    return data;
  }

  Map toStrJson() {

    return {
      "id":this.id,
      "eventTitle":this.eventTitle,
      "eventDescription":this.eventDescription,
      "eventDate":this.eventDate,
      "eventDuration":this.eventDuration,
      "eventLocation":this.eventLocation,
      "eventType":this.eventType,
      "phoneNumber":this.phoneNumber,
      "addLineOne":this.addLineOne,
      "addLineTwo":this.addLineTwo,
      "addLineThree":this.addLineThree,
      "locality":this.locality,
      "city":this.city,
      "pincode":this.pincode,
      "state":this.state,
      "country":this.country,
      "isProcessed":this.isProcessed,
      "createdBy":this.createdBy,
      "updatedBy":this.updatedBy,
      "updatedTime":this.updatedTime,
      "createdTime":this.createdTime,
      "approvalStatus":this.approvalStatus,
      "approvalComments":this.approvalComments,
      "sourceLongitude":this.sourceLongitude,
      "sourceLatitude":this.sourceLatitude,
      "destinationLongitude":this.destinationLongitude,
      "destinationLatitude":this.destinationLatitude,
      "eventMobility":this.eventMobility,
      "eventTime" : this.eventTime,
    };

  }

}