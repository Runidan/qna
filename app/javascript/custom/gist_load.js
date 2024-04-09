$(document).on('turbolinks:load', function() {

  $('a').each(function() {
    var $this = $(this);
    var href = $this.attr('href');
    
    // Проверяем, что ссылка ведёт на gist.github.com
    if (href && href.includes('gist.github.com')) {
      // Создаём контейнер для содержимого Gist
      var gistContainer = $('<div class="gist-content"></div>');
      $this.after(gistContainer);

      $.ajax({
        url: href + '.json', // Получить JSON версию Gist
        method: 'GET',
        dataType: 'jsonp', // Использовать JSONP для обхода политики same-origin
        success: function(gistData) {
          // Gist может быть добавлен сразу, вставив HTML-код
          gistContainer.html(gistData.div);
          
          // Дополнительно добавляем скрипты, если они есть,
          // чтобы форматирование и стили Gist отображались корректно.
          if (gistData.stylesheet && !$('link[href="' + gistData.stylesheet + '"]').length) {
            var linkTag = $('<link>')
              .attr('rel', 'stylesheet')
              .attr('href', gistData.stylesheet);
            $('head').append(linkTag);
          }
        },
        error: function() {
          // Обработка ошибок, если Gist загрузить не удалось
          gistContainer.html('<p>Error loading Gist</p>');
        }
      });
    }
  });
});