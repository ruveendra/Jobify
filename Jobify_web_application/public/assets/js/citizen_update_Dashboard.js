const updateQualificationForm = document.getElementById('update-qualification-submit-form');

const highestQualificationType = document.getElementById("highest-qualification-type");
const highestQualificationName = document.getElementById("highest-qualification-name");
const awardingbodyInput = document.getElementById('awardingbody-input');
// const jobCategory = document.getElementById('jobCategory');





updateQualificationForm.addEventListener('submit', (e) => {
  e.preventDefault();

  $.ajax({
    type: "PUT",
    url: "/citizen/dashboard/qualifications",
    contentType: "application/json",
    data: JSON.stringify({
      highestQualificationType: highestQualificationType.value,
      highestQualificationName: highestQualificationName.value,
      awardingbodyInput: awardingbodyInput.value,
      jobCategory: jobCategory.value,
    }),
      success: (data) => {
        $('#update-qualifications-message-alert').html('');
        const alertElement =
          ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                  id="alert-role" >
                  <strong id="message-area">${data.msg}</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>;
               `;
      
        $('#update-qualifications-message-alert').html(alertElement);
        $('#update-qualifications-message-alert').show();

      },
      error: (xhr) => {
        let data = xhr.responseJSON;
        $('#update-qualifications-message-alert').html('');
        const alertElement =
          ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                  id="alert-role" >
                  <strong id="message-area">${xhr.status}:${data.msg}</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>;
              `;
        $('#update-qualifications-message-alert').html(alertElement);
        $('#update-qualifications-message-alert').show();
      }
  })

})




const removeQualificationForm = document.getElementById('remove-qualification-form');

removeQualificationForm.addEventListener('submit', (e) => {
  e.preventDefault();

  $.ajax({
    type: "DELETE",
    url: "/citizen/dashboard/qualifications",
    contentType: "application/json",
    success: (data) => {
      $('#removed-qualifications-message-alert').html('');
      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                  id="alert-role" >
                  <strong id="message-area">${data.msg}</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>;
               `;

      $('#removed-qualifications-message-alert').html(alertElement);
      $('#removed-qualifications-message-alert').show();

    },
    error: (xhr) => {
      let data = xhr.responseJSON;
      $('#removed-qualifications-message-alert').html('');
      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                  id="alert-role" >
                  <strong id="message-area">${xhr.status}:${data.msg}</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>;
              `;
      $('#removed-qualifications-message-alert').html(alertElement);
      $('#removed-qualifications-message-alert').show();
    }
  })

})