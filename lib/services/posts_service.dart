import '../models/post_model.dart';
import '../networks/api_handler.dart';
import '../networks/api_urls.dart';

class PostsService {
  ApiHandler apiHandler = ApiHandler();

  Future<PostListModel> fetchPosts(int page) async {
    final response = await apiHandler.get(
        url: "${ApiUrls.posts}?page=$page&size=10");
    return PostListModel.fromJson(response);
  }
}
