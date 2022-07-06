const pool = require('../config/db-config');
const uuid = require('uuid');

class Citizen {

  static registerCitizen(email, userName, password, userRole) {
    let userId = uuid.v4();
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("INSERT INTO user_tb (userId,email,userName,password,userRole) VALUES (?,?,?,?,?)", [userId, email, userName, password, userRole], (err, rows) => {
          // return connection to tthe pool
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  // get user detials by email
  static getCitizenDetailsByMail(email) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM user_tb WHERE email = ?", [email], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  // get user detials from id 
  static getCitizenDetailsById(id) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM user_tb WHERE userId = ?", id, (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }
  // update userName  from id 
  static updateUserNameById(userName, id) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(" UPDATE  user_tb SET userName = ?   WHERE userId = ?", [userName, id], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }


  // get cv details 
  static addCVDetails(input) {
    console.log(input)
    // converting affiliation array to json
    let affiliationsJson = JSON.stringify(Object.assign({}, input.affiliations));
    let locationjson = JSON.stringify(Object.assign({}, input.location));
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("INSERT INTO cvdetails_tb(userId,nic, birthday, affiliations, location) VALUES(?,?,?,?,?)", [input.userId, input.nic, input.birthday, affiliationsJson, locationjson], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  // gct  all the citizen details-
  static viewCitizenDetails() {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM cvdetails_tb", (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });

  }
  // gct  all the citizen details-
  static viewCitizenDetailsById(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM cvdetails_tb WHERE userId = ?", userId, (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });

  }
  static updateCVDetailsById(input, userId) {
    console.log(input)
    let affiliationsJson = JSON.stringify(Object.assign({}, input.affiliations));
    let locationjson = JSON.stringify(Object.assign({}, input.location));
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("UPDATE cvdetails_tb SET nic = ? ,birthday = ? ,affiliations = ?, location = ?  WHERE userId = ?", [input.nic, input.birthday, affiliationsJson, locationjson, userId,], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });

  }

  // add Bio
  static postBioDescription(userId, fileName, bio, bioEmployement, bioEmployeeLocation) {
    return new Promise((resolve, reject) => {
      console.log("postin")
      console.log(userId, fileName, bio, bioEmployement, bioEmployeeLocation)
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("INSERT INTO profile_tb(userId,profileImg,profileBio,bioEmployement,bioEmployeeLocation) VALUES (?,?,?,?,?)", [userId, fileName, bio, bioEmployement, bioEmployeeLocation], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  // delete bio
  static deleteBioDescription(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("DELETE FROM  profile_tb WHERE userId = ?", [userId], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  // view bio
  static viewBioDescription(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM  profile_tb WHERE userId = ?", userId, (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }


// view EmploymentDetails

  static viewCitizenEmploymentDetails(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM citizen_employment_tb WHERE userId = ? ", [userId], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }


  static postCitizenEmploymentDetails(userId, currentEmployementRole, currentEmployedInstitution, currentEmployementBuildingNo, currentEmployementStreet, currentEmployementRegion, currentEmployementCountry) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("INSERT INTO citizen_employment_tb(userId,currentEmployementRole, currentEmployedInstitution, currentEmployementBuildingNo, currentEmployementStreet,currentEmployementRegion, currentEmployementCountry) VALUES (?,?,?,?,?,?,?)", [userId, currentEmployementRole, currentEmployedInstitution, currentEmployementBuildingNo, currentEmployementStreet, currentEmployementRegion, currentEmployementCountry], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  // delete employement by id
  static deleteMyEmploymentDescriptionById(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("DELETE FROM  citizen_employment_tb WHERE userId = ?", [userId], (err, rows) => {
          connection.release();
          if (!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }




}









module.exports = Citizen;