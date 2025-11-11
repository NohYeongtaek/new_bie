import 'package:flutter/cupertino.dart';
import 'package:new_bie/features/post/data/post_repository.dart';
import 'package:provider/provider.dart';

class PostProfileViewModel {
  final PostRepository _postRepository;
  final String userId;

  PostProfileViewModel(this.userId, BuildContext context)
    : _postRepository = context.read<PostRepository>() {}
}
