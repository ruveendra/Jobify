const pool = require('../config/db-config');


class Document {

  static uploadDocument(userId, document, docType) {
    let insertQry = '';

    if (docType === 'cvDocument') {
      insertQry = "INSERT INTO cvdoc_tb (userId, cvDocPath) VALUES (?,?)"
    }
    if (docType === 'birthCertificate') {
      insertQry = "INSERT INTO birthcertificate_tb (userId,birthDocPath) VALUES (?,?)"
    }
    if (docType === 'certificates') {
      document = JSON.stringify(Object.assign({}, document));
      insertQry = "INSERT INTO certificates_tb (userId,certificates) VALUES (?,?)";

      console.log(document);


    }
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(insertQry, [userId, document], (err, rows) => {
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


  // get documents by userid
  static getDocumentById(id, docType) {

    let selectQry;
    if (docType === 'cvDocument') {
      selectQry = "SELECT * FROM cvdoc_tb WHERE userId = ?";
    }
    if (docType === 'birthCertificate') {
      selectQry = "SELECT * FROM birthcertificate_tb WHERE userId = ?"
    }
    if (docType === 'certificates') {
      selectQry = "SELECT * FROM  certificates_tb WHERE userId = ?";
    }

    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(selectQry, id, (err, rows) => {
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

  // delete documents by userid
  static deleteDocumentById(id, docType) {
    let deleteQry;
    if (docType === 'cvDocument') {
      deleteQry = "DELETE  FROM cvdoc_tb WHERE userId = ?";
    }
    if (docType === 'birthCertificate') {
      deleteQry = "DELETE FROM birthcertificate_tb WHERE userId = ?"
    }
    if (docType === 'certificates') {
      deleteQry = "DELETE FROM  certificates_tb WHERE userId = ?";
    }

    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(deleteQry, id, (err, rows) => {
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

  static insertCitizenQualifications(userId, highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("INSERT INTO citizen_qualifications_tb (userId,highestQualificationType,highestQualificationName,awardingbodyInput,jobCategory) VALUES (?,?,?,?,?)", [userId, highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory], (err, rows) => {
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

  static updateCitizenQualifications(userId, highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("UPDATE citizen_qualifications_tb  SET highestQualificationType = ?,highestQualificationName = ? ,awardingbodyInput =?, jobCategory =?  WHERE userId =?", [highestQualificationType, highestQualificationName, awardingbodyInput, jobCategory,userId,], (err, rows) => {
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

  static getCitizenQualifications(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("SELECT * FROM  citizen_qualifications_tb WHERE userId = ?", userId, (err, rows) => {
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

  
  static deleteCitizenQualifications(userId) {
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query("DELETE FROM  citizen_qualifications_tb  WHERE userId = ?", [userId], (err, rows) => {
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









module.exports = Document;