#import('dart:html');
#import('dart:json');

// @TODO: Use templates
// @TODO: Add G+ api
// @TODO: Add location detector

dataReceived(MessageEvent e) {
  var data = JSON.parse(e.data); 
  
  for (var a = 0; a < data['responseData']['results'].length; a++) {
    Element news_title               = new Element.tag('h3');
    news_title.innerHTML             = JSON.stringify(data['responseData']['results'][a]['title']);
    document.body.elements.add(news_title);
    Element news_content             = new Element.tag('p');
    news_content.innerHTML           = JSON.stringify(data['responseData']['results'][a]['content']) + ' -- ' +
                                       "<a href=" + JSON.stringify(data['responseData']['results'][a]['signedRedirectUrl']) +
                                       ">" + "[Read More]" + "</a>";
    news_content.attributes['class'] = 'content';
    document.body.elements.add(news_content);
    Element hr                       = new Element.tag('hr');
    document.body.elements.add(hr);
  }
}

void main() {
  // listen for the postMessage from the main page
  window.on.message.add(dataReceived);
  
  Element script = new Element.tag("script");
  script.src = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=Panchkula&callback=callbackForJsonpApi";
  document.body.elements.add(script);
}