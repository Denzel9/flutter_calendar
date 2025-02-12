String parseLinkImage(String link) {
  return link.split('%2F').last.split('.').first;
}
