import 'package:flutter/material.dart';
import 'package:new_bie/core/models/managers/supabase_manager.dart';
import 'package:new_bie/features/post/data/entity/likes_entity.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:provider/provider.dart';

class LikesViewmodel extends ChangeNotifier {
  int postId;
  int likes_count = 0;

  bool isWorking = false;

  LikeEntity? likeEntity;
  PostRepository _repository;

  LikesViewmodel(this.postId, this.likes_count, BuildContext cotext)
    : _repository = cotext.read<PostRepository>() {
    getLikeCount();
  }

  Future<void> getLikeCount() async {
    if (isWorking) return;
    isWorking = true;
    likes_count = await _repository.getPostLikeCount(postId);
    String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId != null) {
      likeEntity = await _repository.fetchLikeItem(postId, userId);
    }
    isWorking = false;
    notifyListeners();
  }

  Future<void> likeToggle() async {
    String? userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
    if (userId == null) return;
    if (isWorking) return;
    isWorking = true;
    if (likeEntity == null) {
      try {
        _repository.insertLike(postId, userId);
      } catch (e) {
        print("좋아요 실패 : ${e}");
      }
    } else if (likeEntity != null) {
      try {
        _repository.cancelLike(likeEntity!.id);
      } catch (e) {
        print("좋아요 취소 실패 : ${e}");
      }
    }

    likes_count = await _repository.getPostLikeCount(postId);
    likeEntity = await _repository.fetchLikeItem(postId, userId);
    isWorking = false;
    notifyListeners();
  }
}
