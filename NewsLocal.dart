//#import('dart:html');
//#import('dart:io');

class NewsLocal {

  NewsLocal() {
    print("hey!");
    HttpClient hc = new HttpClient();
    hc.openUrl("print", "http://google.com/");
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    document.query('#status').innerHTML = message;
  }
}

void main() {
  print("Hey!");
}
