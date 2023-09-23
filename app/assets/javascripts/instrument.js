document.addEventListener("turbolinks:load", function() {
  setTimeout(function(){
    $('#flash').slideToggle();
  }, 3000);


  if ($("#query-result *").length !== 0) {
    $("#query-result").addClass("active");
  }

  // Copy pasta from js.erb templates necessary for when users load page from pasting in a URL.
  // I'm not a fan of this duplication.  Looking for a way to consolidate.

  // Copied from _query_results
  $("#sumbit-search-btn").hide();
  $("#clear-search-icon").show();

  var reset = function() {
    $("#sumbit-search-btn").show();
    $("#clear-search-icon").hide();

    $("#search-field").val("");
    $("#query-result").empty();
    $("#query-result").removeClass("active");
  }

  $("#clear-search-icon").on("click", reset);
  $(".header-area .clear-search-area").on("click", reset);

  // Copied frmm instruments/show.js.erb
  $(".show-details").on("click", function(e) {
    e.preventDefault();

    var link = $(this);
    var detailsArea = $(this).parent().siblings(".details-area");

    detailsArea.slideToggle("slow", function() {
      if ( link.context.classList.contains("active") ) {
        link.text("Show Details");
        link.removeClass("active");
      } else {
        link.text("Hide Details");
        link.addClass("active");
      }
    });
  });



})