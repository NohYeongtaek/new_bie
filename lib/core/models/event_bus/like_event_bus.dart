class LikeEventBus {
  PageType pageType;
  int? postId;
  LikeActionType type;
  LikeEventBus(this.pageType, this.type, this.postId);
}

enum PageType { home, postDetail, search }

enum LikeActionType { like, cancel }
