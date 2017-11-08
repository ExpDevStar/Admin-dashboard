Trestle.Dialog = function() {
  this.el = Trestle.Dialog.getElement();
};

Trestle.Dialog.TEMPLATE =
  '<div id="dialog" class="modal fade" tabindex="-1">' +
    '<div class="modal-dialog">' +
      '<div class="modal-content" data-context></div>' +
    '</div>' +
  '</div>';

Trestle.Dialog.getElement = function() {
  var el = $('#dialog');

  if (el.length == 0) {
    el = $(Trestle.Dialog.TEMPLATE).appendTo('body');

    el.modal({ show: false });

    // Remove dialog elements once hidden
    el.on('hidden.bs.modal', function() {
      el.remove();
    });

    // Set X-Trestle-Dialog header on AJAX requests initiated from the dialog
    el.on('ajax:beforeSend', '[data-remote]', function(e, xhr, options) {
      xhr.setRequestHeader("X-Trestle-Dialog", true);
    });
  }

  return el;
};

Trestle.Dialog.prototype.load = function(url) {
  var dialog = this;

  dialog.show();
  dialog.setLoading(true);

  $.ajax({
    url: url,
    dataType: 'html',
    headers: {
      "X-Trestle-Dialog": true
    },
    complete: function() {
      dialog.setLoading(false);
    },
    success: function(content) {
      dialog.setContent(content);
    },
    error: function(xhr, status, error) {
      dialog.showError(error);
    }
  });
};

Trestle.Dialog.prototype.setLoading = function(loading) {
  if (loading) {
    this.el.addClass('loading');
  } else {
    this.el.removeClass('loading');
  }
}

Trestle.Dialog.prototype.setContent = function(content) {
  this.el.find('.modal-content').html(content);
  $(Trestle).trigger('init', this.el);
};

Trestle.Dialog.prototype.showError = function(error) {
  this.el.addClass('error');

  var container = this.el.find('.modal-content').empty();

  var errorMessage = Trestle.i18n['trestle.dialog.error'] || 'The request could not be completed.';

  $('<div class="modal-header">')
    .append('<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
    .append('<h4 class="modal-title"></h4>').find('h4').text(error || errorMessage).end()
    .appendTo(container);

  $('<div class="modal-body">')
    .append('<p>').find('p').text(errorMessage).end()
    .appendTo(container);

  $('<div class="modal-footer">')
    .append('<button type="button" class="btn btn-default" data-dismiss="modal" aria-label="OK">').find('button').text(Trestle.i18n['admin.buttons.ok'] || 'OK').end()
    .appendTo(container);
};

Trestle.Dialog.prototype.show = function() {
  this.el.modal('show');
};

Trestle.Dialog.prototype.hide = function() {
  this.el.modal('hide');
};

$(document).on('click', '[data-behavior="dialog"]', function(e) {
  e.preventDefault();

  var url = $(this).data('url') || $(this).attr('href');

  var dialog = new Trestle.Dialog();
  dialog.load(url);
});
