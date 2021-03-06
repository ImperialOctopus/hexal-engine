import '../card/card.dart';
import '../exceptions/exceptions.dart';
import '../extensions/max_duplicates.dart';
import 'card_identity.dart';
import 'enums/location.dart';
import 'enums/player.dart';

/// List of cards.
class Deck {
  /// Card identities.
  final List<CardIdentity> identities;

  /// List of cards.
  const Deck({required this.identities});

  /// Convert this deck to a code.
  String toCode() {
    return identities
        .map((identity) =>
            identity.setId.toString() + '.' + identity.cardId.toString())
        .join(',');
  }

  /// Create a deck from its code.
  static Deck fromCode(String code) {
    final identities = code.split(',').map((cardCode) {
      final list = cardCode.split('.');

      try {
        return CardIdentity(int.parse(list[0]), int.parse(list[1]));
      } on FormatException {
        throw DeckCodeException('Error parsing card: "' + cardCode + '"');
      }
    }).toList();
    return Deck(identities: identities);
  }

  /// Convert this list to card objects.
  List<Card> toCards(int startingId, Player player) {
    var id = startingId;

    final shuffled = identities.toList()..shuffle();

    return shuffled.map((identity) {
      var card = Card.fromIdentity(identity, id).copyWith();
      id++;
      return card.copyWith(
          owner: player, controller: player, location: Location.deck);
    }).toList();
  }

  /// Validates a deck code.
  static void validateCode(String code) {
    final deck = fromCode(code);
    deck.validate();
  }

  /// Validates a deck.
  void validate() {
    final cards = toCards(2, Player.one);
    if (cards.length != 30) {
      throw const DeckCodeException('Deck must contain exactly 30 cards.');
    }
    if (identities.maxDuplicates() > 2) {
      throw const DeckCodeException(
          'Deck may not contain more than 2 of any one card.');
    }
  }
}
