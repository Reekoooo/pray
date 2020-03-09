import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{


}
class NotificationFailure extends Failure{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ServerFailure extends Failure{
  @override
  List<Object> get props => [];
  
}

class CashFailure extends Failure{
  @override

  List<Object> get props => [];
}

class LocationFailure extends Failure{
  @override
  List<Object> get props => [];
}