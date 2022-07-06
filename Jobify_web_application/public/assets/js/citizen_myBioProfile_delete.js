const form = document.getElementById('remove-myBio-form');

$(document).ready(() => {
  $('#message-alert').hide();
  getLocation();
})






// affiliations

// Event listeners
form.addEventListener('submit', function (e) {
  e.preventDefault();



  //allow form submission
  $.ajax({
    type: "DELETE",
    url: "/citizen/dashboard/myBio",
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

