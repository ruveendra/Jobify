const qualificationForm = document.getElementById('qualification-submit-form');
// const removeQualificationForm = document.getElementById('remove-qualifications-form');
const highestQualificationType = document.getElementById("highest-qualification-type");
const highestQualificationName = document.getElementById("highest-qualification-name");
const awardingbodyInput = document.getElementById('awardingbody-input');
// const jobCategory = document.getElementById('jobCategory');





qualificationForm.addEventListener('submit', (e) => {
  e.preventDefault();

  $.ajax({
    type: "POST",
    url: "/citizen/dashboard/qualifications",
    contentType: "application/json",
    data: JSON.stringify({
      highestQualificationType: highestQualificationType.value,
      highestQualificationName: highestQualificationName.value,
      awardingbodyInput: awardingbodyInput.value,
      jobCategory: jobCategory.value,
    }),
    success: (data) => {
      $('#qualifications-message-alert').html('');
      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                  id="alert-role" >
                  <strong id="message-area">${data.msg}</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>;
               `;

      $('#qualifications-message-alert').html(alertElement);
      $('#qualifications-message-alert').show();

    },
    error: (xhr) => {
      let data = xhr.responseJSON;
      $('#qualifications-message-alert').html('');
      const alertElement =
        ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
                  id="alert-role" >
                  <strong id="message-area">${xhr.status}:${data.msg}</strong>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>;
              `;
      $('#qualifications-message-alert').html(alertElement);
      $('#qualifications-message-alert').show();
    }
  })

})






// removeQualificationForm.addEventListener('submit', (e) => {
//   e.preventDefault();
//   alert("check")
//   $.ajax({
//     type: "DELETE",
//     // url: "/citizen/dashboard/qualifications",
//     url: "/citizen/dashboard/qualifications",
//     contentType: "application/json",
//     success: (data) => {
//       $('#removed-qualifications-message-alert').html('');
//       const alertElement =
//         ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
//                   id="alert-role" >
//                   <strong id="message-area">${data.msg}</strong>
//                   <button type="button" class="close" data-dismiss="alert" aria-label="Close">
//                     <span aria-hidden="true">&times;</span>
//                   </button>
//                 </div>;
//                `;

//       $('#removed-qualifications-message-alert').html(alertElement);
//       $('#removed-qualifications-message-alert').show();

//     },
//     error: (xhr) => {
//       let data = xhr.responseJSON;
//       $('#removed-qualifications-message-alert').html('');
//       const alertElement =
//         ` <div class=" alert alert-${data.msgType} alert-dismissible fade show py-3 text-center" role="alert"
//                   id="alert-role" >
//                   <strong id="message-area">${xhr.status}:${data.msg}</strong>
//                   <button type="button" class="close" data-dismiss="alert" aria-label="Close">
//                     <span aria-hidden="true">&times;</span>
//                   </button>
//                 </div>;
//               `;
//       $('#removed-qualifications-message-alert').html(alertElement);
//       $('#removed-qualifications-message-alert').show();
//     }
//   })

// })