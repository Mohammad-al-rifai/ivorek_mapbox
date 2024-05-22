part of 'map_box_cubit.dart';

@immutable
sealed class MapBoxStates {}

final class MapBoxInitial extends MapBoxStates {}

final class MarkerPositionedDoneState extends MapBoxStates {}
