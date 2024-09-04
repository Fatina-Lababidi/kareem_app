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

  static String addFavouriteUrl =
      "https://rideshare.devscape.online/api/v1/favourite-bicycles";

  // static String getFavouritebyClientId(int clientId) {
  //   return 'https://rideshare.devscape.online/api/v1/favourite-bicycles/by-clientId/$clientId';
  // }

  static String getFavouriteBikesForClient =
      'https://rideshare.devscape.online/api/v1/favourite-bicycles/clientFavourite';
  static String gethubContentUrl(int hubId, String category) {
    return 'https://rideshare.devscape.online/api/v1/hub-content/$hubId?bicycleCategory=$category';
  }

  static String getMyWalletInfo =
      'https://rideshare.devscape.online/api/v1/wallet';
  static String createNewWallet =
      'https://rideshare.devscape.online/api/v1/wallet';
  static String addMoney = 'https://rideshare.devscape.online/api/v1/wallet';

  static String allCode =
      'https://rideshare.devscape.online/api/v1/wallet/All-valid-codes';

  static String makeReservationUrl =
      'https://rideshare.devscape.online/api/v1/reservation';

  static String deleteFavouriteBike(int favouriteId) {
    return 'https://rideshare.devscape.online/api/v1/favourite-bicycles/$favouriteId';
  }
}
