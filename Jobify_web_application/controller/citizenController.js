const Citizen = require('../model/Citizen');
const Image = require('../model/Image');
const Document = require('../model/Document');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');


//encrypt password
const encryptPassword = async (password) => {
  const salt = await bcrypt.genSalt();
  const encrptedPassword = await bcrypt.hash(password, salt);
  return encrptedPassword;
}

const maxAge = 1000 * 24 * 60 * 60; //millsieconds
const createToken = (id) => {
  return jwt.sign({ id }, 'net ninja secret', {
    expiresIn: maxAge
  });
};





// Registration
exports.getRegister = (req, res) => {
  res.render('register')
};

exports.postRegister = async (req, res) => {
  console.log("Registration citizen called")
  console.log(req.body);
  try {
    const { nic, userRole, birthday, userName, email, affiliations, location, password } = req.body;
    let emailRegisteredResults = await Citizen.getCitizenDetailsByMail(email);
    //   check  email is not  registered
    if (emailRegisteredResults.length === 0) {
      // encrypting password
      let encrptedPassword = await encryptPassword(password);
      console.log('encrptedPassword' + encrptedPassword)

      let result = await Citizen.registerCitizen(email, userName, encrptedPassword, userRole);
      //         //sucessful registration 
      if (result.affectedRows > 0) {
        let registeredUser = await Citizen.getCitizenDetailsByMail(email);

        // // creating JWT
        let token = createToken(registeredUser[0].userId);

        // storing cv details on
        let cvEntry = { userId: registeredUser[0].userId, nic, birthday, affiliations, location }

        let cvRecord = await Citizen.addCVDetails(cvEntry)
        console.log('cvRecord')
        console.log(cvRecord)


        console.log(token);
        // storing JWT inside a cookie
        res.cookie('jwt', token, { maxAge: maxAge * 1000, httpOnly: true });
        //   //sucessfully created
        // res.status(201).json({ token:token});
        res.status(201).send({ msgType: "success", msg: `Congratulations! your account has been successfully created. Please Login `, token: token, cvEntry: cvEntry });

      } else {
        // registration failed
        res.status(401).json({ msgType: "danger", msg: `user  with email ${email} registration failed` })
      }
    } else {
      //     console.log('user already in the dblist ');
      res.status(401).json({ msgType: "danger", msg: `user with  ${email} is already exsits.Try another mail.` })
    }
  } catch (e) {
    console.log(e);
  }
  // res.render('register-houseowner');
}




// login
exports.getLogin = (req, res) => {
  res.render('login')
};

exports.postLogin = async (req, res) => {

  try {
    console.log("login")
    const { email, password } = req.body;
    let userRegisteredResults = await Citizen.getCitizenDetailsByMail(email);
    console.log(userRegisteredResults)
    // check user exists
    if (userRegisteredResults.length > 0) {
      const isValidPassword = await bcrypt.compare(password, userRegisteredResults[0].password)
      if (isValidPassword) {
        //  creating json web tokens
        let token = createToken(userRegisteredResults[0].userId);
        // storing JWT inside a cookie
        res.cookie('jwt', token, { maxAge: maxAge, httpOnly: true });

        res.status(201).send({
          msgType: "success", msg: `Congratulations! your account has been successfully Logged `, token: token, userRole: userRegisteredResults[0].userRole
        });
        // res.render('citizen/citizen-dashboard');

      } else {
        // if passwords donot match
        res.status(401).send({ msgType: "danger", msg: `please enter correct password` });
      }
    } else {

      res.status(401).send({ msgType: "danger", msg: `${email} is not registered. Please Register` });
    }

  } catch (e) {
    console.log(e);
  }
};

function getvalue(ele) {
  if (ele[0] === undefined || ele === []) {
    console.log("undefined")
    return '';
  } else {
    console.log(" not undefined")
    return ele[0];
  }

}



// dashboard
exports.getDashboard = async (req, res) => {
  try {
    let user = res.locals.user;
    let cvResult = await Document.getDocumentById(user.userId, 'cvDocument');
    let birthdayCertificateResult = await Document.getDocumentById(user.userId, 'birthCertificate');
    let certificatesResult = await Document.getDocumentById(user.userId, 'certificates');
    let qualifications = await Document.getCitizenQualifications(user.userId)
    console.log(qualifications)

    let certificates = getvalue(certificatesResult);
    if (certificates !== '') {
      let certificateDocs = Object.values(certificates.certificates);
      let certificateStatus = certificates.certificatesStatus;
      certificates = {
        certificateDocs, certificateStatus
      }
    }

    console.log(getvalue(cvResult));
    console.log(getvalue(birthdayCertificateResult));

    let display = {
      cv: getvalue(cvResult),
      birthcertificate: getvalue(birthdayCertificateResult),
      certificates: certificates
    }

    console.log(display);

    res.render('citizen/citizen-dashboard', { data: display, qualifications: qualifications[0] });
  } catch (err) {
    console.log(err)
  }

};

