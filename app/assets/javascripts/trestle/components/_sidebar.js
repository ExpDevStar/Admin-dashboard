Trestle.ready(function() {
  var sidebar = $('.app-sidebar');

  // Toggle mobile navigation using menu button

  sidebar.find('.navbar-toggle').on('click', function(e) {
    e.preventDefault();

    $('.app-wrapper').addClass('animate');
    $('body').toggleClass('mobile-nav-expanded');
  });

  $('.app-wrapper').on('transitionend webkitTransitionEnd', function() {
    $(this).removeClass('animate');
  });


  // Interacting outside of the sidebar closes the navigation

  $('.app-wrapper').on('click touchstart', function(e) {
    var navExpanded = $('body').hasClass('mobile-nav-expanded');

    var clickInHeader = $(e.target).closest('.app-header').length;
    var clickInSidebar = $(e.target).closest('.app-sidebar').length;

    if (navExpanded && !clickInHeader && !clickInSidebar) {
      e.stopPropagation();
      e.preventDefault();

      $('.app-wrapper').addClass('animate');
      $('body').removeClass('mobile-nav-expanded');
    }
  });


  // Toggle sidebar expand/collapse

  sidebar.find('.toggle-sidebar').on('click', function(e) {
    e.preventDefault();

    if (sidebar.hasClass('expanded') || sidebar.hasClass('collapsed')) {
      sidebar.removeClass('expanded').removeClass('collapsed');
      Trestle.cookie.delete("trestle:sidebar");
    } else if ($(document).width() >= 1200) {
      sidebar.addClass('collapsed');
      Trestle.cookie.set("trestle:sidebar", "collapsed");
    } else if ($(document).width() >= 768) {
      sidebar.addClass('expanded');
      Trestle.cookie.set("trestle:sidebar", "expanded");
    }
  });


  // Toggle navigation groups

  sidebar.find('.nav-header a').on('click', function(e) {
    e.preventDefault();

    $(this).closest('ul').toggleClass('collapsed');

    var collapsed = sidebar.find('.collapsed .nav-header a').map(function() {
      return $(this).attr('href').replace(/^#/, '');
    }).toArray();

    Trestle.cookie.set("trestle:navigation:collapsed", collapsed.join(","))
  });


  // Scroll sidebar to active item

  var active = sidebar.find('.active');
  sidebar.find('.app-sidebar-inner').scrollTop(active.offset().top - 100);
});
