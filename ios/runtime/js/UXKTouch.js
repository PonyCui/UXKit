window.UXK_TouchCallback = function () { };
(function ($) {
    var touchHelper = {
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
            args.remove = function () {
                try {
                    args.removed = true;
                    webkit.messageHandlers.UXK_TouchUpdater.postMessage(JSON.stringify(args));
                } catch (err) {
                    console.log("UXK_TouchUpdater not ready.");
                }
            }
            this.callbacks[callbackID] = callback;
            try {
                webkit.messageHandlers.UXK_TouchUpdater.postMessage(JSON.stringify(args));
            } catch (err) {
                console.log("UXK_TouchUpdater not ready.");
            }
        },
    };
    $.fn.onTouch = function (callback) {
        var args = {
            touchType: 'touch',
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    $.fn.onTap = function (callback) {
        var args = {
            touchType: 'tap',
            touches: 1,
            taps: 1,
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    $.fn.onDoubleTap = function (callback) {
        var args = {
            touchType: 'tap',
            touches: 1,
            taps: 2,
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    $.fn.onLongPress = function (callback) {
        var args = {
            touchType: 'longPress',
            touches: 1,
            taps: 0,
            duration: 0.5,
            allowMovement: 10,
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    $.fn.onPan = function (callback) {
        var args = {
            touchType: 'pan',
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    window.UXK_TouchCallback = function (callbackID, params) {
        if (typeof touchHelper.callbacks[callbackID] === "function") {
            touchHelper.callbacks[callbackID].call(this, params);
        }
    };
})(jQuery);
