$(document).ready(() => {
  $('#add-tweet').click(function() {
    $('#add-tweet-form').toggle();
  });

  // Submit the form on click of the "POST!" button
  $('#add-tweet-submit').click(function() {
    var tweetMessageField = $('#add-tweet-message')
    var tweetMessageAvatar = $('#add-tweet-avatar')
    var tweetMessageForm = $('#add-tweet-form')
    var tweetMessage = tweetMessageField.val()
    var tweetAvatar = tweetMessageAvatar.val()

    $.ajax({
      type: 'POST',
      url: '/tweets',
      contentType: 'application/json',
      data: JSON.stringify({ tweet: {
        avatar: tweetAvatar,
        message: tweetMessage }}),
      success: (d) => {
        tweetMessageField.val('');
        tweetMessageForm.toggle();
      }
    })
  })

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
