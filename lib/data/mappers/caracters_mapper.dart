import 'package:pmu/data/dtos/characters_dto.dart';
import 'package:pmu/domain/models/card.dart';

const _imagePlaceholder =
    'https://upload.wikimedia.org/wikipedia/en/archive/b/b1/20210811082420%21Portrait_placeholder.png';

extension CharacterDataDtoToModel on CharacterDataDto {
  CardData toDomain() => CardData(
    attributes?.penguin ?? 'UNKNOWN',
    descriptionText: attributes?.penguin ?? 'UNKNOWN',
    imageUrl: attributes?.image ?? _imagePlaceholder,
  );
}
