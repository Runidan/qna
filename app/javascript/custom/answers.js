$(document).on('turbolinks:load', function(){
  $('.answers-list').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('.answers-list').on('click', '.delete-answer-link', function(e) {
    e.preventDefault();
    var answerId = $(this).data('answerId');
    
    if (confirm('Are you sure you want to delete this answer?')) {
      $.ajax({
        url: '/answers/' + answerId,
        type: 'DELETE',
        dataType: 'script'
      });
    }
  })
});
