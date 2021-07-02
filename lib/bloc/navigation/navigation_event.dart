part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class ChangeNavigation extends NavigationEvent {
  final int index;
  ChangeNavigation({required this.index});
}
