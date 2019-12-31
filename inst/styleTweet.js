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
      // Fix dimensions of container div for webshot
      const st = document.getElementById('screenshot-tweet');
      const {width, height} = st.getBoundingClientRect();
      st.style.width = width + 'px';
      st.style.height = height + 'px';
    }
  );
})();
