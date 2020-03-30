class Cast{
  List<Actor> actores=[];
  Cast.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null) return;
    jsonList.forEach( (item){
      final Actor actor=Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}


class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  getFoto(){
    if(profilePath==null){
      return "https://ramenparados.com/wp-content/uploads/2019/03/no-avatar-png-8.png";
    }
    return "https://image.tmdb.org/t/p/w500/$profilePath";
  }

  Actor.fromJsonMap( Map<String,dynamic> json){
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }
}



