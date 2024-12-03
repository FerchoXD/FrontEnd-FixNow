import 'package:fixnow/domain/entities/post.dart';
import 'package:fixnow/infrastructure/datasources/forum_data.dart';
import 'package:fixnow/infrastructure/errors/custom_error.dart';
import 'package:fixnow/infrastructure/inputs/forum/content.dart';
import 'package:fixnow/infrastructure/inputs/forum/post_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

enum ForumOption {
  all,
  myPost,
}

final forumProvider = StateNotifierProvider<ForumNotifier, ForumState>((ref) {
  final forumData = ForumData();
  return ForumNotifier(forumData: forumData);
});

class ForumState {
  final TitlePost title;
  final ContentPost content;
  final bool isValidPost;
  final bool isPosting;
  final bool isFormPosted;
  final List<Post> listPost;
  final List<Post> myListPost;
  final String message;
  final ForumOption forumOption;
  const ForumState(
      {this.title = const TitlePost.pure(),
      this.content = const ContentPost.pure(),
      this.isValidPost = false,
      this.isPosting = false,
      this.isFormPosted = false,
      this.listPost = const [],
      this.myListPost = const [],
      this.message = '',
      this.forumOption = ForumOption.all});

  ForumState copyWith({
    TitlePost? title,
    String? username,
    ContentPost? content,
    bool? isValidPost,
    bool? isPosting,
    bool? isFormPosted,
    List<Post>? listPost,
    List<Post>? myListPost,
    String? message,
    ForumOption? forumOption,
  }) =>
      ForumState(
          title: title ?? this.title,
          content: content ?? this.content,
          isValidPost: isValidPost ?? this.isValidPost,
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          listPost: listPost ?? this.listPost,
          myListPost: myListPost ?? this.myListPost,
          message: message ?? this.message,
          forumOption: forumOption ?? this.forumOption);
}

class ForumNotifier extends StateNotifier<ForumState> {
  final ForumData forumData;
  ForumNotifier({required this.forumData}) : super(const ForumState());

  onChangedTitlePost(String value) {
    final newTitle = TitlePost.dirty(value);
    state = state.copyWith(
        title: newTitle, isValidPost: Formz.validate([state.content]));
  }

  onChangedContentPost(String value) {
    final newContentPost = ContentPost.dirty(value);
    state = state.copyWith(
        content: newContentPost, isValidPost: Formz.validate([state.title]));
  }

  Future<void> createPost(String username) async {
    _touchEveryField();
    if (!state.isValidPost) return;
    state = state.copyWith(isPosting: true);
    try {
      final String time = DateTime.now().toIso8601String();
      final newPost = await forumData.createPost(
          username, state.title.value, state.content.value, time);
      state = state.copyWith(
          myListPost: [...state.myListPost, newPost], isFormPosted: true);
    } on CustomError catch (e) {
      state = state.copyWith(isPosting: false, isFormPosted: false, message: e.message);
    }
    state = state.copyWith(isPosting: false, isFormPosted: false);
  }

  updateOption(ForumOption value) {
    state = state.copyWith(forumOption: value);
  }


  _touchEveryField() {
    final title = TitlePost.dirty(state.title.value);
    final content = ContentPost.dirty(state.content.value);
    state = state.copyWith(
        isFormPosted: true,
        title: title,
        content: content,
        isValidPost: Formz.validate([title, content]));
  }
}
