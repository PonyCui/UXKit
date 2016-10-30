window.UXK_ValueCallback = function () { };
(function ($) {
    var valueHelper = {
        commit: function (node, args, callback) {
            var vKey = node.getAttribute("_UXK_vKey");
            args.callbackID = window.ux.createCallback(callback);
            args.vKey = vKey;
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
    $.fn.listen = function (rKey, callback) {
        var args = {
            rKey: rKey,
            listen: true,
        }
        valueHelper.commit(this.get(0), args, callback);
        return args;
    };
})(jQuery);

// Helpers

(function($) {
    $.fn.focus = function() {
        this.value("focus", undefined);
    };
    $.fn.blur = function() {
        this.value("blur", undefined);
    };
})(jQuery)