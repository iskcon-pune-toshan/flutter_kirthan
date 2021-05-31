//added service type (Free / Premium )
class EventRequest {
  final int id;
  String eventTitle;
  String eventDescription;
  String eventDate;
  String eventStartTime;
  String eventEndTime;
  int eventType;
  int phoneNumber;
  String addLineOneS;
  String addLineTwoS;
  String localityS;
  String addLineOneD;
  String addLineTwoD;
  String localityD;
  String city;
  int pincode;
  String state;
  String country;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  double longitudeS;
  double latitudeS;
  double longitudeD;
  double latitudeD;
  String eventMobility;
  bool isPublicEvent;
  int teamInviteStatus;
  String cancelReason;
  String serviceType;
  String zoomId;

//Typically called form service layer to create a new user
  EventRequest(
      {this.id,
      this.eventTitle,
      this.eventDescription,
      this.eventDate,
      this.eventStartTime,
      this.eventEndTime,
      this.eventType,
      this.phoneNumber,
      this.addLineOneS,
      this.addLineTwoS,
      this.localityS,
      this.addLineOneD,
      this.addLineTwoD,
      this.localityD,
      this.city,
      this.pincode,
      this.state,
      this.country,
      this.createdBy,
      this.updatedBy,
      this.createdTime,
      this.updatedTime,
      /*this.approvalStatus,
      this.approvalComments,*/
      this.latitudeS,
      this.longitudeS,
      this.latitudeD,
      this.longitudeD,
      this.eventMobility,
      //this.eventTime,
      this.isPublicEvent,
      this.teamInviteStatus,
      this.cancelReason,
      this.serviceType,
      this.zoomId});

//Typically called from the data_source layer after getting data from an external source.
  factory EventRequest.fromJson(Map<String, dynamic> data) {
    return EventRequest(
      id: data['id'],
      eventTitle: data['eventTitle'],
      eventDescription: data['eventDescription'],
      eventDate: data['eventDate'],
      eventStartTime: data['eventStartTime'],
      eventEndTime: data['eventEndTime'],
      eventType: data['eventType'],
      phoneNumber: data['phoneNumber'],
      addLineOneS: data['addLineOneS'],
      addLineTwoS: data['addLineTwoS'],
      localityS: data['localityS'],
      addLineOneD: data['addLineOneD'],
      addLineTwoD: data['addLineTwoD'],
      localityD: data['localityD'],
      city: data['city'],
      pincode: data['pincode'],
      state: data['state'],
      country: data['country'],
      //isProcessed: data['isProcessed'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      /*approvalStatus: data['approvalStatus'],
      approvalComments: data['approvalComments'],*/
      longitudeS: data['longitudeS'],
      latitudeS: data['latitudeS'],
      longitudeD: data['longitudeD'],
      latitudeD: data['latitudeD'],
      eventMobility: data['eventMobility'],
      //eventTime: data['eventTime'],
      isPublicEvent: data['isPublicEvent'],
      teamInviteStatus: data['teamInviteStatus'],
      cancelReason: data['cancelReason'],
      serviceType: data['serviceType'],
      zoomId: data['zoomId'],
    );
  }

  factory EventRequest.fromMap(Map<String, dynamic> map) {
    return EventRequest(
      id: map['id'],
      eventTitle: map['eventTitle'],
      eventDescription: map['eventDescription'],
      eventDate: map['eventDate'],
      eventStartTime: map['eventStartTime'],
      eventEndTime: map['eventEndTime'],
      eventType: map['eventType'],
      phoneNumber: map['phoneNumber'],
      addLineOneS: map['addLineOneS'],
      addLineTwoS: map['addLineTwoS'],
      localityS: map['localityS'],
      addLineOneD: map['addLineOneD'],
      addLineTwoD: map['addLineTwoD'],
      localityD: map['localityD'],
      city: map['city'],
      pincode: map['pincode'],
      state: map['state'],
      country: map['country'],
      //isProcessed: map['isProcessed'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      /* approvalStatus: map['approvalStatus'],
      approvalComments: map['approvalComments'],*/
      longitudeS: map['longitudeS'],
      latitudeS: map['latitudeS'],
      longitudeD: map['longitudeD'],
      latitudeD: map['latitudeD'],
      eventMobility: map['eventMobility'],
      //eventTime: map['eventTime'],
      isPublicEvent: map['isPublicEvent'],
      teamInviteStatus: map['teamInviteStatus'],
      cancelReason: map['cancelReason'],
      serviceType: map['serviceType'],
      zoomId: map['zoomId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventTitle'] = this.eventTitle;
    data['eventDescription'] = this.eventDescription;
    data['eventDate'] = this.eventDate;
    data['eventStartTime'] = this.eventStartTime;
    data['eventEndTime'] = this.eventEndTime;
    data['eventType'] = this.eventType;
    data['phoneNumber'] = this.phoneNumber;
    data['addLineOneS'] = this.addLineOneS;
    data['addLineTwoS'] = this.addLineTwoS;
    data['localityS'] = this.localityS;
    data['addLineOneD'] = this.addLineOneD;
    data['addLineTwoD'] = this.addLineTwoD;
    data['localityD'] = this.localityD;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['country'] = this.country;
    //data['isProcessed'] = this.isProcessed;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime'] = this.createdTime;
    /*data['approvalStatus'] = this.approvalStatus;
    data['approvalComments'] = this.approvalComments;*/
    data['longitudeS'] = this.longitudeS;
    data['latitudeS'] = this.latitudeS;
    data['longitudeD'] = this.longitudeD;
    data['latitudeD'] = this.latitudeD;
    data['eventMobility'] = this.eventMobility;
    //data['eventTime'] = this.eventTime;
    data['isPublicEvent'] = this.isPublicEvent;
    data['teamInviteStatus'] = this.teamInviteStatus;
    data['cancelReason'] = this.cancelReason;
    data['serviceType'] = this.serviceType;
    data['zoomId'] = this.zoomId;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "eventTitle": this.eventTitle,
      "eventDescription": this.eventDescription,
      "eventDate": this.eventDate,
      "eventStartTime": this.eventStartTime,
      "eventEndTime": this.eventEndTime,
      "eventType": this.eventType,
      "phoneNumber": this.phoneNumber,
      "addLineOneS": this.addLineOneS,
      "addLineTwoS": this.addLineTwoS,
      "localityS": this.localityS,
      "addLineOneD": this.addLineOneD,
      "addLineTwoD": this.addLineTwoD,
      "localityD": this.localityD,
      "city": this.city,
      "pincode": this.pincode,
      "state": this.state,
      "country": this.country,
      //"isProcessed": this.isProcessed,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      /*"approvalStatus": this.approvalStatus,
      "approvalComments": this.approvalComments,*/
      "longitudeS": this.longitudeS,
      "latitudeS": this.latitudeS,
      "longitudeD": this.longitudeD,
      "latitudeD": this.latitudeD,
      "eventMobility": this.eventMobility,
      //"eventTime": this.eventTime,
      "isPublicEvent": this.isPublicEvent,
      "teamInviteStatus": this.teamInviteStatus,
      "cancelReason": this.cancelReason,
      "serviceType": this.serviceType,
      "zoomId": this.zoomId,
    };
  }
}
