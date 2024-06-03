$(function () {
  // AOS초기화
  AOS.init({
    once: true,
    disable: window.innerWidth < 1201,
  });
  
  const mainSwiper = new Swiper('.main_sliders', {
  // Optional parameters
  loop: true,
  effect: 'fade',
  atuoplay: {
	delay: 3000
  },

  // If we need pagination
  pagination: {
    el: '.swiper-pagination',
  },

  // Navigation arrows
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },

});

const bestSeller = new Swiper('.best_slider', {
  loop: true,
	slidesPerView: 3,
	spaceBetween: 10,

  // If we need pagination
  pagination: {
    el: '.swiper-pagination',
  },

  // Navigation arrows
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
});

const newBookList = new Swiper('.new_slider', {
  loop: true,
	slidesPerView: 3,
	spaceBetween: 10,

  // If we need pagination
  pagination: {
    el: '.swiper-pagination',
  },

  // Navigation arrows
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },

});

  // footer 버튼 스크롤
  $('#footer .top_btn').on('click', function () {
    $('html, body').animate({ scrollTop: 0 }, 500);
  });

  $(window)
    .on('scroll', function () {
      if ($(this).scrollTop() > 200 ) {
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
