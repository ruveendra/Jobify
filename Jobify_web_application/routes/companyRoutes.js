const express = require('express');
const router = express.Router();
const companyController = require('../controller/companyController');
const citizenController =require('../controller/citizenController')


//  bureauOfficer - johnbereau123@gmail.com

// company dashboard
router.get('/', companyController.getDashboard);

router.get('/logout',citizenController.logOut);


















module.exports = router;