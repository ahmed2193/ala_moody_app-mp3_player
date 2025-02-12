class EndPoints {
  static const String baseUrl = 
  "https://alamoody.com/api/";
// "https://alamoody.webtekdemo.com/api/";
  static const String login = "auth/login";
  static const String register = "auth/signup";
  static const String resetPassword = "auth/user/settings/password";
  static const String forgetPassword = "auth/forget/password";
  static const String updateprofile = "profile/update";
  static const String profile = "profile";
  //home endpoints
  static const String playLists = "playlists";
  static const String popularSongs = "popular/songs";
  static const String recentListen = "user/recent";

  static const String onTrackPlayed = "stream/on-track-played";
  static const String songDetails = "song";
  static const String playlistDetails = "playlist";
  static const String category = "genres";
  static const String moods = "moods";
  static const String playlistAudio = "playlist/";
  static const String favorites = "user/favorites";
  static const String addAndRemoveFromFav = "user/add/favorite/song";
  static const String search = "search";
  static const String artists = "artists";
  static const String artistDetails = "artist/";
  static const String followAndUnFollow = "user/follow/unfollow/artist";
  static const String notifications = "user/notifications";
  static const String homepage = "homepage";
  static const String radio = "radio/categories";
  static const String radioCategory = "radio/category/";
  static const String myPlaylists = "auth/user/playlists";
  static const String createPlaylist = "auth/user/createPlaylist";
  static const String removeFromPlaylist = "auth/user/removeFromPlaylist";
  static const String addToPlaylist = "auth/user/addToPlaylist";
  static const String loginWithSoialMedia = "auth/social/login";
  static const String subscription = "settings/subscription";
  static const String subscribeToPlan = "subscription/stripe";
  static const String directSubscribeToPlan = "user/subscription/confirm";
  static const String updateToken = "store/firebase/token";
  static const String contactUs = "contact-us";
  static const String liveUsers = "live/users";
  static const String usersIsLive = "user/is/live";
  static const String discover = "discover";
  static const String deleteAccount = "auth/user/delete/account";
  static const String unsubscription = "auth/user/subscription/cancel";
  static const String ringtones = "ringtones";
  static const String occasions = "genres/";
  static const String genres = "genres/7/songs";
  static const String followed = "user/follow/followed";
  static const String activeCoupon = "active-coupon";
  static const String categories = "categories";
}
