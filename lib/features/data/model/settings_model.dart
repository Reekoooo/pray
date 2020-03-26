import 'package:pray/features/domain/entity/settings.dart';

class SettingsModel extends Settings{
  SettingsModel({String city,String country,int method}):
      super(city: city,country: country,method: method);

  factory SettingsModel.fromJson(Map<String,dynamic> json){
    return SettingsModel(
      city: json['city'] ,//!= null? json['city']:null,
      country: json['country'] ,//=! null ? json['country']:null,
      method: json['method']
    );
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map<String,dynamic>();

    if(this.city != null){
      data['city'] = city;
    }

    if(this.country != null){
      data['country'] = country;
    }
    if(this.method != null){
      data['method'] = method;
    }
    return data;
  }
}