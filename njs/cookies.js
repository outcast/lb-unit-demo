function getCookies(cookieString){
    if(cookieString){
      var cookies = cookieString.split(" ");
      var c = {};
      for(var cookie in cookies){
        var elements = cookies[cookie].split(";");
        var data = elements[0].split("=");
        c[data[0]] = {
          "value": data[1],
          "flags": []
        }
        for(var x = 1; x < elements.length; x++){
          if(elements[x] != "" && elements[x]){
            c[data[0]]['flags'].push(elements[x]);
          }
        }
      }
      return c;
    } else {
      return;
    }

}

function getCookieString(cookies){
  var cookieString = "";
  for(var cookie in cookies){
    cookieString += cookie+"="+cookies[cookie].value+";";
    for(var f in cookies[cookie].flags){
      cookieString += cookies[cookie].flags[f]+";";
    }
    cookieString += " ";
  }
  
  return cookieString.slice(0,-2);
  
}

function getSessionCookiePreFix(host){
  return host.replace(/\./g,'-');
}

function proxy(r){
    if(r.headersIn.cookie){
      var cookies = getCookies(r.headersIn.cookie);
      var sessionId = cookies[r.variables.session_prefix+'-'+r.variables.session_name];
      var proxyCookies = {};
      if(sessionId){
        for(var c in cookies){
          if(c != r.variables.session_prefix+'-'+r.variables.session_name){
            proxyCookies[c] = cookies[c];
          }
        }
        proxyCookies[r.variables.session_name]=sessionId;
      }
      return getCookieString(proxyCookies,r);
    }
    return "";
}

function session(r){
  if(r.variables.upstream_http_set_cookie){
    var cookies = getCookies(r.variables.upstream_http_set_cookie);
    for(var c in r.headersOut['Set-Cookie']){
      var cookie = r.headersOut['Set-Cookie'][c];
      if(cookie.startsWith(r.variables.session_name)){
        var setCookie = r.headersOut['Set-Cookie'];
        setCookie.splice(c,1);
        r.headersOut['Set-Cookie']=setCookie;
        break;
      }
    }
    return r.variables.session_prefix+"-"+r.variables.session_name+"="+cookies[r.variables.session_name].value;
  }
  return;
}

function sessionPrefix(r){
  return getSessionCookiePreFix(r.headersIn.host);
}

function syncLookup(r){
  if(r.headersIn.cookie){
    var cookies = getCookies(r.headersIn.cookie);
    if(cookies[r.variables.session_prefix+'-'+r.variables.session_name]){
      return cookies[r.variables.session_prefix+'-'+r.variables.session_name].value;
    }

  }
  return;
}

export default {proxy,session,sessionPrefix,syncLookup};