document.addEventListener("turbolinks:load", function() {

  $(".lit-section-header").on("click", function(e) {
     e.preventDefault();

    var link = $(this).find("a");
    var content = $(this).siblings(".service-hub-data-section");

    content.slideToggle("slow", function() {
      if ( link.is( ".active" ) ) {
        link.removeClass("active");
      } else {
        link.addClass("active");
      }
    });

  })
})