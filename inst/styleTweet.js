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
      // Fix dimensions of container div for webshot
      const st = document.getElementById('screenshot-tweet');
      if (event.target.shadowRoot) {
        // older versions of the widgets.js used shadow DOM
        event.target.shadowRoot.querySelector('.EmbeddedTweet').style.borderRadius = 0;
        const {width, height} = st.getBoundingClientRect();
        st.style.width = width + 'px';
        st.style.height = height + 'px';
      } else {
        // newer versions use an iframe and don't let us change the style
        setTimeout(function() {
          const {width, height} = st.querySelector('iframe').getBoundingClientRect();
          st.style.width = width + 'px';
          st.style.height = height + 'px';
        }, 200)
      }
    }
  );
})();
