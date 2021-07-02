part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class OnChangeNavigation extends NavigationState {
  final int index;
  OnChangeNavigation({required this.index});
}
