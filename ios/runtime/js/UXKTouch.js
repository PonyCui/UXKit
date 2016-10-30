(function ($) {
    var touchHelper = {
        commit: function (node, args, callback) {
            var vKey = node.getAttribute("_UXK_vKey");
            args.callbackID = window.ux.createCallback(callback);
            args.vKey = vKey;
            args.remove = function () {
                try {
                    args.removed = true;
                    webkit.messageHandlers.UXK_TouchUpdater.postMessage(JSON.stringify(args));
                } catch (err) {
                    console.log("UXK_TouchUpdater not ready.");
                }
            }
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
    $.fn.onTap = function (callback, anArgs) {
        var args = {
            touchType: 'tap',
            touches: 1,
            taps: 1,
        }
        if (anArgs !== undefined) {
            Object.assign(args, anArgs)
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    $.fn.onDoubleTap = function (callback, anArgs) {
        var args = {
            touchType: 'tap',
            touches: 1,
            taps: 2,
        }
        if (anArgs !== undefined) {
            Object.assign(args, anArgs)
        }
        touchHelper.commit(this.get(0), args, callback);
        return args;
    };
    $.fn.onLongPress = function (callback, anArgs) {
        var args = {
            touchType: 'longPress',
            touches: 1,
            taps: 0,
            duration: 0.5,
            allowMovement: 10,
        }
        if (anArgs !== undefined) {
            Object.assign(args, anArgs)
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
})(jQuery);
