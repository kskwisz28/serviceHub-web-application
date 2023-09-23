document.addEventListener("turbolinks:load", function() {

  configureClickHandlers();

  function configureClickHandlers() {
    configureSubmitButtonClickHandler();
    configureServiceHistoryClickHandlers();
  }

  function configureSubmitButtonClickHandler() {
    $("[data-submit-btn]").click(function (event) {
      event.preventDefault();

      reset();

      var serialNumber = $('[data-query]').val().trim();

      retrieveResults(serialNumber);
    });
  }

  // Reset allows for multiple queries in the same session
  function reset() {
    $(".box").hide();
    $("[data-bad-result-header]").hide();
    $("[data-bad-result-subheader]").hide();
    $("[data-bad-result-disclaimer]").hide();
    $("[data-service-contract-history]").hide();
    $("[data-hide-details]").hide();
    $("[data-show-details]").show();
    $("[data-title]").text('');
    $("[data-serial-number]").text('');
    $("[data-status-icon]").removeClass("unqualified");
    $("[data-status-icon]").removeClass("qualified");
    $("[data-expiration]").text('');
    $("[data-table-body]").empty();
  }

  // Submitting Query //
  function retrieveResults(serialNumber) {
    var endpoint = "https://api.gss.tf/easiertomanage/";
    var url = endpoint + serialNumber;

    // Show loading spinner
    $("[data-loading-area]").css('display', 'flex');

    $.ajax({
      type: "GET",
      dataType: "json",
      url: url,
      success: function (result) {
        $("[data-loading-area]").hide();

        if (result && result.length > 0) {
          populateQueryResults(result);
          $("[data-result]").show();
        } else {
          displayNullResultErrorMessage();
        }
      },
      error: function (err) {

        $("[data-loading-area]").hide();

        var responseText = JSON.parse(err.responseText);
        var statusCode = responseText.statusCode;

        if (statusCode === 429) {
          var errorMessage = responseText.message;
          displayateLimitErrorMessage(errorMessage);
        } else {
          displayGeneralErrorMessage();
        }
        console.log(err);
      },
    });
  }

  function displayNullResultErrorMessage() {
    $("[data-bad-result-header]").text("We are sorry but your search produced 0 results.");
    $("[data-bad-result-subheader]").text("Please check back.  We’re constantly adding new instruments to the database.");
    $("[data-bad-result-disclaimer]").text("NOTE: This system is for Applied Biosystems, Invitrogen, and Ion Torrent instruments only.");

    $("[data-bad-result-header]").show();
    $("[data-bad-result-subheader]").show();
    $("[data-bad-result-disclaimer]").show();
    $("[data-bad-result]").show();
  }

  function displayateLimitErrorMessage(errorMessage) {
    $("[data-bad-result-header]").text(errorMessage);
    $("[data-bad-result-subheader]").text("Please check back.  We’re constantly adding new instruments to the database.");
    $("[data-bad-result-disclaimer]").text("NOTE: This system is for Applied Biosystems, Invitrogen, and Ion Torrent instruments only.");

    $("[data-bad-result-header]").show();
    $("[data-bad-result]").show();
  }

  function displayGeneralErrorMessage() {
    $(".bad-result-header").text("We could not find your serial number.")
    $("[data-bad-result-subheader]").text("Please verify it's for the correct instrument type and try again.");

    $(".bad-result-header").show();
    $("[data-bad-result-subheader]").show();
    $("[data-bad-result]").show();
  }

  // Populating Results //
  function populateQueryResults(payload) {

    // Contract #s are sequential, so ordering by contract # is same as ordering by date
    orderedPayloadData = payload.sort(function (a, b) {
      return a.SVC_CONTRACT_NBR < b.SVC_CONTRACT_NBR ? 1 : -1;
    });

    var latestInstrument = orderedPayloadData[0];
    var modelNumber = latestInstrument.MODEL_NBR;

    // All elements in payload will have same serial number.
    var serialNumber = latestInstrument.SERIAL_NBR;

    var warrantyInfo = generateWarrantyInfo(orderedPayloadData);
    var status = warrantyInfo[0];
    var statusStr = warrantyInfo[1];
    populateTitle(modelNumber);
    setImageSource(modelNumber);
    $("[data-serial-number]").text(serialNumber);
    $("[data-serial-number]").attr("value", serialNumber);
    $("[data-status-icon]").addClass(status);
    $("[data-expiration]").text(statusStr);
    var contracts = generateServiceContractHistory(payload);
    $("[data-table-body]").append(contracts)

    if (status === "unqualified") {
      $("[data-form-header]").css("display", "none");
      $("[data-leads-pass-form]").css("display", "none");
    } else if (status === "qualified") {
      $("[data-form-header]").css("display", "");
      $("[data-leads-pass-form]").css("display", "");
    } else {
      $("[data-form-header]").css("display", "");
      $("[data-leads-pass-form]").css("display", "");
    }
  }

  function populateTitle(modelNumber) {
    if (modelNumber) {
      // Using `async: false` to ensure this is a blocking call so we can
      // grab title from JSON immediately
      $.ajax({
        url: 'leads_pass/models',
        dataType: 'json',
        async: false,
        success: function(data) {
          if (data[modelNumber]) {
            title = data[modelNumber]["name"];
            $("[data-title]").text(title);
            $("[data-reference-instrument]").attr("value", title);
          }
        }
      });
    }
  }

  function setImageSource(modelNumber) {
    var placeholderImage = 'leads_pass/placeholder';
    if (modelNumber) {
      var imageURL = 'leads_pass/instrument_image';
      var imageSrc = 'https://gsss-servicehub-staging.azurewebsites.net/leads_pass/instrument_image?model='

      $.ajax({
        url: imageURL,
        data: "model=" + modelNumber,
        type: "GET",
        async: false,
        success: function () {
          displayImage( imageSrc + modelNumber);
        },
        error: function () {
          // file doesn't exist, so use placeholder image
          displayImage(placeholderImage);
        }
      });
    } else {
      displayImage(placeholderImage);
    }
  }

  function displayImage(imageURL) {
    $("[data-image]").attr("src", imageURL);
    $("[data-image]").css("display", "inline");
  }

  function generateServiceContractHistory(rawContracts) {
    var contracts = [];

    rawContracts.forEach(function (contractData) {
      name = contractData.CONTRACT_NM || "Unknown";
      contractType = parseContractType(contractData.CONTRACT_TYPE_NM);
      num = contractData.SVC_CONTRACT_NBR|| "Unknown";
      startDate = formatDate(contractData.CONTRACT_START_DT);
      endDate = formatDate(contractData.CONTRACT_END_DT);

      var tr = "<tr> \
      <td>" + name + "</td> \
      <td>" + contractType + "</td> \
      <td>" + num + "</td> \
      <td>" + startDate + "</td> \
      <td>" + endDate + "</td> \
      </tr>";

      contracts += tr;
    });

    return contracts;
  }

  function generateWarrantyInfo(orderedInstruments) {
    var expirationDate = findExpirationDate(orderedInstruments);

    if (isAfterToday(expirationDate)) {
      var formattedDate = formatDate(expirationDate);
      var daysRemaining = daysUntilExpiration(formattedDate);

      if (daysRemaining >= 30) {
        var status = "unqualified";
        var msg = daysRemaining + " days remaining" + " | " + "Does not qualify for the CLP program";
      } else {
        var status = "qualified";
        var msg = daysRemaining + " days remaining" + " | " + "This instrument qualifies for the CLP program!";
      }
    } else {
      var status = "qualified";
      var msg = "Expired on " + formatDate(expirationDate) + " | " + "This instrument qualifies for the CLP program!";
    }

    return [status, msg];
  }

  // Retrieve the most recent expiration date, skipping certain instruments
  function findExpirationDate(payload) {
    candidateInstruments = $(payload).filter(function(index) {
      return this.CONTRACT_END_DT !== undefined;
    })

    return candidateInstruments[0].CONTRACT_END_DT;
  }

  function isAfterToday(date) {
    return new Date(date).valueOf() > new Date().valueOf();
  }

  function daysUntilExpiration(expirationDate) {
    var oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    var today = new Date();
    var expDate = new Date(expirationDate);

    return Math.round(Math.abs((expDate - today) / oneDay));
  }

  function formatDate(unformattedDate) {
    var formattedDate;
    if (unformattedDate) {
      var parsedExpirationDate = unformattedDate.split('T')[0];
      dateParts = parsedExpirationDate.split("-");
      formattedDate = parseInt(dateParts[1]) + "/" + parseInt(dateParts[2]) + "/" + dateParts[0];
    } else {
      formattedDate = "Unknown";
    }
    return formattedDate;
  }

  function parseContractType(rawContractType) {
    var contractType;
    if (rawContractType.match(/serv/gi)) {
      contractType = "Service"
    } else if (rawContractType.match(/warranty/gi)) {
      contractType = "Warranty"
    } else {
      contractType = "Unknown";
    }
    return contractType;
  }

  // Service Contract History: show/hide
  function configureServiceHistoryClickHandlers() {
    $("[data-show-details]").click(function () {
      $("[data-show-details]").hide();
      $("[data-hide-details]").show();
      $("[data-service-contract-history]").slideToggle();
    });

    $("[data-hide-details]").click(function () {
      $("[data-hide-details]").hide();
      $("[data-show-details]").show();
      $("[data-service-contract-history]").slideToggle();
    });
  }

})