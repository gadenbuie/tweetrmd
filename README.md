
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tweetrmd

<!-- badges: start -->
<!-- badges: end -->

Easily embed Tweets anywhere R Markdown turns plain text into HTML.

## Installation

You can install the released version of **tweetrmd** from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("gadenbuie/tweetrmd")
```

## Embed a Tweet

``` r
library(tweetrmd)
tweet_embed("https://twitter.com/alexpghayes/status/1211748406730706944")
```

<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">anybody have experience embedding tweets into <a href="https://twitter.com/hashtag/rmarkdown?src=hash&amp;ref_src=twsrc%5Etfw">#rmarkdown</a> documents *without using blogdown*?<a href="https://t.co/5kQUBh7j4g">https://t.co/5kQUBh7j4g</a></p>&mdash; alex hayes (@alexpghayes) <a href="https://twitter.com/alexpghayes/status/1211748406730706944?ref_src=twsrc%5Etfw">December 30, 2019</a></blockquote>

Or if you would rather use the screen name and status id.

``` r
tweet_embed(tweet_url("alexpghayes", "1211748406730706944"))
```

<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">anybody have experience embedding tweets into <a href="https://twitter.com/hashtag/rmarkdown?src=hash&amp;ref_src=twsrc%5Etfw">#rmarkdown</a> documents *without using blogdown*?<a href="https://t.co/5kQUBh7j4g">https://t.co/5kQUBh7j4g</a></p>&mdash; alex hayes (@alexpghayes) <a href="https://twitter.com/alexpghayes/status/1211748406730706944?ref_src=twsrc%5Etfw">December 30, 2019</a></blockquote>

In rich HTML outputs, the full embedded tweet is available and
interactive. Here, in GitHub-flavored markdown, only the content of the
tweet is seen.

## Embed many tweets

If you have several tweets you would like to embed at once, you can use
the following pattern to include add a vector of tweets to your
document. This works well when you want to include a [thread of
tweets](https://gist.github.com/gadenbuie/33c350458305f4423f30c1274be63b34).

``` r
thread <- c(
  "https://twitter.com/grrrck/status/1333804309272621060",
  "https://twitter.com/grrrck/status/1333804487148855300", 
  "https://twitter.com/grrrck/status/1333805092152123394"
)

htmltools::tagList(
  lapply(thread, tweet_embed, plain = TRUE)
)
```

<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">I&#39;ve got a new work laptop! I&#39;m going to try to track my setup process and the software and tools I install in this thread <a href="https://t.co/9X2qvHB3no">pic.twitter.com/9X2qvHB3no</a></p>&mdash; Garrick Aden-Buie (@grrrck) <a href="https://twitter.com/grrrck/status/1333804309272621060?ref_src=twsrc%5Etfw">December 1, 2020</a></blockquote>

<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">Step #1, wait... <a href="https://t.co/3533LZZQBt">pic.twitter.com/3533LZZQBt</a></p>&mdash; Garrick Aden-Buie (@grrrck) <a href="https://twitter.com/grrrck/status/1333804487148855300?ref_src=twsrc%5Etfw">December 1, 2020</a></blockquote>

<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">Oh wow, I really jumped the gun on this thread <a href="https://t.co/XpbzLTzStf">pic.twitter.com/XpbzLTzStf</a></p>&mdash; Garrick Aden-Buie (@grrrck) <a href="https://twitter.com/grrrck/status/1333805092152123394?ref_src=twsrc%5Etfw">December 1, 2020</a></blockquote>

(Note that I used `plain = TRUE` to embed each tweet [as
markdown](#embed-without-tracking).)

## Take a screenshot of a tweet

Screenshots are automatically embedded in R Markdown documents, or you
can save the screenshot as a `.png` or `.pdf` file. Uses the
[rstudio/webshot2](https://github.com/rstudio/webshot2) package.

``` r
tweet_screenshot(tweet_url("alexpghayes", "1211748406730706944"))
```

<img src="man/figures/README-screenshot-1.png" width="400px" />

## Just include a tweet in any R Markdown output format

When you want to include a tweet in multiple R Markdown formats, you can
use `include_tweet()`. It’s like `knitr::include_graphics()` but for
tweets. The function will automatically include the tweet as HTML in
HTML outputs, or as a screenshot in all others.

```` markdown
```{r tweet-from-dsquintana}
include_tweet("https://twitter.com/dsquintana/status/1275705042385940480")
```
````

<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">{bookdown} folks: I&#39;m trying to knit a PDF version of a HTML book that contains HTML elements (embedded tweets). <br><br>Is there a way to automatically take a screenshot of embedded tweets for PDF output? <br><br>Using the {webshot} package + PhantomJS didn&#39;t work...<a href="https://twitter.com/hashtag/Rstats?src=hash&amp;ref_src=twsrc%5Etfw">#Rstats</a></p>&mdash; Dan Quintana (@dsquintana) <a href="https://twitter.com/dsquintana/status/1275705042385940480?ref_src=twsrc%5Etfw">June 24, 2020</a></blockquote>

## Customize tweet appearance

Twitter’s [oembed
API](https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/get-statuses-oembed)
provides a number of options, all of which are made available for
customization in `tweet_embed()` and `tweet_screenshot()`.

``` r
tweet_screenshot(
  tweet_url("alexpghayes", "1211748406730706944"),
  maxwidth = 300,
  hide_media = TRUE,
  theme = "dark"
)
```

<img src="man/figures/README-screenshot-customized-1.png" width="300px" />

## Embed without tracking

You can use `tweetrmd` to embed tweets in your documents and outputs
without including Twitter JavaScript or tracking. The easiest way is to
set `plain = TRUE` in `include_tweet()`. This will insert minimal HTML
for web outputs or convert the tweet text to markdown for non-web
outputs.

``` r
include_tweet(
  "https://twitter.com/dsquintana/status/1275705042385940480",
  plain = TRUE
)
```


    ```{=html}
    <blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">{bookdown} folks: I&#39;m trying to knit a PDF version of a HTML book that contains HTML elements (embedded tweets). <br><br>Is there a way to automatically take a screenshot of embedded tweets for PDF output? <br><br>Using the {webshot} package + PhantomJS didn&#39;t work...<a href="https://twitter.com/hashtag/Rstats?src=hash&amp;ref_src=twsrc%5Etfw">#Rstats</a></p>&mdash; Dan Quintana (@dsquintana) <a href="https://twitter.com/dsquintana/status/1275705042385940480?ref_src=twsrc%5Etfw">June 24, 2020</a></blockquote>

    ```

Alternatively, you can choose to use `tweet_screenshot()` or
`tweet_markdown()` to embed all tweets in your documents.

## Caching tweets with memoization

Tweets are often deleted and re-running `tweet_embed()` or
`tweet_screenshot()` may fail or overwrite a previous screenshot of a
tweet. To avoid this, you can use the
[memoise](https://github.com/r-lib/memoise) package.

``` r
library(memoise)

tweet_cached <- memoise(tweet_embed, cache = cache_filesystem('.tweets'))
tweet_shot_cached <- memoise(tweet_screenshot, cache = cache_filesystem('.tweets'))
```

<sup>\*</sup>When memoising `tweet_screenshot()` you need to manually
save the file to a specific location. In the future my goal is for this
to be automatic.

------------------------------------------------------------------------

Note: When using `tweet_embed()`, you may need to add the following line
to your YAML header for strict markdown output formats.

``` yaml
always_allow_html: true
```
