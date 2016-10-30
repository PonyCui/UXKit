
window.ux = {
    callbacks: {},
    createCallback: function(callback) {
        if (typeof callback !== "function") {
            return undefined;
        }
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        }
        var guid = s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        window.ux.callbacks[guid] = callback;
        return guid;
    },
    ani: window._UXK_Animation,
    router: window._UXK_Router,
    ready: window.ux_ready,
}

jQuery(document.body).update();

if (typeof window.ux.ready === "function") {
    window.ux.ready.call(this);
}
