window._UXK_Router = {
    back: function() {
        var args = JSON.stringify({
                                  routeType: "back",
                                  });
        webkit.messageHandlers.UXK_Router.postMessage(args);
    },
    open: function(url, title) {
        var args = JSON.stringify({
                                  routeType: "open",
                                  url: url,
                                  title: title,
                                  });
        webkit.messageHandlers.UXK_Router.postMessage(args);
    },
    openHTML: function(html, title) {
        var args = JSON.stringify({
                                  routeType: "openHTML",
                                  html: window.btoa(html),
                                  title: title,
                                  });
        webkit.messageHandlers.UXK_Router.postMessage(args);
    },
};