// get bio
exports.getBio = async (req, res) => {
  try {

    let user = res.locals.user;
    // console.log(user.userId);
    const results = await Citizen.viewBioDescription(user.userId);
    console.log("view Bio description")
    console.log(results)
    res.render('citizen/citizen_bio', { myBio: results[0] });

  }
  catch (err) {
    console.log(err);
  }
};

// upload cv
exports.postCvDocument = async (req, res) => {
  console.log("Posting  CV")

  try {
    let user = res.locals.user;

    let fileName = req.file.filename;

    let result = await Document.uploadDocument(user.userId, fileName, 'cvDocument')
    console.log(result)
    if (result.affectedRows > 0) {
      console.log("submiited");
      res.status(201).send({ msgType: "success", msg: `Congratulations! your  CV ${req.file.originalfilename} has successfully uploaded `, file: req.file.filename });
    } else {
      console.log(" not submiited");
      // not acceptable 
      res.status(406).send({ msgType: "danger", msg: `CV UPLOAD FAIL : your ${req.file.originalfilename} is not uploaded.`, file: req.file });
    }
  } catch (err) {
    console.log(err);
    if (err.code === 'ER_DUP_ENTRY') {
      // duplicate entry handled by 304 :not modified status code
      res.status(406).send({ msgType: "danger", msg: `CV UPLOAD FAIL : ERROR CV is already uploaded`, file: req.file });

    } else {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `CV UPLOAD FAIL :ERROR ${err.message}`, file: req.file });
    }
  }

}

// updatecv
exports.putCvDocument = async (req, res) => {
  console.log("update  CV")

  try {
    let user = res.locals.user;

    let fileName = req.file.filename;

    let result = await Document.uploadDocument(user.userId, fileName, 'cvDocument')
    console.log(result)
    if (result.affectedRows > 0) {
      console.log("submiited");
      res.status(201).send({ msgType: "success", msg: `Congratulations! your CV has successfully uploaded `, file: req.file });
    } else {
      // console.log(" not submiited");
      // not acceptable 
      res.status(406).send({ msgType: "danger", msg: `CV UPLOAD FAIL : your ${req.file.originalfilename} is not uploaded.`, file: req.file });
    }
  } catch (err) {
    console.log(err);
    if (err.code === 'ER_DUP_ENTRY') {
      // duplicate entry handled by 304 :not modified status code
      res.status(406).send({ msgType: "danger", msg: `CV UPLOAD FAIL : ERROR CV is already uploaded`, file: req.file });

    } else {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `CV UPLOAD FAIL :ERROR ${err.message}`, file: req.file });
    }
  }

}

// delete

const path = require('path');
const fs = require('fs');
// const { compareSync } = require('bcrypt');
// const { getCitizenDetailsById } = require('../model/Citizen');
// const { error } = require('console');
// delete  document from public
function removeDocFromUpload(fileName) {
  return new Promise((resolve, reject) => {
    let docPath = path.join(__dirname, `../public/uploads/${fileName}`);
    fs.unlink(docPath, (err) => {
      if (err) reject(err);
      resolve(true);
    })
  })
}

exports.deleteCvDocument = async (req, res) => {

  try {

    let user = res.locals.user;
    let docType = 'cvDocument';

    let resultDoc = await Document.getDocumentById(user.userId, 'cvDocument')
    let file = resultDoc[0].cvDocPath;


    removeDocFromUpload(file).then(async (data) => {
      if (data) {
        let result = await Document.deleteDocumentById(resultDoc[0].userId, docType);
        console.log(result)
        if (result.affectedRows > 0) {
          console.log("success")
          res.status(201).send({ msgType: "success", msg: `Congratulations! your CV ${resultDoc[0].cvDocPath} has successfully removed ` });
        } else {
          console.log("error 1")
          res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL : your ${resultDoc[0].cvDocPath} is not removed.` });
        }
      }
    }).catch((err) => {
      console.log(err.message)
      // res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL ${err.message}: your ${resultDoc[0].cvDocPath} is not found.` });
      res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL ${err.message}.` });
    })
  } catch (err) {
    console.log(err.message)
    // res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL ${err.message}: your ${resultDoc[0].cvDocPath} is not found.` });
    res.status(406).send({ msgType: "danger", msg: `CV is not inserted ${err.message}.` });
  }


}

