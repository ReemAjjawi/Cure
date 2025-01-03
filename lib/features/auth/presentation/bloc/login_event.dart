

import '../../models/request/model.dart';

sealed class LogInClassEvent {}

class LogInEvent extends LogInClassEvent {
  LogInModel user;
 LogInEvent(
     this.user,
  );
}
