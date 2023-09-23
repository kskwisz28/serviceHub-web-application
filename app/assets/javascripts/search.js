document.addEventListener("turbolinks:load", function() {

  if ($("#search").length) {

    function setupAutocomplete() {
      var options = {
        url: "/list_instruments",
        list: {
          maxNumberOfElements: 30,
          match: {
            enabled: true
        }
        },

        theme: "square"
      };

      $("#search-field").easyAutocomplete(options);
    }

    setupAutocomplete();

    $("#search-field").on('change', function() {
      if ($("#search-field").val() !== "") {
        $("#sumbit-search-btn").click();
      }
    });
  }


});