//////////////////////////////////// uploadbirth certificate
exports.postBirthCertificateDocument = async (req, res) => {

  console.log("Posting  Birth Certificate")
  try {

    let user = res.locals.user;
    let fileName = req.file.filename;

    let result = await Document.uploadDocument(user.userId, fileName, 'birthCertificate')
    console.log(result)
    if (result.affectedRows > 0) {
      // console.log("submiited");
      res.status(201).send({ msgType: "success", msg: `Congratulations! your Birth Certificate has successfully uploaded `, file: fileName });
    } else {
      // console.log(" not submiited");
      // not acceptable 
      res.status(406).send({ msgType: "danger", msg: `Birth Certificate UPLOAD FAIL : your ${req.file.originalfilename} is not uploaded.`, file: fileName });
    }
  } catch (err) {
    console.log(err);
    if (err.code === 'ER_DUP_ENTRY') {
      // duplicate entry handled by 304 :not modified status code
      res.status(406).send({ msgType: "danger", msg: `Birth Certificate UPLOAD FAIL : ERROR CV is already uploaded`, file: fileName });

    } else {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `Birth Certificate UPLOAD FAIL :ERROR ${err.message}`, file: fileName });
    }
  }

}


exports.deleteBirthCertificateDocument = async (req, res) => {
  try {
    console.log("Delete  Birth Certificate")
    let user = res.locals.user;
    let docType = 'birthCertificate';

    let resultDoc = await Document.getDocumentById(user.userId, docType);

    let file = resultDoc[0].birthDocPath;

    removeDocFromUpload(file).then(async (data) => {
      if (data) {
        let result = await Document.deleteDocumentById(resultDoc[0].userId, docType);
        // console.log(result)
        if (result.affectedRows > 0) {
          console.log("success")
          res.status(201).send({ msgType: "success", msg: `Congratulations! your Birth Certificate ${file} has successfully removed ` });
        } else {
          console.log("error 1")
          res.status(406).send({ msgType: "danger", msg: `Birth Certificate REMOVAL FAIL : your ${file} is not removed.` });
        }
      }
    }).catch((err) => {
      console.log(err.message)
      //   // res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL ${err.message}: your ${resultDoc[0].cvDocPath} is not found.` });
      res.status(406).send({ msgType: "danger", msg: `Birth Certificate REMOVAL FAIL ${err.message}.` });
    })
  } catch (err) {
    console.log(err.message)
    // res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL ${err.message}: your ${resultDoc[0].cvDocPath} is not found.` });
    res.status(406).send({ msgType: "danger", msg: `CV is not inserted ${err.message}.` });
  }


}




// upload certificates
exports.postCertificateDocuments = async (req, res) => {
  console.log("Posting Certificates")

  let user = res.locals.user;  // console.log(req.body);

  console.log(req.files);

  let files = req.files;
  // console.log(files)
  let filePathArr = [];
  for (let i = 0; i < files.length; i++) {
    filePathArr.push(files[i].filename)
  }
  console.log('filePathArr');
  console.log(filePathArr);
  try {
    let result = await Document.uploadDocument(user.userId, filePathArr, 'certificates')
    console.log(result);
    if (result.affectedRows > 0) {
      res.status(201).send({ msgType: "success", msg: `Congratulations! your Certificates have successfully uploaded `, file: filePathArr });
      // console.log("submitted");
    } else {
      // console.log(" not submiited");
      // not acceptable 
      res.status(406).send({ msgType: "danger", msg: ` Certificates UPLOAD FAIL : your  certificates are not uploaded.`, file: filePathArr });
    }
  } catch (err) {
    // console.log(err);
    if (err.code === 'ER_DUP_ENTRY') {
      // duplicate entry handled by 304 :not modified status code
      res.status(406).send({ msgType: "danger", msg: `Certificates UPLOAD FAIL : ERROR CV is already uploaded`, file: filePathArr });

    } else {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `Certificates UPLOAD FAIL :ERROR ${err.message}`, file: filePathArr });
    }
  }

}

