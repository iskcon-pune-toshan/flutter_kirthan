import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/storage_repo.dart';

class TeamRequest {
  final int id;
  String teamTitle;
  String teamDescription;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String approvalStatus;
  String location;
  String category;
  String experience;
  int phoneNumber;
  String teamLeadId;
  String localAdminArea;
  String localAdminName;
  List<TeamUser> listOfTeamMembers;
  int requestAcceptance;
  int duration;
//Typically called form service layer to create a new user
  TeamRequest(
      {this.id,
        this.teamTitle,
        this.teamDescription,
        this.createdBy,
        this.updatedBy,
        this.createdTime,
        this.updatedTime,
        this.approvalStatus,
        this.location,
        this.category,
        this.experience,
        this.phoneNumber,
        this.teamLeadId,
        this.localAdminArea,
        this.localAdminName,
        this.listOfTeamMembers,
        this.requestAcceptance,
        this.duration});

//Typically called from the data_source layer after getting data from an external source.
  factory TeamRequest.fromJson(Map<String, dynamic> data) {
    return TeamRequest(
      id: data['id'],
      teamTitle: data['teamTitle'],
      teamDescription: data['teamDescription'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      approvalStatus: data['approvalStatus'],
      location: data['location'],
      category: data['category'],
      experience: data['experience'],
      phoneNumber: data['phoneNumber'],
      teamLeadId: data['teamLeadId'],
      localAdminArea: data['localAdminArea'],
      localAdminName: data['localAdminName'],
      listOfTeamMembers: data['listOfTeamMembers'],
      requestAcceptance: data['requestAcceptance'],
      duration: data['duration'],
    );
  }

  factory TeamRequest.fromMap(Map<String, dynamic> map) {
    return TeamRequest(
      id: map['id'],
      teamTitle: map['teamTitle'],
      teamDescription: map['teamDescription'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      approvalStatus: map['approvalStatus'],
      location: map['location'],
      category: map['category'],
      experience: map['experience'],
      phoneNumber: map['phoneNumber'],
      teamLeadId: map['teamLeadId'],
      localAdminArea: map['localAdminArea'],
      localAdminName: map['localAdminName'],
      requestAcceptance: map['requestAcceptance'],
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamTitle'] = this.teamTitle;
    data['teamDescription'] = this.teamDescription;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime'] = this.createdTime;
    data['approvalStatus'] = this.approvalStatus;
    data['location'] = this.location;
    data['category'] = this.category;
    data['experience'] = this.experience;
    data['phoneNumber'] = this.phoneNumber;
    data['teamLeadId'] = this.teamLeadId;
    data['localAdminArea'] = this.localAdminArea;
    data['localAdminName'] = this.localAdminName;
    data['listOfTeamMembers'] = this.listOfTeamMembers;
    data['requestAcceptance'] = this.requestAcceptance;
    data['duration'] = this.duration;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "teamDescription": this.teamDescription,
      "teamTitle": this.teamTitle,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      "approvalStatus": this.approvalStatus,
      "location": this.location,
      "category": this.category,
      "experience": this.experience,
      "phoneNumber": this.phoneNumber,
      "teamLeadId": this.teamLeadId,
      "localAdminArea": this.localAdminArea,
      "localAdminName": this.localAdminName,
      "listOfTeamMembers": this.listOfTeamMembers,
      "requestAcceptance": this.requestAcceptance,
      "duration": this.duration,
    };
  }
}