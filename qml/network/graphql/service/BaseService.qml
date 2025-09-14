import QtQuick 2.15
import "../../../"
QtObject{



    function sendRequest(query, variables, callback) {
          var apiUrl = PeakMapConfig.backend_api
          var xhr = new XMLHttpRequest();
          xhr.open("POST", apiUrl);
          xhr.setRequestHeader("Content-Type", "application/json");

          xhr.onreadystatechange = function() {
              if (xhr.readyState === XMLHttpRequest.DONE) {
                  if (xhr.status >= 200 && xhr.status < 300) {
                      var response = JSON.parse(xhr.responseText);
                      callback(null, response);  // success
                  } else {
                      callback(xhr.statusText || "Network error");  // error
                  }
              }
          }

          var body = JSON.stringify({
              query: query,
              variables: variables || {}
          });

          xhr.send(body);
      }
}
