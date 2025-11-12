class BlockedUserEvent {
  final String message;
  final BlockEventType type;
  final UIType uiType;

  BlockedUserEvent({
    this.message = "",
    required this.type,
    this.uiType = UIType.toast,
  });
}

enum BlockEventType { blockDelete }

enum UIType { toast, snakbar, customAlert }
