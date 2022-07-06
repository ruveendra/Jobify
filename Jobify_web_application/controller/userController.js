


exports.login = (req, res) => {
  res.render('login')
};

exports.postLogin = (req, res) => {
  console.log(req.body);
};

exports.getregister = (req, res) => {
  res.render('register')
};

exports.postRegister =(req, res) => {
  console.log(req.body);
}