// delete Certificates
function removeDocsFromUpload(files) {
  return new Promise((resolve, reject) => {
    for (let i = 0; i < files.length; i++) {
      let docPath = path.join(__dirname, `../public/uploads/${files[i]}`);
      fs.unlink(docPath, (err) => {
        if (err) reject(err);
        resolve(true);
      })
    }
  })
}


exports.deleteCertificateDocuments = async (req, res) => {
  try {
    console.log("Delete Certificates")
    let user = res.locals.user;
    let docType = 'certificates';

    let resultDoc = await Document.getDocumentById(user.userId, docType);

    let file = resultDoc[0].certificates;

    let result = await Document.deleteDocumentById(resultDoc[0].userId, docType);
    if (result.affectedRows > 0) {
      let notDeletedArr = [], deletedArr = [];
      for (let i = 0; i < file.length; i++) {
        removeDocFromUpload(file[i]).then(async (data) => {
          if (data) {
            deletedArr.push(file[i])
          }
        }).catch(err => {
          console.log(err);
          notDeletedArr.push(file[i])
        })
      }
      if (deletedArr.length < 0) {
        res.status(400).send({ msgType: "danger", msg: `your Certificates has not removed ` });
      } else {
        res.status(200).send({
          msgType: "success", msg: `Congratulations! your Certificates Certificates has successfully removed `, files: { deletedArr, notDeletedArr }
        });
      }

    } else {

      res.status(503).send({ msgType: "danger", msg: `Certificates REMOVAL FAIL : your Certificates has not removed.` });
    }
  } catch (err) {
    console.log(err.message)
    // res.status(406).send({ msgType: "danger", msg: `CV REMOVAL FAIL ${err.message}: your ${resultDoc[0].cvDocPath} is not found.` });
    res.status(406).send({ msgType: "danger", msg: `Certificates are not inserted ${err.message}.` });
  }

}
// qualifications
exports.postCitizenQualifications = async (req, res) => {
  console.log("post citizen qualifications")
  try {
    console.log(req.body);
    let user = res.locals.user;
    const { highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory } = req.body;
    let results = await Document.insertCitizenQualifications(user.userId, highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory)
    console.log(results);
    if (results.affectedRows > 0) {
      console.log("success")
      res.status(201).send({ msgType: "success", msg: `Congratulations! your Qualifications have successfully uploaded ` });

    } else {

      res.status(406).send({ msgType: "danger", msg: ` Qualifications UPLOAD FAIL : your  certificates are not uploaded.` });
    }
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      // duplicate entry handled by 304 :not modified status code
      res.status(406).send({ msgType: "danger", msg: `Qualifications are already uploaded` });
    } else {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `Qualifications submission FAIL :ERROR ${err.message}`, file: fileName });
    }
  }

}

// get update qualifications
exports.getupdateQualifications = async (req, res) => {

  try {
    let user = res.locals.user;
    let qualifications = await Document.getCitizenQualifications(user.userId)

    res.render('citizen/citizen_update_qualifications.ejs', { qualifications: qualifications[0] });
  } catch (err) {
    console.log(err)
  }

}






// update 
exports.updateCitizenQualifications = async (req, res) => {
  console.log("update citizen qualifications")
  try {

    let user = res.locals.user;


    const { highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory } = req.body;
    let results = await Document.updateCitizenQualifications(user.userId, highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory)

    if (results.affectedRows > 0) {
      console.log("success")
      res.status(201).send({ msgType: "success", msg: `Congratulations! your Qualifications have successfully updated ` });

    } else {

      res.status(406).send({ msgType: "danger", msg: ` Qualifications UPDATE FAIL : your  certificates are not updated.` });
    }
  } catch (err) {

    // conflict -not sure
    res.status(409).send({ msgType: "danger", msg: ` ${err.message}`, });

  }

}

exports.deleteCitizenQualifications = async (req, res) => {
  console.log("delete citizen qualifications")
  try {
    let user = res.locals.user;
    let results = await Document.deleteCitizenQualifications(user.userId)

    if (results.affectedRows > 0) {

      res.status(200).redirect('/citizen/dashboard');
      // res.status(201).send({ msgType: "success", msg: `Congratulations! your Qualifications have successfully removed ` });
    } else {
      res.status(406).send({ msgType: "danger", msg: ` Citizen Qualifications removal FAIL ` });
    }
  } catch (err) {
    res.status(409).send({ msgType: "danger", msg: ` Citizen Qualifications removal FAIL ERROR ${err.message}` });
  }
}

