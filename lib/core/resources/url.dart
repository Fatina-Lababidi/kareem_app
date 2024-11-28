class EndPoint {
  static const String baseUrl =
      'http://199.192.19.220:3012/api/v1'; //! change this
  static const String registerUrl = '$baseUrl/auth/register';
  static const String loginUrl = '$baseUrl/auth/authenticate';
  static const String changePassword = '$baseUrl/users/change-password';

  static const String getPolicyUrl = '$baseUrl/policy';
  static const String bicycleCategories =
      '$baseUrl/bicycle/bicycles-categories';

  static String bicyclesByCategoryUrl(String category) {
    return '$baseUrl/bicycle/bicycles-by-category?category=$category';
  }

//  can i make it without this?
  static String bicycleByIdUrl(int id) {
    return '$baseUrl/bicycle/$id';
  }

  static String getAllHubsUrl(num latitude, num longtitude) {
    return '$baseUrl/hubs?longtitude=$longtitude&latitude=$latitude';
  }

  static String addFavouriteUrl = "$baseUrl/favourite-bicycles";

  // static String getFavouritebyClientId(int clientId) {
  //   return 'https://rideshare.devscape.online/api/v1/favourite-bicycles/by-clientId/$clientId';
  // }

  static String getFavouriteBikesForClient =
      '$baseUrl/favourite-bicycles/clientFavourite';
  static String gethubContentUrl(int hubId, String category) {
    return '$baseUrl/hub-content/$hubId?bicycleCategory=$category';
  }

  static String getMyWalletInfo = '$baseUrl/wallet';
  static String createNewWallet = '$baseUrl/wallet';
  static String addMoney = '$baseUrl/wallet';

  static String allCode = '$baseUrl/wallet/All-valid-codes';

  static String makeReservationUrl = '$baseUrl/reservation';

  static String deleteFavouriteBike(int favouriteId) {
    return '$baseUrl/favourite-bicycles/$favouriteId';
  }

  static String reservationPayment =
      '$baseUrl/reservation/reseravation-payment';

  static String getReservationDetailsByClientId(int clientId) {
    return '$baseUrl/reservation/by-client-id/$clientId';
  }
}
