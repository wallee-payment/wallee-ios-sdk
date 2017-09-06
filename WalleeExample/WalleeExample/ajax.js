$( document ).ajaxSend(function( event, request, settings )  {
                       callNativeApp (settings.url);
//                       callNativeApp (settings.data);
//                       callNativeApp (settings);
//                       callNativeApp (event);
                       
                       });

function callNativeApp (data) {
    try {
        webkit.messageHandlers.callbackHandler.postMessage(data);
    }
    catch(err) {
        console.log('The native context does not exist yet');
    }
}
