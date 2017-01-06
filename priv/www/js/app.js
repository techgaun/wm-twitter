$(document).ready(() => {
  let generateTweet = (tweet) => {
    return '<li><div class="avatar" style="background: url(' +
      tweet.avatar +
      '); background-size: auto 50px; background-position: center center;"></div><div class="message">' +
      tweet.message + '</div></li>'
  }

  $.get({
    url: '/tweets',
    success: (d) => {
      d.tweets.reverse().forEach((i) => $('#tweet-list').append(generateTweet(i)))
    }
  })
})
