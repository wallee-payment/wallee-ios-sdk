#  ajax.js
#  WalleeSDK
#
#  Created by Daniel Schmid on 05.09.17.
#  Copyright © 2017 smoca AG. All rights reserved.

$( document ).ajaxSend(function( event, request, settings )  {
                       callNativeApp (settings.data);
                       });

function callNativeApp (data) {
    try {
        webkit.messageHandlers.callbackHandler.postMessage(data);
    }
    catch(err) {
        console.log('The native context does not exist yet');
    }
}
