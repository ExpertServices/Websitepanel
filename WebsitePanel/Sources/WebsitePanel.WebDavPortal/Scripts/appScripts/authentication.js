function CheckAuthenticationExpiration(authcookieName, logoutUrl) {
    var c = $.cookie(authcookieName);

    if (c != null && c != "" && !isNaN(c)) {
        var now = new Date();
        var ms = parseInt(c, 10);
        var expiration = new Date().setTime(ms);
        if (now > expiration) {
            window.location.replace(logoutUrl);
        }
    }
}

function StartAuthExpirationCheckTimer(authcookieName, logoutUrl) {
    setInterval(function() {
        CheckAuthenticationExpiration(authcookieName, logoutUrl);
    }, 20000);
}