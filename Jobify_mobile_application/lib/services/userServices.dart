import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' ;
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CallApi {

  final String _url = 'http://192.168.56.1:5000/citizen';


  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  loginTryPost(token, apiUrl) async {
    // var fullUrl = _url + apiUrl;
    // return await http.get(Uri.parse(fullUrl), headers: _setHeaderstoken(token));


    var body;
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    var response= await http.get(Uri.parse(fullUrl),
        headers: _setHeaderstoken(token));
    body =  json.decode(response.body);
    // print(body);

    if(body['msg']=='Token has expired'){
      await tokenRef();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var newToken = localStorage.getString('token');
      return await http.get(Uri.parse(fullUrl),
          headers: _setHeaderstoken(newToken));
    }
    else {
      return response;
    }

  }

  getQualifications(apiUrl, token) async{

    var body;
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    var response= await http.get(Uri.parse(fullUrl),
        headers: _setHeaderstoken(token));
    body =  json.decode(response.body);
    // print(body);

    if(body['msg']=='Token has expired'){
      await tokenRef();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var newToken = localStorage.getString('token');
      return await http.get(Uri.parse(fullUrl),
          headers: _setHeaderstoken(newToken));
    }
    else {
      return response;
    }
  }


  getDocuments(apiUrl, token) async{

    var body;
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    var response= await http.get(Uri.parse(fullUrl),
        headers: _setHeaderstoken(token));
    body =  json.decode(response.body);
    // print(body);

    if(body['msg']=='Token has expired'){
      await tokenRef();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var newToken = localStorage.getString('token');
      return await http.get(Uri.parse(fullUrl),
          headers: _setHeaderstoken(newToken));
    }
    else {
      return response;
    }
  }

// Get New Token (Session)
  tokenRef() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var refToken = localStorage.getString('refToken');
    var token = localStorage.getString('token');
    // var user = localStorage.getString('user');
    var response = await CallApi().tokenUpdate(refToken, 'auth/token/refresh'); // Write the function in CallApi
    print(response.body);
    var body = json.decode(response.body);

    localStorage.setString('token', body['access']);
    // var token1 = Provider.of<UserProvider>().user.token;
  }


  tokenUpdate(refToken, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaderstoken(refToken));
  }

// Update Name
  putUserData(data, apiUrl, token) async {

    var body;
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    var response= await http.put(Uri.parse(fullUrl),
        body:  jsonEncode(data), headers: _setHeaderstoken(token));
    body =  json.decode(response.body);
    // print(body);

    if(body['msg']=='Token has expired'){
      await tokenRef();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var newToken = localStorage.getString('token');
      return await http.put(Uri.parse(fullUrl),
          body:  jsonEncode(data), headers: _setHeaderstoken(newToken));
    }
    else {
      return response;
    }
  }
// Update Email
  putEmailData(data, apiUrl, token) async {
    var body;
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    var response = await http.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaderstoken(token));

    if(body['msg']=='Token has expired'){
      await tokenRef();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var newToken = localStorage.getString('token');
      return await http.put(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaderstoken(newToken));
    }
    else {
      return response;
    }

  }
//Update User Password
  putUpdatePass(data, apiUrl,token) async {
    var body;
    var fullUrl = _url + apiUrl ;
    print(fullUrl);
    var response = await http.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaderstoken(token));

    if(body['msg']=='Token has expired'){
      await tokenRef();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var newToken = localStorage.getString('token');
      return await http.put(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaderstoken(newToken));
    }
    else {
      return response;
    }
  }



  _setHeaderstoken(token) => {
    'Cookie': 'jwt=$token',
    'Content-type': 'application/json',
    'Accept': '*/*',
  };

  getData(apiUrl) async {
    var fulurl = _url + apiUrl + await getToken();
    debugPrint(fulurl);
    return await http.get(Uri.parse(fulurl), headers: _setHeaders());
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('apitoken');
    return '?apitoken=$token';
  }

  setToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
    localStorage.setString('apitoken', 'ZDDF5FD16DF9D2GFG3BG9BG2DF3F');
    return token;
  }
}
