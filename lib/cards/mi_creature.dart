import '../objects/card_object.dart';

abstract class ICreature {
  // Constant
  int get baseHealth;
  int get baseAttack;

  // Variable
  int get damage;

  // Derived
  int get health;
  int get attack;
}

mixin MCreature on CardObject implements ICreature {
  @override
  int get health => baseHealth - damage;
  @override
  int get attack => baseAttack;

  @override
  List<Object> get toStringProps => super.toStringProps..add(damage);
}