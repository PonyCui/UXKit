window.UXK_ValueCallback = function () { };
(function ($) {
    var valueHelper = {
        callbacks: {},
        guid: function () {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        },
        commit: function (node, args, callback) {
            var callbackID = this.guid();
            var vKey = node.getAttribute("_UXK_vKey");
            args.callbackID = callbackID;
            args.vKey = vKey;
            this.callbacks[callbackID] = callback;
            try {
                webkit.messageHandlers.UXK_ValueManager.postMessage(JSON.stringify(args));
            } catch (err) {
                console.log("UXK_ValueManager not ready.");
            }
        },
    };
    $.fn.value = function (rKey, callback) {
        var args = {
            rKey: rKey,
        }
        valueHelper.commit(this.get(0), args, callback);
        return args;
    };
    window.UXK_ValueCallback = function (callbackID, JSONString) {
        if (typeof valueHelper.callbacks[callbackID] === "function") {
            var JSONObject = JSON.parse(JSONString);
            valueHelper.callbacks[callbackID].call(this, JSONObject.value);
        }
    };
})(jQuery);