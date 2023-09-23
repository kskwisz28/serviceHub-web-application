document.addEventListener("turbolinks:load", function() {

  if ($("#searchsku").length) {

    function setupAutocomplete() {
      var options = {
        url: "/list_instrumentskus",
        list: {
          maxNumberOfElements: 30,
          match: {
            enabled: true
        }
        },

        theme: "square"
      };

      $("#searchsku-field").easyAutocomplete(options);
    }

    setupAutocomplete();

    $("#searchsku-field").on('change', function() {
      if ($("#searchsku-field").val() !== "") {
        $("#sumbit-searchsku-btn").click();
      }
    });
  }


});
