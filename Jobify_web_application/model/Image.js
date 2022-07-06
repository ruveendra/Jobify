const pool = require('../config/db-config');

class Image{
  
  static uploadProfile(userId, imgPhoto, profileBio){
    let insertQry = "INSERT INTO profile_tb (userId,imgPhoto,profileBio) VALUES (?,?,?)";
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(insertQry, [userId, imgPhoto, profileBio], (err, rows) => {
          // return connection to tthe pool
          connection.release();
          if(!err) {
            resolve(rows);
          }
          else {
            reject(err);
          }
        });
      });
    });
  }

  
  static uploadProfile(userId, imgPhoto, profileBio){
    let insertQry = "INSERT INTO profile_tb (userId,imgPhoto,profileBio) VALUES (?,?,?)";
    return new Promise((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(insertQry, [userId, imgPhoto, profileBio], (err, rows) => {
          // return connection to tthe pool
          connection.release();
          if(!err) {
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

module.exports= Image;