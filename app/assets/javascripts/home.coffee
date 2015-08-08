$ ->
  $('.ui.masthead.segment .ui.container .column')
    .transition
      animation: 'scale',
      duration: '2s'
  $('.ui.masthead.segment .ui.inverted.learn.more.button').click ->
    $('html, body').animate {
      scrollTop: $('.ui.features.segment').offset().top
    }, 1000
  $('.ui.mockup.segment .column')
    .visibility
      onBottomVisible: (calculations) ->
        $('.ui.first.step')
          .transition
            animation: 'fade up',
            duration: '1s',
            onComplete: ->
              $('.ui.second.step')
                .transition
                  animation: 'fade up',
                  duration: '1s',
                  onComplete: ->
                    $('.ui.third.step')
                      .transition
                        animation: 'fade up',
                        duration: '1s'
