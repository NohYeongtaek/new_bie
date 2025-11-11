class CommentEvent {
  CommentEventType type;
  CommentEvent(this.type);
}

enum CommentEventType { commentDelete }
