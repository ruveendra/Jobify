const express = require('express');
const router = express.Router();
const bureauController = require('../controller/bureauController');




const { checkAuthunetication, verfiedUserInfo } = require('./../middleware/authenticationMiddleware');

router.get('/', checkAuthunetication, verfiedUserInfo, bureauController.getDashboard)

module.exports = router;