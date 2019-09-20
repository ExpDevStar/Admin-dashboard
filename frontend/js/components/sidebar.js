import $ from 'jquery'

import { ready } from '../core/events'
import cookie from '../core/cookie'

ready(function () {
  const $body = $('body')
  const $wrapper = $('.app-wrapper')
  const $sidebar = $('.app-sidebar')

  // Toggle mobile navigation using menu button

  $sidebar.find('.navbar-toggler').on('click', function (e) {
    e.preventDefault()

    $wrapper.addClass('animate')
    $body.toggleClass('mobile-nav-expanded')
  })

  $wrapper.on('transitionend webkitTransitionEnd', function () {
    $(this).removeClass('animate')
  })

  // Interacting outside of the sidebar closes the navigation

  $wrapper.on('click touchstart', function (e) {
    let navExpanded = $('body').hasClass('mobile-nav-expanded')

    let clickInHeader = $(e.target).closest('.app-header').length
    let clickInSidebar = $(e.target).closest('.app-sidebar').length

    if (navExpanded && !clickInHeader && !clickInSidebar) {
      e.stopPropagation()
      e.preventDefault()

      $wrapper.addClass('animate')
      $body.removeClass('mobile-nav-expanded')
    }
  })

  // Toggle sidebar expand/collapse

  $sidebar.find('.toggle-sidebar').on('click', function (e) {
    e.preventDefault()

    if ($body.hasClass('sidebar-expanded') || $body.hasClass('sidebar-collapsed')) {
      $body.removeClass('sidebar-expanded').removeClass('sidebar-collapsed')
      cookie.delete('trestle:sidebar')
    } else if ($(document).width() >= 1200) {
      $body.addClass('sidebar-collapsed')
      cookie.set('trestle:sidebar', 'collapsed')
    } else if ($(document).width() >= 768) {
      $body.addClass('sidebar-expanded')
      cookie.set('trestle:sidebar', 'expanded')
    }
  })

  // Toggle navigation groups

  $sidebar.find('.nav-header a').on('click', function (e) {
    e.preventDefault()

    $(this).closest('ul').toggleClass('collapsed')

    let collapsed = $sidebar.find('.collapsed .nav-header a').map(function () {
      return $(this).attr('href').replace(/^#/, '')
    }).toArray()

    cookie.set('trestle:navigation:collapsed', collapsed.join(','))
  })

  // Scroll sidebar to active item

  let $active = $sidebar.find('.active')
  if ($active.length) {
    $sidebar.find('.app-sidebar-inner').scrollTop($active.offset().top - 100)
  }
})
