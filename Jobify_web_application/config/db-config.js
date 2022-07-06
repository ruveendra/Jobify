

require('dotenv').config({ path: './../.env' });
const mysql = require('mysql2');

const { DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT } = process.env;

const pool = mysql.createPool({
  // connectionLimit: 10,
  // host: DB_HOST,
  // port: parseInt(DB_PORT),
  // user: DB_USER,
  // database: DB_NAME,
  // password: DB_PASSWORD
  host: 'localhost',
  port: 3306,
  user: 'root',
  database: 'job4u_db',
  password: '9804D0920t'

});

// module.exports = pool.promise();
module.exports = pool;