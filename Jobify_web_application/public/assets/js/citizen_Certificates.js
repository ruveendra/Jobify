const uploadCertificateForm = document.getElementById('certificate-upload-form');
const certificateInput = document.getElementById('certificates[]');
const certificatesUl = document.getElementById('certificates-ul');
const certificatesStatus = document.getElementById('certificates-status');
const certficatesList = document.getElementById("certificates-list");


uploadCertificateForm.addEventListener('submit', (e) => {
  e.preventDefault();
  // representing formdata
  let formData = new FormData();
  let certificates = [];
  // let arr = [];
  const fileList = certificateInput.files;

  for (let i = 0; i < fileList.length; i++) {
    console.log("inside loop");
    // certificates.push(fileList[i]);
    formData.append('certificates', fileList[i]);
  }

  $.ajax({
    type: "POST",
    url: "/citizen/nid/certificates",
    contentType: "multipart/form-data",
    data: formData, //donot stringify the formdat
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
      // displaying files
      let dataArr = data.file;
      console.log(dataArr);
      if (dataArr) {
        console.log("display")
        for (let i = 0; i < dataArr.length; i++) {
          console.log(dataArr[i])
          const li = document.createElement('li');
          li.innerHTML = dataArr[i];
          certificatesUl.append(li);
        }
        console.log(certificatesUl)
        certficatesList.append(certificatesUl);
        certificatesStatus.innerHTML = 'pending'
      }

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

// delete certificates

const deleteCertificatesForm = document.getElementById("remove-certificates-form");

function removeCertificates() {
  for (let i = 0; i < certificatesUl.children.length; i++) {
    let liChild = certificatesUl.children[i];
    certificatesUl.remove(liChild)
  }
}

deleteCertificatesForm.addEventListener('submit', (e) => {

  e.preventDefault();
  $.ajax({
    type: "DELETE",
    url: "/citizen/nid/certificates",
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
      window.scrollTo({ top: 0, behavior: 'smooth' });

      // remove list items
      certificatesStatus.innerHTML = ''
      removeCertificates();

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


