class UserUtils {

  /// @param yourId - current user id
  /// @param userId - user id
  static String buildChatGroupId(String yourId, String userId) {
    String groupChatId;
    if (yourId.hashCode <= userId.hashCode) {
      groupChatId = '$yourId-${userId}';
    } else {
      groupChatId = '${userId}-$yourId';
    }

    return groupChatId;
  }
}