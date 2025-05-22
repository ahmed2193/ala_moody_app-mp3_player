import 'package:equatable/equatable.dart';


class Genres extends Equatable {
 final int? id;
 final dynamic parentId;
 final dynamic priority;
 final String? altName;
 final dynamic discover;
 final String? name;
final  String? type;
 final String? artworkUrl;
 final String? permalinkUrl;

  const Genres(
      {this. id,
this. parentId,
this. priority,
this. name,
this. altName,
this. discover,
this. type,
this. artworkUrl,
this. permalinkUrl,
      });

  @override
  List<Object?> get props => [
  id,
 parentId,
 priority,
 name,
 altName,
 discover,
 type,
 artworkUrl,
 permalinkUrl,
      ];
}
