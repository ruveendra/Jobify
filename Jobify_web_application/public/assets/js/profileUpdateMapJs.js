
let latitude;
let longitude;
// declaring  as global variable so the myservice ajax .js can access it 

const lat_P = document.getElementById('lat');
const long_P = document.getElementById('long');


var options = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 0
};



function mapIt(latitude, longitude) {

  let marker;
  var map = L.map('map').setView([latitude, longitude], 17);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

  marker = new L.marker([latitude, longitude], { draggable: 'true' })


  marker.addTo(map)
    .bindPopup('your saved location.')
    .openPopup();

  marker.on('dragend', function (event) {

   
    var latlng = event.target.getLatLng();
    // console.log(latlng)
    latitude = latlng.lat;
    longitude = latlng.lng;
    // x.innerHTML = "Latitude: " + latitude + "<br>Longitude: " + longitude;
    // $("#lat").innerHTML = latlng.lat;
    // $("#long").innerHTML = latlng.lat;
    lat_P.innerHTML = latitude;
    long_P.innerHTML = longitude;
  });


}



function showError(error) {
  switch (error.code) {
    case error.PERMISSION_DENIED:
      x.innerHTML = "User denied the request for Geolocation."
      break;
    case error.POSITION_UNAVAILABLE:
      x.innerHTML = "Location information is unavailable."
      break;
    case error.TIMEOUT:
      x.innerHTML = "The request to get user location timed out."
      break;
    case error.UNKNOWN_ERROR:
      x.innerHTML = "An unknown error occurred."
      break;
  }
}




function getLocation() {
 
    if (navigator.geolocation) {
    
      // navigator.geolocation.getCurrentPosition(success, error, options);
    navigator.geolocation.getCurrentPosition((position) => {
      if (LatLocationFromDb && LongLocationFromDb) {

        lat_P.innerHTML = LatLocationFromDb;
        long_P.innerHTML = LongLocationFromDb;

        mapIt(LatLocationFromDb, LongLocationFromDb);
     
        }else{
          latitude = position.coords.latitude;
          longitude = position.coords.longitude;
          // }
          // initial location values  //important
          lat_P.innerHTML = latitude;
          long_P.innerHTML = longitude;
          
          mapIt(latitude, longitude);
        }
        }, showError, options);
      
      } else {
        map.innerHTML = "Geolocation is not supported by this browser.";
      }
  
}

// function getLocation() {
//   if (LatLocationFromDb && LongLocationFromDb) {

//     lat_P.innerHTML = LatLocationFromDb;
//     long_P.innerHTML = LongLocationFromDb;

//     mapIt(LatLocationFromDb, LongLocationFromDb);
    
//   }else{
//     if (navigator.geolocation) {
    
//       // navigator.geolocation.getCurrentPosition(success, error, options);
//     navigator.geolocation.getCurrentPosition((position) => {
//       // if (locationLat && locationLong) {
//         //   latitude =locationLat;
//         //   longitude= locationLong;
//         // }else{
//           latitude = position.coords.latitude;
//           longitude = position.coords.longitude;
//           // }
//           // initial location values  //important
//           lat_P.innerHTML = latitude;
//           long_P.innerHTML = longitude;
          
//           mapIt(latitude, longitude);
//         }, showError, options);
        
//       } else {
//         map.innerHTML = "Geolocation is not supported by this browser.";
//       }
//   }
// }


// function showPosition(position) {

//   latitude = position.coords.latitude;
//   longitude = position.coords.longitude;
//   x.innerHTML = "Latitude: " + latitude + "<br>Longitude: " + longitude;

//    Mapit(latitude, longitude);
// }















