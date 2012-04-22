#import('dart:html');
#import('dart:json');

// @TODO: Add G+ api
// @TODO: Add location detector

dataReceived(MessageEvent e) {
  var data = JSON.parse(e.data);   
 
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
                                       ">" + "[Read More]" + "</a>";
    news_content.attributes['class'] = 'content';
    div_news.elements.add(news_content);
  }
}

void main() {
  // listen for the postMessage from the main page
  window.on.message.add(dataReceived);
  
  Element script = new Element.tag("script");
  script.src = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=Panchkula&callback=callbackForJsonpApi";
  document.body.elements.add(script);
}