import 'package:json_annotation/json_annotation.dart';

part 'characters_dto.g.dart';

@JsonSerializable(createToJson: false)
class CharactersDto {
  final List<CharacterDataDto>? data;

  const CharactersDto({this.data});

  factory CharactersDto.fromJson(Map<String, dynamic> json) => _$CharactersDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CharacterDataDto {
  final String? id;
  final String? type;
  final CharacterAttributesDataDto? attributes;

  const CharacterDataDto({this.id, this.type, this.attributes});

  factory CharacterDataDto.fromJson(Map<String, dynamic> json) => _$CharacterDataDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CharacterAttributesDataDto {
  final String? penguin;
  final String? image;

  const CharacterAttributesDataDto({this.penguin, this.image});

  factory CharacterAttributesDataDto.fromJson(Map<String, dynamic> json) =>
      _$CharacterAttributesDataDtoFromJson(json);
}
