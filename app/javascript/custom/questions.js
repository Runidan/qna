$(document).on('turbolinks:load', function(){
  $('.question-rating').on('ajax:success', function(e) {
    var question = e.detail[0];
    console.log(question.voted);
    $('.question-rating .rating-value').html(question.rating);
    $('.question-rating .rating-massages').html("");
    if (question.voted) {
      $('.question-rating .vote_btn').addClass('hidden');
      $('.question-rating .unvote_btn').removeClass('hidden');
    } else {
      $('.question-rating .vote_btn').removeClass('hidden');
      $('.question-rating .unvote_btn').addClass('hidden');
    }


  })
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(key, value) {
        $('.question-rating .rating-messages').html("");
        $('.question-rating .rating-messages').append('<p>' + value + '</p>');
      })
    })
});