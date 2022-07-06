const pool = require('../config/db-config');
// const uuid = require('uuid');

class Company {

  // gct  all the citizen details-
  static viewCitizenDetails(page) {

    let resultsPerPage = 1;
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM citizen_view", (err, rows) => {
          connection.release();
          if (!err) {

            const numOfData = rows.length;
            const numOfPages = Math.ceil(numOfData / resultsPerPage);
            const startLimit = (page - 1) * resultsPerPage;

            let sql = `SELECT  * FROM citizen_view LIMIT ${startLimit},${resultsPerPage} `;
            connection.query(sql, (err, citizenResults) => {
              resolve({ citizenResults, page, numOfPages });
            })
          }
          else {
            reject(err);
          }
        });
      });
    });

  }

  static filterCitizenDetailsByCategory(jobCategory,page) {

    let resultsPerPage = 1;
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM citizen_view where jobCategory = ? ", jobCategory, (err, rows) => {
          connection.release();
          if (!err) {

            const numOfData = rows.length;
            const numOfPages = Math.ceil(numOfData / resultsPerPage);
            const startLimit = (page - 1) * resultsPerPage;

            let sql = `SELECT  * FROM citizen_view  where jobCategory = ? LIMIT ${startLimit},${resultsPerPage} `;
            connection.query(sql, jobCategory, (err, citizenResults) => {
              resolve({ citizenResults, page, numOfPages });
            })
          }
          else {
            reject(err);
          }
        });
      });
    });

  }

  static searchAndFilterCitizenDetails(userNameInput, jobCategory,page) {
    let resultsPerPage = 1;
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(`SELECT * FROM citizen_view where userName  LIKE '%${userNameInput}%'   AND jobCategory = ?`, jobCategory, (err, rows) => {
          connection.release();
          if (!err) {

            const numOfData = rows.length;
            const numOfPages = Math.ceil(numOfData / resultsPerPage);
            const startLimit = (page - 1) * resultsPerPage;

            let sql = `SELECT * FROM citizen_view where userName  LIKE '%${userNameInput}%'  AND jobCategory =? LIMIT ${startLimit},${resultsPerPage} `;
            connection.query(sql, jobCategory, (err, citizenResults) => {
              if(err) reject (err)
              resolve({ citizenResults, page, numOfPages });
            })
          }
          else {
            reject(err);
          }
        });
      });
    });

  }
  
  static searchCitizenDetailsByUserName(userNameInput,page) {
    let resultsPerPage = 1;
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(`SELECT * FROM citizen_view where userName  LIKE '%${userNameInput}%' ` , (err, rows) => {
          connection.release();
          if (!err) {

            const numOfData = rows.length;
            const numOfPages = Math.ceil(numOfData / resultsPerPage);
            const startLimit = (page - 1) * resultsPerPage;

            let sql = `SELECT * FROM citizen_view where userName  LIKE '%${userNameInput}%'  LIMIT ${startLimit},${resultsPerPage} `;
            connection.query(sql,(err, citizenResults) => {
              if(err) reject (err)
              resolve({ citizenResults, page, numOfPages });
            })
          }
          else {
            reject(err);
          }
        });
      });
    });

  }


}

module.exports = Company;