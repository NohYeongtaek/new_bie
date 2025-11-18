class PostEventBus {
  PostEventType type;
  int? postId;
  PostEventBus(this.type, {this.postId});
}

enum PostEventType { edit, add }
