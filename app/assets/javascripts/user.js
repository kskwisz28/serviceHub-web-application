document.addEventListener("turbolinks:load", function() {

  var knownUser = $('[data-is-known-user]').data().isKnownUser;
  if (knownUser !== true) {
    $('#userPrefsModal').modal('show');
  }
  var countryField = $('#country-select');

  $.getJSON("/countries", function(countries) {

    function setupAutocomplete() {
      var options = {
        data: countries,
        getValue: "name",
        list: {
          match: {
            enabled: true
          },
          maxNumberOfElements: countries.length,
          onSelectItemEvent: function() {
            countryField = $('#country-select');
            var value = countryField.getSelectedItemData().name;

            countryField.val(value).trigger("change");

            if (countryFieldValid()) {

              $('#country-error').css('display', 'none');

              runValidations();
            } else {
              $('#country-error').css('display', 'block');
            }
          }
        },
        theme: "square"
      };

      $("#country-select").easyAutocomplete(options).click(function() {
        // Austomatically show dropdown when user clicks on #country-select
        $(this).triggerHandler(jQuery.Event("keyup", { keyCode: 65, which: 65}))
      });
    }

    setupAutocomplete();

    var countryField = $('#country-select');
    var instrumentRoleField = $('#user_role_instrumentsales');
    var serviceRoleField = $('#user_role_servicesales');

    function configureForm() {
      var instrumentRoleChecked = instrumentRoleField.is(':checked');
      var serviceRoleChecked = serviceRoleField.is(':checked');

      var instrumentRoleChecked = $('#user_role_instrumentsales').is(':checked');
      if (!instrumentRoleChecked && !serviceRoleChecked && !countryField.val().length) {
        $('#userPrefsModal').find(':submit').prop('disabled', true);
      }
    }

    configureForm();


    $('#country-error').css('display', 'none');

    // form validation
    // added here b/c they also rely on the countries JSON file.

    function enableSubmitButton() {
      var saveButton = $('#userPrefsModal').find(':submit');
      saveButton.removeAttr('disabled');
      var knownUser = $('[data-is-known-user]').data().isKnownUser;
      if (knownUser) {
        saveButton.attr('value', 'Update')
      } else {
        saveButton.attr('value', 'Save')
      }
    }

    function roleFieldValid() {
      var instrumentRoleChecked = $('#user_role_instrumentsales').is(':checked');
      var serviceRoleChecked = $('#user_role_servicesales').is(':checked');

      if (instrumentRoleChecked || serviceRoleChecked) {
        return true;
      } else {
        return false;
      }
    }

    function countryFieldValid() {
      var countryInput = countryField.val();
      var countryFound = countries.find(function(country) {
        return country.name === countryInput;
      });

      if (countryFound) {
        return true
      } else {
        return false
      }
    }

    function runValidations() {
      if (roleFieldValid() && countryFieldValid()) {
        enableSubmitButton();
      }
    }


    instrumentRoleField.on('change', function() {
      if (countryFieldValid()) {
        runValidations();
      }
    })

    serviceRoleField.on('change', function() {
      if (countryFieldValid()) {
        runValidations();
      }
    })

    // dismiss modal after user submits form
    $('#user-prefs').on('submit', function() {
      $('#userPrefsModal').modal('toggle');
    });

    // This code is useful when user is fiddling with the modal
    // We default it to saying "Close" and teh button will be chagned to "Update"
    // if they change the value.
    $('#userPrefsModal').on('show.bs.modal', function (e) {
      $('#userPrefsModal').find(':submit').attr('value', 'Close');
    })
  });



});

