// const { JsonWebTokenError } = require("jsonwebtoken");


const citizenImageUploadForm = document.getElementById('profile-imgUpload-form');

const bioDescriptionInput = document.getElementById('bio-description-input');
const bioEmployeeInput = document.getElementById('bio-employee-status');
const bioEmployeeLocationInput = document.getElementById('bio-employee-location');
const avatarInput = document.getElementById('avatar');

const profileDisplayCard = document.getElementById('profile-display-card');


// // alert 
// const messageAlert = document.getElementById('message-alert')




// Event listeners
citizenImageUploadForm.addEventListener('submit', function (e) {
  e.preventDefault();

  // const div = document.createElement('div');

  // const div = document.createElement('div');
  // div.classList.addClass("card-body", "p-5")

  let bioDescription = bioDescriptionInput.value;
  let bioEmployee = bioEmployeeInput.value;
  let bioEmployeeLocation = bioEmployeeLocationInput.value;

  // // representing formdata
  let formData = new FormData();
  formData.append('avatar', avatarInput.files[0]);
  formData.append('bioDescription', bioDescription);
  formData.append('bioEmployee', bioEmployee);
  formData.append('bioEmployeeLocation', bioEmployeeLocation);



  $.ajax({
    type: "POST",
    // url: "/citizen/myProfile/profileImage",
    url: "/citizen/myProfile/profileImage",
    contentType: "application/json",
    data: formData,
    processData: false,
    contentType: false,
    success: (data) => {

      const displayCard =
        ` 
        <div class="container">
          <h2 class="text-uppercase text-center mb-5">My bio</h2>
          <div class="row">
            <div class="col-md-4 col-sm-6">
              <img src="/uploads/${data.bio.fileName}"
                id="profile-img" alt="Generic placeholder image" class="img-fluid"
                style="width: 180px; border-radius: 10px;">
            </div>
            <div class="col-md-8 col-sm-6">
              <div class="form-outline mb-4">

                <p id="bio-display">
                ${data.bio.description}
                
               <h5>current Employeement</h5> : ${data.bio.career}
               <h5>current Employeement location</h5> :${data.bio.employeeLocation}
                </p>

              </div>
            </div>
          </div>
        </div>;
      `
        ;
      $('#profile-display-card').html(displayCard);

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
      // window.scrollTo({ top: 0, behavior: 'smooth' });

    }

  })

});