exports.getMyProfile = async (req, res) => {
  console.log("get profile")
  // try {
  let user = res.locals.user;
  let cvDetailResults = await Citizen.viewCitizenDetailsById(user.userId)
  let userDetailResult = await Citizen.getCitizenDetailsById(user.userId);

  // console.log(cvDetailResults)
  // console.log(userDetailResult)
  res.render('citizen/citizen_profile', {
    cvDetails: cvDetailResults[0], userDetails: { email: userDetailResult[0].email, userName: userDetailResult[0].userName }
  })

}

exports.updateMyProfile = async (req, res) => {
  console.log("update profile")
  let user = res.locals.user;
  console.log(req.body)

  try {
    const { nic, birthday, userName, affiliations, location } = req.body;

    let cvupdateEntry = { nic, birthday, affiliations, location }
    console.log(cvupdateEntry);

    // updating username and email
    let result = await Citizen.updateUserNameById(userName, user.userId);
    let cvRecordUpdateResults = await Citizen.updateCVDetailsById(cvupdateEntry, user.userId)

    //sucessful registration 
    console.log('cv update Record')
    console.log(cvRecordUpdateResults)

    if (result.affectedRows > 0 || cvRecordUpdateResults.affectedRows > 0) {
      res.status(200).send({
        msgType: "success", msg: `Congratulations! your account has been successfully updated.`,
        entryDetials: { username: userName, cvRecordUpdateResults }
      });

    } else {
      res.status(405).json({ msgType: "danger", msg: `Your account update failed ${err.message}` })
    }
    // if (result.affectedRows > 0){
    //   if (error) throw error.message
    //   res.status(200).send({
    //     msgType: "success", msg: `Congratulations! your account has been successfully updated.`,
    //     entryDetials: { username: userName }
    //   });
    // }
    // if (cvRecordUpdateResults.affectedRows > 0){
    //   if (error) throw error.message
    //   res.status(200).send({
    //     msgType: "success", msg: `Congratulations! your account has been successfully updated.`,
    //     entryDetials: { cvRecordUpdateResults }
    //   });
  } catch (err) {
    res.status(405).json({ msgType: "danger", msg: `Your account update failed ${err.message}` })
    console.log(err);
  }



}

// upload user profile image
exports.uploadProfileBio = async (req, res) => {
  try {
    // if (err instanceof multer.MulterError) {
    //   throw err.message;
    // }else{


    let user = res.locals.user;

    const { bioDescription, bioEmployee, bioEmployeeLocation } = req.body;
    console.log(req.file)
    console.log(req.file.filename)

    const result = await Citizen.postBioDescription(user.userId, req.file.filename, bioDescription, bioEmployee, bioEmployeeLocation);

    if (result.affectedRows > 0) {
      res.status(200).json({
        msgType: "success", msg: `Congratulations! your bio successfully recorded.`,
        bio: { userId: user.userId, fileName: req.file.filename, description: bioDescription, career: bioEmployee, employeeLocation: bioEmployeeLocation }
      });
    } else {
      res.status(405).json({ msgType: "danger", msg: `Your account bio record failed ${err.message}` })
    }
    // }


  } catch (err) {
    res.status(405).json({ msgType: "danger", msg: `Your account update failed ${err.message}` })
  }
}


exports.deleteProfileBio = async (req, res) => {
  try {

    let user = res.locals.user;
    const result = await Citizen.deleteBioDescription(user.userId);

    if (result.affectedRows > 0) {
      res.status(200).json({
        msgType: "success", msg: `Congratulations! your bio successfully recorded.`,

      });
    } else {
      res.status(405).json({ msgType: "danger", msg: `Your account bio record failed ${err.message}` })
    }

  } catch (err) {
    res.status(405).json({ msgType: "danger", msg: `Your account update failed ${err.message}` })
  }

}

exports.viewProfileBio = async (req, res) => {
  try {

    let user = res.locals.user;
    const result = await Citizen.viewBioDescription(userId);
    console.log("view Profile")
    console.log(result)
    if (result.affectedRows > 0) {
      res.status(200).json({
        msgType: "success", msg: `Congratulations! your bio successfully recorded.`,
        bio: { userId: user.userId, fileName: req.file.filename, description: bioDescription }
      });
    } else {
      res.status(405).json({ msgType: "danger", msg: `Your account bio record failed ${err.message}` })
    }

  } catch (err) {
    res.status(405).json({ msgType: "danger", msg: `Your account update failed ${err.message}` })
  }

}

