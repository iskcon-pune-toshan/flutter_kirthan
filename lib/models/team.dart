import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/storage_repo.dart';

class TeamRequest {
  final int id;
  String teamTitle;
  String teamDescription;
  bool isProcessed;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String approvalStatus;
  String approvalComments;
  String availableTime;
  String weekDay;
  String location;
  String category;
  String experience;
  int phoneNumber;
  String teamLeadId;
  String localAdminArea;
  String localAdminName;
  List<TeamUser> listOfTeamMembers;

//Typically called form service layer to create a new user
  TeamRequest(
      {this.id,
      this.teamTitle,
      this.teamDescription,
      this.isProcessed,
      this.createdBy,
      this.updatedBy,
      this.createdTime,
      this.updatedTime,
      this.approvalStatus,
      this.approvalComments,
      this.availableTime,
      this.weekDay,
      this.location,
      this.category,
      this.experience,
      this.phoneNumber,
      this.teamLeadId,
      this.localAdminArea,
      this.localAdminName,
      this.listOfTeamMembers});

//Typically called from the data_source layer after getting data from an external source.
  factory TeamRequest.fromJson(Map<String, dynamic> data) {
    return TeamRequest(
      id: data['id'],
      teamTitle: data['teamTitle'],
      teamDescription: data['teamDescription'],
      isProcessed: data['isProcessed'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      approvalStatus: data['approvalStatus'],
      approvalComments: data['approvalComments'],
      availableTime: data['availableTime'],
      weekDay: data['weekDay'],
      location: data['location'],
      category: data['category'],
      experience: data['experience'],
      phoneNumber: data['phoneNumber'],
      teamLeadId: data['teamLeadId'],
      localAdminArea: data['localAdminArea'],
      localAdminName: data['localAdminName'],
      listOfTeamMembers: data['listOfTeamMembers'],
    );
  }

  factory TeamRequest.fromMap(Map<String, dynamic> map) {
    return TeamRequest(
      id: map['id'],
      teamTitle: map['teamTitle'],
      teamDescription: map['teamDescription'],
      isProcessed: map['isProcessed'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      approvalStatus: map['approvalStatus'],
      approvalComments: map['approvalComments'],
      availableTime: map['availableTime'],
      weekDay: map['weekDay'],
      location: map['location'],
      category: map['category'],
      experience: map['experience'],
      phoneNumber: map['phoneNumber'],
      teamLeadId: map['teamLeadId'],
      localAdminArea: map['localAdminArea'],
      localAdminName: map['localAdminName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamTitle'] = this.teamTitle;
    data['teamDescription'] = this.teamDescription;
    data['isProcessed'] = this.isProcessed;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime'] = this.createdTime;
    data['approvalStatus'] = this.approvalStatus;
    data['approvalComments'] = this.approvalComments;
    data['availableTime'] = this.availableTime;
    data['weekDay'] = this.weekDay;
    data['location'] = this.location;
    data['category'] = this.category;
    data['experience'] = this.experience;
    data['phoneNumber'] = this.phoneNumber;
    data['teamLeadId'] = this.teamLeadId;
    data['localAdminArea'] = this.localAdminArea;
    data['localAdminName'] = this.localAdminName;
    data['listOfTeamMembers'] = this.listOfTeamMembers;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "teamDescription": this.teamDescription,
      "teamTitle": this.teamTitle,
      "isProcessed": this.isProcessed,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      "approvalStatus": this.approvalStatus,
      "approvalComments": this.approvalComments,
      "availableTime": this.availableTime,
      "weekDay": this.weekDay,
      "location": this.location,
      "category": this.category,
      "experience": this.experience,
      "phoneNumber": this.phoneNumber,
      "teamLeadId": this.teamLeadId,
      "localAdminArea": this.localAdminArea,
      "localAdminName": this.localAdminName,
      "listOfTeamMembers": this.listOfTeamMembers,
    };
  }
}
