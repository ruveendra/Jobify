const jwt = require('jsonwebtoken');

const Citizen = require('../model/Citizen')


const checkAuthunetication = (req, res, next) => {
  const token = req.cookies.jwt;

  // check token exists and verified
  if (typeof (token) !== 'undefined') {
    console.log("token is avaialble")
    jwt.verify(token, 'net ninja secret', (err, decodedToken) => {
      if (err) {
        // token is invalid /expired
        console.log(err.message);
        res.redirect('/citizen/login');
      } else {
        // allows if token verified
        next();
      }
    })
  } else {
    console.log("token is unavialable")
    // if token is not avaialbe redirect user to login and obtin the token
    res.redirect('/citizen/login');
  }
}


// provide users information wen logged in

const verfiedUserInfo = (req, res, next) => {

  const token = req.cookies.jwt;
  if (token) {
    jwt.verify(token, 'net ninja secret', async (err, decodedToken) => {
      if (err) {
        console.log(err.message);
        res.locals.user = null;
        next();
      } else {
        console.log('decodedToken')
        let currentLoggedUser = await Citizen.getCitizenDetailsById(decodedToken.id)
        // console.log(currentLoggedUser[0])
        //saving user details
        res.locals.user = currentLoggedUser[0];
        // console.log(res.locals)
        next();
      }
    })
  } else {
    //   //user not logged in
    res.locals.user = null;
    next();

  }
}



module.exports = { checkAuthunetication, verfiedUserInfo };