const express = require('express');
const router = express.Router();
const citizenController = require('../controller/citizenController.js');
const multer = require('../services/multer');
// const imageUpload  = require('../services/imageUpload');



const { checkAuthunetication, verfiedUserInfo } = require('./../middleware/authenticationMiddleware');

// NOTE MAKE ROUTE AS CITIZENS

// register
router.get('/register', citizenController.getRegister);
router.post('/register', citizenController.postRegister);

// login
router.get('/login', citizenController.getLogin);
router.post('/login', citizenController.postLogin);

// logout
router.get('/logout', citizenController.logOut);

// dashboard
router.get('/dashboard', checkAuthunetication, verfiedUserInfo, citizenController.getDashboard);
// router.get('/dashboard', checkAuthunetication, verfiedUserInfo, citizenController.getDashboard);

router.get('/dashboard/myBio', checkAuthunetication, verfiedUserInfo, citizenController.getBio);
router.post('/dashboard/myBio', verfiedUserInfo, multer.upload.single('avatar'), citizenController.uploadProfileBio);
router.delete('/dashboard/myBio', verfiedUserInfo, citizenController.deleteMyBio)

router.post('/dashboard/qualifications', checkAuthunetication, verfiedUserInfo, citizenController.postCitizenQualifications);
router.delete('/dashboard/qualifications', checkAuthunetication, verfiedUserInfo, citizenController.deleteCitizenQualifications);
// router.delete('/dashboard/qualifications/remove', checkAuthunetication, verfiedUserInfo, citizenController.deleteCitizenQualifications);
// // router.post('/login', generalContFroller.postLogin);

// update qualifications
router.get('/dashboard/updateQualifications', checkAuthunetication, verfiedUserInfo, citizenController.getupdateQualifications);
router.put('/dashboard/qualifications', checkAuthunetication, verfiedUserInfo, citizenController.updateCitizenQualifications);

// cv
router.post('/nid/cv', multer.upload.single('cv'), verfiedUserInfo, citizenController.postCvDocument);
router.put('/nid/cv', multer.upload.single('cv'), checkAuthunetication, verfiedUserInfo, citizenController.putCvDocument);
router.delete('/nid/cv', checkAuthunetication, verfiedUserInfo, citizenController.deleteCvDocument);

// BirthCertificate
router.post('/nid/birthCertificate', multer.upload.single('birthCertificate'), verfiedUserInfo, citizenController.postBirthCertificateDocument)
router.delete('/nid/birthCertificate', checkAuthunetication, verfiedUserInfo, citizenController.deleteBirthCertificateDocument);


// certificate
router.post('/nid/certificates', multer.upload.array('certificates', 3), verfiedUserInfo, citizenController.postCertificateDocuments)
router.delete('/nid/certificates', verfiedUserInfo, citizenController.deleteCertificateDocuments)

// // router.get('/contact', generalController.getContact);
// // router.post('/contact', generalController.postContact);

// profile
router.get('/myProfile', checkAuthunetication, verfiedUserInfo, citizenController.getMyProfile);
router.put('/myProfile', checkAuthunetication, verfiedUserInfo, citizenController.updateMyProfile);


// my employeement status
router.get('/myEmployement', checkAuthunetication, verfiedUserInfo, citizenController.getMyEmployement);
router.post('/myEmployement', checkAuthunetication, verfiedUserInfo, citizenController.postMyEmployement);
router.put('/myEmployement', checkAuthunetication, verfiedUserInfo, citizenController.putMyEmployement);
router.delete('/myEmployement', checkAuthunetication, verfiedUserInfo, citizenController.deleteMyEmployement);
// router.post('/myEmployeement', checkAuthunetication, verfiedUserInfo, citizenController.postMyEmployeement);




router.post('/myProfile/profileImage', verfiedUserInfo, multer.upload.single('avatar'), citizenController.uploadProfileBio)
router.post('/myProfile/profileImage/:id', verfiedUserInfo, multer.upload.single('avatar'), citizenController.uploadProfileBio)



module.exports = router;