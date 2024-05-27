$(function () {
  // AOS초기화
  AOS.init({
    once: true,
    disable: window.innerWidth < 1201,
  });

  // 공유 버튼
  $('.share_wrap .share_btn').on('click', function () {
    $(this).parent().toggleClass('on');
  });
  $('#header .open_btn').on('click', function () {
    $('#header').addClass('on');
    $('body').addClass('on');
  });
  $('.menu_inner .close_btn').on('click', function () {
    $('#header').removeClass('on');
    $('body').removeClass('on');
  });

  // findlist 부분 active 효과 적용 및 제거
  function activeFindList() {
    $('.main_find_art .findlist_wrap>li').on('mouseenter', function () {
      $(this).addClass('active').siblings().removeClass('active');
    });
    $('.main_find_art .findlist_wrap').on('mouseleave', function () {
      $('.main_find_art .findlist_wrap>li:eq(0)')
        .addClass('active')
        .siblings()
        .removeClass('active');
    });
  }
  activeFindList();

  // 섹션 2 :슬라이더
  let archiveSlider = new Swiper('.main_archive .swiper', {
    loop: true,
    autoplay: {
      delay: 1000,
      disableOnInteraction: false,
    },
    speed: 1000,
    breakpoints: {
      320: {
        slidesPerView: 1.5,
        spaceBetween: 20,
      },
      768: {
        slidesPerView: 3.7,
        spaceBetween: 25,
      },
      1920: {
        slidesPerView: 5.7,
        spaceBetween: 30,
      },
      1921: {
        slidesPerView: 5.4,
        spaceBetween: 50,
      },
    },
    pagination: {
      el: '.swiper-pagination',
      type: 'progressbar',
    },
  });

  // 섹션 4 : map
  $('.main_space .local_wrap a').on('click', function (e) {
    e.preventDefault(); // 기본 동작 방지

    let index = $(this).index();

    $('.main_space .local_wrap a').removeClass('show');
    $(this).addClass('show');

    $('.main_space .adress_wrap ul').removeClass('show');
    $('.main_space .img_wrap img').removeClass('show');

    $('.main_space .adress_wrap ul').eq(index).addClass('show');
    $('.main_space .img_wrap img').eq(index).addClass('show');
  });

  // 모바일 섹션 4 : map

  $('.main_space .m_local_wrap .local_btn').on('click', function () {
    $('.main_space .local_area .m_local_wrap').toggleClass('on');
  });

  $('.main_space .m_local_wrap a').on('click', function (e) {
    e.preventDefault();

    let idx = $(this).parent().index() - 1;
    console.log(idx);

    $('.main_space .m_local_wrap a').removeClass('show');
    $(this).addClass('show');
    console.log(this);

    $('.main_space .adress_wrap ul').removeClass('show');
    $('.main_space .adress_wrap ul').eq(idx).addClass('show');
    $('.main_space .local_area .m_local_wrap').removeClass('on');
  });

  $('.main_space .m_local li').on('mouseenter', function () {
    $(this).addClass('active').siblings().removeClass('active');
  });
  $('.main_space .m_local li').on('mouseleave', function () {
    $('.main_space .m_local li:eq(0)')
      .addClass('active')
      .siblings()
      .removeClass('active');
  });

  // footer 버튼 스크롤
  $('#footer .top_btn').on('click', function () {
    $('html, body').animate({ scrollTop: 0 }, 500);
  });

  $(window)
    .on('scroll', function () {
      if ($(this).scrollTop() > $('.main_banner').height() - 200) {
        $('#footer .footer_btn').addClass('fade');
      } else {
        $('#footer .footer_btn').removeClass('fade');
      }
      if ($(window).width() > 1200) {
        if (
          $(window).scrollTop() >=
          $(document).outerHeight() - $(window).outerHeight() - 500
        ) {
          $('#footer .footer_btn').addClass('on');
        } else {
          $('#footer .footer_btn').removeClass('on');
        }
      }
    })

    .trigger('scroll');
});
