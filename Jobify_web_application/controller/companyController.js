const Company = require('../model/Company');
const Document = require('../model/Document');

exports.getDashboard = async(req, res) => {
  try {
    let results;
    

console.log(req.query);
    let page = req.query.page ? Number(req.query.page) : 1;
    if (page < 1) {
      res.status(200).redirect('company/company-dashboard?page=' + encodeURIComponent(1));
    } else {
      if (req.query.searchInput && req.query.jobCategory) {
        results = await Company.searchAndFilterCitizenDetails(req.query.searchInput, req.query.jobCategory, page);
       
        res.render('company/company-dashboard', { citizenResults: results.citizenResults, page: results.page, pageCount: results.numOfPages })
       
      }
      else if (req.query.searchInput) {
        results = await Company.searchCitizenDetailsByUserName(req.query.searchInput, page);
        res.render('company/company-dashboard', { citizenResults: results.citizenResults, page: results.page, pageCount: results.numOfPages })
      }
      else if(req.query.jobCategory) {
        // console.log("searched" + req.query.jobCategory)
        results = await Company.filterCitizenDetailsByCategory(req.query.jobCategory, page);
        res.render('company/company-dashboard', { citizenResults: results.citizenResults, page: results.page, pageCount: results.numOfPages})

      }else{
        results = await Company.viewCitizenDetails(page);
        res.render('company/company-dashboard', { citizenResults: results.citizenResults, page: results.page, pageCount: results.numOfPages})
      }
      
     
    }
  
  }catch(err){
    console.log(err)
  }
};


