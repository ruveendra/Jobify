
const loginForm = document.getElementById('login-form');
const email = document.getElementById('email');
const password = document.getElementById('password');

// // alert 
const messageAlert = document.getElementById('message-alert');


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

// Check required fields
function checkRequired(inputArr) {
  let arrResult = true;
  inputArr.forEach((input) => {
    if (input.value.trim() === '') {
      showError(input, `${input.id} is required`);
      arrResult = false;
    } else {
      showSuccess(input);
    }
  });
  return arrResult;
}

// Check input length
function checkLength(input, min, max) {
  if (input.value.length < min) {
    showError(
      input,
      `${input.id} must be at least ${min}  characters`
    );
    return false;
  } else if (input.value.length > max) {

    showError(
      input,
      `${input.id} must be less than ${max} characters`
    );
    return false;
  } else {

    showSuccess(input);
    return true;
  }
}

$(document).ready(() => {
  $('#message-alert').hide();
});



// Event listeners
loginForm.addEventListener('submit', (e) => {
  e.preventDefault();
  let requiredStatus = checkRequired([email, password]);
  console.log("is all inputs are filled ?" + requiredStatus)

  if (requiredStatus) {
    if (checkLength(password, 6, 25) && checkEmail(email)) {
      // allow to submit
      $.ajax({
        type: "POST",
        url: "/citizen/login",
        contentType: "application/json",
        data: JSON.stringify({
          email: email.value,
          password: password.value,
        }),
        success: (data) => {
          let url;
          if (data.userRole == 'citizen_role') {
            url = '/citizen/dashboard'
          }
          else if (data.userRole == 'company_role') {
            url = '/company'
          }else if (data.userRole == 'bureau_role'){
            url ='/bureau'
          }else {
            url = ''
          }
          console.log(data);
          console.log("url  value is " + url);
          url != '' ? window.location.assign(url) : alert("Invalid Login");
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
           </div>
          `;
          $('#message-alert').html(alertElement);
          $('#message-alert').show();
        }
      })
    }
  }

})


