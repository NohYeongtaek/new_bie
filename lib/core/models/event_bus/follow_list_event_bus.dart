class FollowListEventBus {
  final String message;
  final FollowEventType type;
  final UIType uiType;

  FollowListEventBus({
    this.message = "",
    required this.type,
    this.uiType = UIType.toast,
  });
}

enum FollowEventType { unFollow, addFollow }

enum UIType { toast, snakbar, customAlert }
