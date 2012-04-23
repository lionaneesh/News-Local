#import('dart:html');
#import('dart:json');

// @TODO: Add G+ api
locate(pos) {
 var lat = pos.coords.latitude;
 var lng = pos.coords.longitude;
 var parsedlat = lat.toStringAsFixed(6);
 var parsedlng = lng.toStringAsFixed(6);
  print("In locate");
  print("Latitude: "  + lat);
  print("Longitude: " + lng);
  window.localStorage.$dom_setItem("LAT", parsedlat);
  window.localStorage.$dom_setItem("LNG", parsedlng);
}

// handles all the parsing
locReceived(MessageEvent e){
  print("Beginning Parsing");
  var data = JSON.parse(e.data);
  if(data["target"] == "dartMapsHandler")
  {
    print("inside the dartmapshandler-target matched");
    Element div_wrapper = new Element.tag('div');
    div_wrapper.attributes['id'] = 'wrapper';
    document.body.elements.add(div_wrapper);
    div_wrapper = document.query('#wrapper');
    var city = JSON.stringify(data['address']['city']);
    print(city);
    window.localStorage.$dom_setItem("CITY",city);
  } else if(data["target"] == "dartJsonHandler") {
    Element div_wrapper = new Element.tag('div');
    div_wrapper.attributes['id'] = 'wrapper';
    document.body.elements.add(div_wrapper);
    div_wrapper = document.query('#wrapper');
    
    for (var a = 0; a < data['responseData']['results'].length; a++) {
      var headline = JSON.stringify(data['responseData']['results'][a]['title']);
      var content  = JSON.stringify(data['responseData']['results'][a]['content']);

      // @HACK: for removing double quoates
      headline = headline.replaceAll(new RegExp("\"\$"), '');
      headline = headline.replaceAll(new RegExp("^\""), '');
      content  = content.replaceAll(new RegExp("\"\$"), '');
      content  = content.replaceAll(new RegExp("^\""), '');

      Element div_news = new Element.tag('div');
      div_news.attributes['id'] = 'news';
      div_wrapper.elements.add(div_news);
      Element news_title               = new Element.tag('h3');
      news_title.innerHTML             = headline;
      div_news.elements.add(news_title);
      Element news_content             = new Element.tag('p');
      news_content.innerHTML           =  content + " " +
                                         "<a href=" + JSON.stringify(data['responseData']['results'][a]['signedRedirectUrl']) +
                                         " target='_blank' >" + "[Read More]" + "</a>";
      news_content.attributes['class'] = 'content';
      div_news.elements.add(news_content);
    }
  }
}

void main() {
  // listen for the postMessage from the main page

  //the parser called on message add
  window.on.message.add(locReceived);

  //the geolocation function giving the lat and lng
  window.navigator.geolocation.getCurrentPosition(locate);
  var somelat=window.localStorage.$dom_getItem("LAT");
  var somelng=window.localStorage.$dom_getItem("LNG");

  //begin reverse geocode
  //try with google maps api returning error due to jsonp
  //var someurl="https://maps.googleapis.com/maps/api/geocode/json?latlng="+somelat+","+somelng+"&sensor=false&callback=callbackForMapsApi";
  Element script = new Element.tag("script");
  var someurl    = "http://nominatim.openstreetmap.org/reverse?format=json&lat=" + somelat + "&lon=" + somelng + "&addressdetails=1&json_callback=callbackForMapsApi";
  script.src     = someurl;
  document.body.elements.add(script);

  //beginnning news display
  var somecity = window.localStorage.$dom_getItem("CITY");
  Element newsscript = new Element.tag("script");
  var somenewsurl    = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=" + somecity + "&callback=callbackForJsonpApi";
  newsscript.src     = somenewsurl;
  document.body.elements.add(newsscript);

}