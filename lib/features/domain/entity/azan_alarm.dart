import 'package:equatable/equatable.dart';

class AzanAlarm extends Equatable {
  final DateTime azanDateTime;
  final String azanSoundClip;

  AzanAlarm({
    this.azanDateTime,
    this.azanSoundClip,
  });

  @override
  List<Object> get props => [azanDateTime];
}
