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
});
