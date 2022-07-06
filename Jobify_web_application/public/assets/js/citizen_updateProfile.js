const citizenUpdateForm = document.getElementById('citizen-profile-update-form');

const nic = document.getElementById('nic');
const uDob = document.querySelector('input[type="date"]');
const userName = document.getElementById('userName');
const region = document.getElementById('region');
const latLoc = document.getElementById('lat');
const longLoc = document.getElementById('long');

// // alert 
const messageAlert = document.getElementById('message-alert')


// Show input error message
function showError(input, message) {
  input.classList.add('is-invalid');
  let x = input.parentNode.querySelector('.invalid-feedback')
  x.innerHTML = message;
}

// Show success outline
function showSuccess(input) {
  input.classList.add('is-valid')
}


// // Get fieldname
function getFieldName(input) {

  if (input.id == 'userName') {
    return "User Name";
  } else if (input.id == 'nic') {
    return "National Identity Card";
  } else if (input.id == 'uDOB') {
    return "birthday";
  }
  else {
    return input.id
  }

}

// // Check required fields
function checkRequired(inputArr) {
  let arrResult = true
  inputArr.forEach(function (input) {
    if (input.value.trim() === '') {
      showError(input, `${getFieldName(input)} is required`);
      arrResult = false;
    } else {
      showSuccess(input);
    }
  });
  return arrResult;

}

// // Check input length
function checkLength(input, min, max) {
  if (input.value.length < min) {
    // readyToSubmit.push(false);
    showError(
      input,
      `${getFieldName(input)} must be at least ${min} characters`
    );
    return false;
  } else if (input.value.length > max) {
    // readyToSubmit.push(false);
    showError(
      input,
      `${getFieldName(input)} must be less than ${max} characters`
    );
    return false;
  } else {
    // readyToSubmit.push(true);
    showSuccess(input);
    return true;
  }
}




$(document).ready(() => {
  $('#message-alert').hide();
  getLocation();
})



// affiliations
$("#addRow").click(() => {
  var html = '';
  html += '<div id="inputFormRow">';
  html += '<div class="input-group mb-3">';
  html += '<input type="text" name="affiliation-input" class="form-control form-control-lg border border-secondary affiliation-input" placeholder="Enter your Affiliation" autocomplete="off">';
  html += '<div class="input-group-append">';
  html += '<button id="removeRow" type="button" class="btn btn-danger"> X </button>';
  html += '</div>';
  html += '</div>';

  $('#newRow').append(html);
});

// remove row

$(document).on('click', '#removeRow', (e) => {
  e.target.parentNode.parentNode.remove();
});


function getAffilations() {
  const affiliationInputs = document.querySelectorAll('.affiliation-input');
  let affilationArr = [];
  // skills
  affiliationInputs.forEach((input) => {
    if (input.value.trim() !== "") {
      affilationArr.push(input.value);
    }
  })
  return affilationArr;
}


function validateNIC(input) {
  const re = /^([0-9+]{9}[v|V]|[0-9+]{12})$/;
  if (re.test(input.value.trim())) {
    showSuccess(input);
    return true;
  } else {
    showError(input, 'NIC is not valid');
    return false;
  }
}




// affiliations

// Event listeners
citizenUpdateForm.addEventListener('submit', function (e) {
  e.preventDefault();

  //use jquery to get the value  of select
  let regionName = $('#region').val();
  console.log(regionName);



  let affilationArr = getAffilations();
  // console.log(affilationArr)



  let requiredStatus = checkRequired([userName, nic, uDob]);
  console.log("is all inputs are filled in update profile ?" + requiredStatus)
  if (requiredStatus) {
    if (checkLength(userName, 3, 15) && validateNIC(nic)) {
      console.log("Ready to submit")

      res = true;

    } else {
      console.log("error")
    }

    if (res) {
      console.log("chedk")
      //allow form submission
      $.ajax({
        type: "PUT",
        url: "/citizen/myProfile",
        contentType: "application/json",
        data: JSON.stringify({
          nic: nic.value.trim(),
          birthday: uDob.value,
          userName: userName.value.trim(),
          affiliations: affilationArr,
          location: { region: regionName, long: longLoc.textContent, lat: latLoc.textContent },

        }),
        success: (data) => {
          // console.log(data);
          // window.location.assign('/citizen/dashboard/');
          // resetting
          $('#message-alert').html('');

          const alertElement =
            ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
              id="alert-role" >
              <strong id="message-area">${data.msg} </strong>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>;
           `;
          $('#message-alert').html(alertElement);
          $('#message-alert').show();
          window.scrollTo({ top: 0, behavior: 'smooth' });


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

    }
  }


});

