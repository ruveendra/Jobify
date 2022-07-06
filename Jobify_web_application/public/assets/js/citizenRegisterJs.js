const form = document.getElementById('citizen-registration-form');
const accTypeInput = document.getElementById('accType');
const nic = document.getElementById('nic');
const uDob = document.querySelector('input[type="date"]');
const userName = document.getElementById('userName');
const email = document.getElementById('email');
// const jobCategory = document.getElementById('jobCategory');
// affiliations areinserted below
const password = document.getElementById('password');
const cPassword = document.getElementById('cPassword');
const region = document.getElementById('region');
const latLoc = document.getElementById('lat');
const longLoc = document.getElementById('long');

// // alert 
const messageAlert = document.getElementById('message-alert')

let readyToSubmit = [];

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

// Check email is valid
function checkEmail(input) {
  const re = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()\.,;\s@\"]+\.{0,1})+([^<>()\.,;:\s@\"]{2,}|[\d\.]+))$/;
  if (re.test(input.value.trim())) {
    showSuccess(input);
    return true;
  } else {
    showError(input, 'Email is not valid');
    return false;
  }
}
// // Get fieldname
function getFieldName(input) {

  if (input.id == 'cPassword') {
    return "confirm password";
  } else if (input.id == 'userName') {
    return "User Name";
  } else if (input.id == 'nic') {
    return "National Identity Card";
  } else if (input.id == 'accType') {
    return "Account Type";
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

// Check passwords match
function checkPasswordsMatch(input1, input2) {
  if (input1.value !== input2.value) {
    showError(input2, 'Passwords do not match');
    return false;
  }
  return true;
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
form.addEventListener('submit', function (e) {
  e.preventDefault();

  // console.log(longLoc.textContent)
  // console.log(uDob.value)

  //use jquery to get the value  of select
  let regionName = $('#region').val();
  let accType = $('#accType').val();
  console.log("acc" + accTypeInput.value)

  console.log(regionName);



  let affilationArr = getAffilations();
  // console.log(affilationArr)



  let requiredStatus = checkRequired([userName, email, password, cPassword, nic, uDob, accTypeInput]);
  console.log("is all inputs are filled ?" + requiredStatus)
  if (requiredStatus) {
    if (checkLength(userName, 3, 15) && checkLength(password, 6, 25) && checkEmail(email) && checkPasswordsMatch(password, cPassword) && validateNIC(nic)) {
      console.log("Ready to submit")

      res = true;

    } else {
      console.log("error")
    }

    if (res) {
      //allow form submission
      $.ajax({
        type: "POST",
        url: "/citizen/register",
        contentType: "application/json",
        data: JSON.stringify({
          nic: nic.value,
          userRole: accType,
          birthday: uDob.value,
          userName: userName.value,
          email: email.value,
          affiliations: affilationArr,
          location: { region: regionName, long: longLoc.textContent, lat: latLoc.textContent },
          
          password: password.value,

        }),
        success: (data) => {
          // console.log(data);
          // window.location.assign('/citizen/dashboard/');
          // resetting
          $('#message-alert').html('');

          const alertElement =
            ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
              id="alert-role" >
              <strong id="message-area">${data.msg} click here to <a href="/citizen/login">login</a></strong>
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

