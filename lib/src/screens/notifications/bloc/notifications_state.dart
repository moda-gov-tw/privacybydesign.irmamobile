part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<Notification> notifications;

  get hasUnreadNotifications => notifications.any((notification) => !notification.read);

  const NotificationsLoaded(this.notifications);
}

class NotificationsInitialized extends NotificationsLoaded {
  const NotificationsInitialized(super.notifications);
}
