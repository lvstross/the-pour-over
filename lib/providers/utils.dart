///
/// Gets attribute values from a string html element.
/// It grabs all values in between a pair of double quotes ("")
///
/// Example: <a href="http://link.com" target="_blank" meta-data="some-data" />
/// Result: ["http://link.com", "_blank", "some-data"]
///
List<String?> getElementAttributeValues(String el) {
  RegExp exp = RegExp(r'(["])(?:(?=(\\?))\2.)*?\1');
  Iterable<RegExpMatch> matches = exp.allMatches(el);
  List<String?> attrs = [];
  for (var m in matches) {
    var groupItem = m.group(0);
    attrs.add(groupItem?.substring(1, groupItem.length - 1));
  }
  return attrs;
}