exports.deleteMyBio = async (req, res) => {
  try {

    console.log("DELETE MYBIO")
    let user = res.locals.user;

    const result = await Citizen.deleteBioDescription(user.userId);

    if (result.affectedRows > 0) {
      res.status(200).json({
        msgType: "success", msg: `Congratulations! your bio successfully removed.`,
      });
    } else {
      res.status(405).json({ msgType: "danger", msg: `Your  bio record failed ${err.message}` })
    }

  } catch (err) {
    res.status(500).json({ msgType: "danger", msg: `Your bio delete server failed ${err.message}` })
  }

}



// getMyEmployeement
exports.getMyEmployement = async (req, res) => {
  try {
    console.log("get employemenent details");
    let user = res.locals.user;
    const results = await Citizen.viewCitizenEmploymentDetails(user.userId)
    console.log(results[0])
    if (results.length>0){
      res.render('citizen/citizen_myEmployement', {
        employmentData: {
          currentEmployementRole: results[0].currentEmployementRole, 
          currentEmployedInstitution: results[0].currentEmployedInstitution,
          currentEmployementBuildingNo: results[0].currentEmployementBuildingNo,
          currentEmployementStreet: results[0].currentEmployementStreet,
          currentEmployementRegion: results[0].currentEmployementRegion,
          currentEmployementCountry: results[0].currentEmployementCountry
        }
      })
    }else{
      res.render('citizen/citizen_myEmployement', {
        employmentData: ''
      })
    }
  } catch (err) {
    res.status(409).send({ msgType: "danger", msg: `Details submission FAIL :ERROR ${err.message}` });
  }
}


exports.postMyEmployement = async (req, res) => {
  try {
    console.log("posting employemenent details");

    const { currentEmployementRole, currentEmployedInstitution, currentEmployementBuildingNo, currentEmployementStreet, currentEmployementRegion, currentEmployementCountry } = req.body;
    let user = res.locals.user;

    let results = await Citizen.postCitizenEmploymentDetails(user.userId, currentEmployementRole, currentEmployedInstitution, currentEmployementBuildingNo, currentEmployementStreet, currentEmployementRegion, currentEmployementCountry)
    console.log(results);
    if (results.affectedRows > 0) {
      res.status(201).send({
        msgType: "success", msg: `Congratulations! your Employment Details  have successfully recorded `, data: {
          userId: user.userId, currentEmployementRole, currentEmployedInstitution, currentEmployementBuildingNo, currentEmployementStreet, currentEmployementRegion, currentEmployementCountry
        }
      });

    } else {

      res.status(406).send({ msgType: "danger", msg: ` Employment Details UPLOAD FAIL : Details are not uploaded.` });
    }
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      // duplicate entry handled by 304 :not modified status code
      res.status(406).send({ msgType: "danger", msg: `Details are already uploaded` });
    } else {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `Details submission FAIL :ERROR ${err.message}` });
    }
  }
  // res.render('citizen/citizen_myEmployement',{myEmployement:''})
}
exports.deleteMyEmployement = async (req, res) => {
  try {
    console.log("DELETE Employemennt")
    let user = res.locals.user;

    const result = await Citizen.deleteMyEmploymentDescriptionById(user.userId);

    if (result.affectedRows > 0) {
      res.status(200).json({
        msgType: "success", msg: `Congratulations! your bio successfully removed.`,
      });
    } else {
      res.status(405).json({ msgType: "danger", msg: `Your  bio record failed ${err.message}` })
    }

  } catch (err) {
    res.status(500).json({ msgType: "danger", msg: `Your bio delete server failed ${err.message}` })
  }

}


// updatecv
exports.putMyEmployement = async (req, res) => {
  console.log("update from My Employement")

  try {
    let user = res.locals.user;
    let result = await Citizen.updateMyEmploymentDescriptionById(user.userId);


    if (result.affectedRows > 0) {
      res.status(201).send({ msgType: "success", msg: `Congratulations! your CV has successfully updated`});
    } else {
      res.status(406).send({ msgType: "danger", msg: `CV UPLOAD FAIL : your ${req.file.originalfilename} is not uploaded.` });
    }
  } catch (err) {
      // conflict -not sure
      res.status(409).send({ msgType: "danger", msg: `CV UPLOAD FAIL :ERROR ${err.message}`, file: req.file });
    
  }

}
















// logout

// ////////////////////logout
exports.logOut = (req, res) => {
  console.log("logout");

  res.clearCookie("jwt");
  res.redirect('/citizen/login'); //redirect to login

}


