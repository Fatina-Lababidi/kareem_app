class EndPoint {
  static const String baseUrl =
      'https://rideshare.devscape.online/api/v1/'; //! change this
  static const String registerUrl =
      'https://rideshare.devscape.online/api/v1/auth/register';
  static const String loginUrl =
      'https://rideshare.devscape.online/api/v1/auth/authenticate';
  static const String changePassword =
      'https://rideshare.devscape.online/api/v1/users/change-password';

  static const String getPolicyUrl =
      'https://rideshare.devscape.online/api/v1/policy';
  static const String bicycleCategories =
      'https://rideshare.devscape.online/api/v1/bicycle/bicycles-categories';

  static String bicyclesByCategoryUrl(String category) {
    return 'https://rideshare.devscape.online/api/v1/bicycle/bicycles-by-category?category=$category';
  }

//  can i make it without this?
  static String bicycleByIdUrl(int id) {
    return 'https://rideshare.devscape.online/api/v1/bicycle/$id';
  }

  static String getAllHubsUrl(num latitude, num longtitude) {
    return 'https://rideshare.devscape.online/api/v1/hubs?longtitude=$longtitude&latitude=$latitude';
  }
}
