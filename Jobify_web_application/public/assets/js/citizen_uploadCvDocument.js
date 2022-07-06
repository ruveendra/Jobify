const uploadCVForm = document.getElementById('cv-document-upload-form');
const cvInput = document.getElementById('cv-input');
const certificateName = document.getElementById("cv-name");
const certificateStatus = document.getElementById("cv-status");






uploadCVForm.addEventListener('submit', function (e) {
  e.preventDefault();

  // representing formdata
  let formData = new FormData();
  // get the file  friom input
  let cvDocument = cvInput.files[0];

  formData.append('cv', cvDocument)
  console.log(cvDocument)


  $.ajax({
    type: "POST",
    url: "/citizen/nid/cv",
    contentType: "multipart/form-data",
    data: formData, //donot stringify the formdat
    contentType: false,
    processData: false,
    success: (data) => {
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
      certificateStatus.innerHTML = 'pending';
      certificateName.innerHTML = data.file;
      $('#message-alert').html(alertElement);
      $('#message-alert').show();
      cvInput.value = '';
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


// const updateForm = document.getElementById("update-cv-form");
// updateForm.addEventListener('submit', (e) => {
//   e.preventDefault();
//   $.ajax({
//     type: "PUT",
//     url: "/citizen/nid/cv",
//     contentType: "multipart/form-data",
//     data: formData, //donot stringify the formdat
//     contentType: false,
//     processData: false,
//     // success: (data) => {
//     //   console.log(data);
//     //   $('#message-alert').html('');
//     //   const alertElement =
//     //     ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
//     //             id="alert-role" >
//     //             <strong id="message-area">${data.msg}a></strong>
//     //             <button type="button" class="close" data-dismiss="alert" aria-label="Close">
//     //               <span aria-hidden="true">&times;</span>
//     //             </button>
//     //           </div>;
//     //          `;
//     //   $('#message-alert').html(alertElement);
//     //   $('#message-alert').show();
//     // },
//     // error: (xhr) => {
//     //   let data = xhr.responseJSON;
//     //   $('#message-alert').html('');
//     //   const alertElement =
//     //     ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
//     //             id="alert-role" >
//     //             <strong id="message-area">${xhr.status}:${data.msg}</strong>
//     //             <button type="button" class="close" data-dismiss="alert" aria-label="Close">
//     //               <span aria-hidden="true">&times;</span>
//     //             </button>
//     //           </div>;
//     //         `;
//     //   $('#message-alert').html(alertElement);
//     //   $('#message-alert').show();
//     // }

//   })

// })


const deleteCvForm = document.getElementById("remove-cv-form");
deleteCvForm.addEventListener('submit', (e) => {
  console.log("ajax");
  e.preventDefault();
  $.ajax({
    type: "DELETE",
    url: "/citizen/nid/cv",
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
      certificateName.innerHTML = '';
      certificateStatus.innerHTML = '';
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

