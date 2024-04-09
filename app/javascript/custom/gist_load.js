$(document).on('turbolinks:load', function() {

  $('a').each(function() {
    var $this = $(this);
    var href = $this.attr('href');
    
    if (href && href.includes('gist.github.com')) {
      var gistContainer = $('<div class="gist-content"></div>');
      $this.after(gistContainer);

      $.ajax({
        url: href + '.json',
        method: 'GET',
        dataType: 'jsonp',
        success: function(gistData) {
          gistContainer.html(gistData.div);
          
          if (gistData.stylesheet && !$('link[href="' + gistData.stylesheet + '"]').length) {
            var linkTag = $('<link>')
              .attr('rel', 'stylesheet')
              .attr('href', gistData.stylesheet);
            $('head').append(linkTag);
          }
        },
        error: function() {
          gistContainer.html('<p>Error loading Gist</p>');
        }
      });
    }
  });
});
