require('dotenv').config();
const express = require('express');
const path = require('path');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var methodOverride = require('method-override')

// routes
const citizenRoutes = require('./routes/citizenRoutes');
const companyRoutes = require('./routes/companyRoutes');
const bureauRoutes = require('./routes/bureauRoutes');





const app = express();

// setting ejs view engine
app.set('view engine', 'ejs');
// cookie-parser
app.use(cookieParser());
// override with POST having ?_method=DELETE
app.use(methodOverride('_method'))

app.use(bodyParser.json());
// access parameters in req.body
app.use(bodyParser.urlencoded({ extended: false }));
// setting static folder //serves resuources from public folder
app.use(express.static(path.join(__dirname, 'public')));



// configuring routes
// app.use('/', generalRoutes);
app.use('/citizen', citizenRoutes);
app.use('/company', companyRoutes);
app.use('/bureau', bureauRoutes);

app.get('/', (req, res) => {
  res.render('index')
});


app.get('/contact', (req, res) => {
  res.render('contact')
});


// app.use('/', generalRoutes);

app.listen(5000, () => console.log('listening to server on 5000'))
// app.listen(5000,'192.168.8.153', () => console.log('listening to server on 5000'))