const form = document.getElementById('my-employement-form');
const deleteEmployeeForm = document.getElementById('delete-my-employement-form');

const currentEmployementRoleInput = document.getElementById('current-employee-role');
const currentEmployedInstitutionInput = document.getElementById('employed-institution');
const currentEmployementBuildingNoInput = document.getElementById('employed-building-no-location');
const currentEmployementStreetInput = document.getElementById('employed-street-location');
const currentEmployementRegionInput = document.getElementById('employed-region-location');
const currentEmployementCountryInput = document.getElementById('employed-country-location');

$(document).ready(() => {
  $('#message-alert').hide();

})

// Event listeners
form.addEventListener('submit', function (e) {
  e.preventDefault();

  //allow form submission
  $.ajax({
    type: "POST",
    url: "/citizen/myEmployement",
    contentType: "application/json",
    data: JSON.stringify({
      currentEmployementRole: currentEmployementRoleInput.value,
      currentEmployedInstitution: currentEmployedInstitutionInput.value,
      currentEmployementBuildingNo: currentEmployementBuildingNoInput.value,
      currentEmployementStreet: currentEmployementStreetInput.value,
      currentEmployementRegion: currentEmployementRegionInput.value,
      currentEmployementCountry: currentEmployementCountryInput.value
    }),
    success: (data) => {
      console.log(data)
    },
    error: (xhr) => {

      let data = xhr.responseJSON;

      $('#message-alert').html('');

      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
              id="alert-role" >
              <strong id="message-area">${xhr.status}:${data.msg}</strong>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>;
          `;
      $('#message-alert').html(alertElement);
      $('#message-alert').show();
      window.scrollTo({ top: 0, behavior: 'smooth' });

    }
    // statusCode: {
    //   401: function () {
    //     alert("page not found");
    //   }
    // }
    // do errror hadnling
  })





});

deleteEmployeeForm.addEventListener('submit', function (e) {
  e.preventDefault();
  //allow form submission
  $.ajax({
    type: "DELETE",
    url: "/citizen/myEmployement",
    contentType: "application/json",
    success: (data) => {
      $('#profile-display-card').html('');

    },
    error: (xhr) => {

      let data = xhr.responseJSON;

      $('#message-alert').html('');

      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
              id="alert-role" >
              <strong id="message-area">${xhr.status}:${data.msg}</strong>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>;
          `;
      $('#message-alert').html(alertElement);
      $('#message-alert').show();
      window.scrollTo({ top: 0, behavior: 'smooth' });

    }
    // statusCode: {
    //   401: function () {
    //     alert("page not found");
    //   }
    // }
    // do errror hadnling
  })





});