const uploadBirthDayForm = document.getElementById('birthday-document-upload-form');
const birthCertificateInput = document.getElementById('birthCertificate');
const birthCerificateName = document.getElementById("birthday-certificate-name");
const birthCerificateStatus = document.getElementById("birthday-certificate-status");





// uploading birthcertificate
uploadBirthDayForm.addEventListener('submit', (e) => {
  e.preventDefault();

  // representing formdata
  let formData = new FormData();
  // get the file  friom input
  let birthCertificate = birthCertificateInput.files[0];

  formData.append('birthCertificate', birthCertificate)

  $.ajax({
    type: "POST",
    url: "/citizen/nid/birthCertificate",
    contentType: "multipart/form-data",
    data: formData, //donot stringify the formdat
    contentType: false,
    processData: false,
    success: (data) => {
      console.log("suceess")
      console.log(data);
      $('#message-alert').html('');
      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                id="alert-role" >
                <strong id="message-area">${data.msg}</strong>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>;
             `;
      birthCerificateName.innerHTML = data.file;
      birthCerificateStatus.innerHTML = 'pending';
      birthCertificateInput.value = '';
      $('#message-alert').html(alertElement);
      $('#message-alert').show();
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
    }

  })
})



// delete certificate
const deleteBirthCertificateForm = document.getElementById("remove-birthcertificate-form");
deleteBirthCertificateForm.addEventListener('submit', (e) => {
  console.log("ajax delete birthday certificate");
  e.preventDefault();
  $.ajax({
    type: "DELETE",
    url: "/citizen/nid/birthCertificate",
    contentType: "multipart/form-data",
    contentType: false,
    processData: false,
    success: (data) => {
      console.log(data);
      $('#message-alert').html('');
      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                id="alert-role" >
                <strong id="message-area">${data.msg}</strong>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>;
             `;
      $('#message-alert').html(alertElement);
      $('#message-alert').show();
      birthCerificateName.innerHTML = '';
      birthCerificateStatus.innerHTML = '';

      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    error: (xhr) => {
      console.log('ERrror')
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
  })

})




