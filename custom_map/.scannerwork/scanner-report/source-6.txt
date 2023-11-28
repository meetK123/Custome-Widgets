
class CountryContinentModel {
  String? capital;
  String? code;
  String? continent;
  String? flag1x1;
  String? flag4x3;
  String? url;
  bool? iso;
  String? name;

  CountryContinentModel(
      {this.capital,
        this.code,
        this.continent,
        this.flag1x1,
        this.flag4x3,
        this.url,
        this.iso,
        this.name});

  CountryContinentModel.fromJson(Map<String, dynamic> json) {
    capital = json['capital'];
    code = json['code'];
    continent = json['continent'];
    flag1x1 = json['flag_1x1'];
    flag4x3 =json['flag_4x3'];
    url =json['url'];
    iso = json['iso'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['capital'] = capital;
    data['code'] = code;
    data['continent'] = continent;
    data['flag_1x1'] = flag1x1;
    data['flag_4x3'] = flag4x3;
    data['url'] =url;
    data['iso'] = iso;
    data['name'] = name;
    return data;
  }
}
