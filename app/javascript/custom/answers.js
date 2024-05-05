$(document).on('turbolinks:load', function(){
  $('.answers-list').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('.answers-list').on('click', '.cancel-button', function(e) {
    e.preventDefault();
    var answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).addClass('hidden');
    $('a#link-edit-answer-' + answerId).show();
    $('.answer-errors#answer-error-' + answerId).html('')
  })

  $('form.new-answer').on('ajax:success', function(e) {
    var answer = e.detail[0];


    $('.your-answer').append('<p>' + answer.body + '</p>');
  })
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(key, value) {
        $('#create-answer-error').html("");
        $('#create-answer-error').append('<p>' + value + '</p>');
      })
    })

  $('.answers-list').on('ajax:success', function(e) {
    var answer = e.detail[0];
    $('#answer-' + answer.id + ' .rating-value').html(answer.rating);
    $('#answer-' + answer.id + ' .rating-massages').html("");
    if (answer.voted) {
      $('#answer-' + answer.id + ' .vote_btn').addClass('hidden');
      $('#answer-' + answer.id + ' .unvote_btn').removeClass('hidden');
    } else {
      $('#answer-' + answer.id + ' .vote_btn').removeClass('hidden');
      $('#answer-' + answer.id + ' .unvote_btn').addClass('hidden');
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
