(function styleTweets() {
  if (typeof twttr === 'undefined') {
    setTimeout(styleTweets, 0)
    return
  }
  if (!twttr.events) {
    setTimeout(styleTweets, 0)
    return
  }
  twttr.events.bind(
    'rendered',
    function (event) {
      event.target.shadowRoot.querySelector('.EmbeddedTweet').style.borderRadius = 0;
    }
  );
})();
