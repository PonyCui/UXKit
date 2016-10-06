window._UXK_Animation = {
    callbacks: {},
    base: function (options) {
        return {
            'onChange': options ? options.onChange : undefined,
            'onComplete': options ? options.onComplete : undefined,
        };
    },
    spring: function (options) {
        return Object.assign(this.base(options), {
            'aniType': 'spring',
            'tension': options ? options.tension : undefined,
            'friction': options ? options.friction : undefined,
            'bounciness': options ? options.bounciness : undefined,
            'speed': options ? options.speed : undefined,
        });
    },
    decay: function (options) {
        return Object.assign(this.base(options), {
            'aniType': 'decay',
            'aniProps': options ? options.aniProps : undefined,
            'vKey': options ? options.vKey : undefined,
            'velocity': options ? options.velocity : undefined,
            'deceleration': options ? options.deceleration : undefined,
        });
    },
    timing: function (options) {
        return Object.assign(this.base(options), {
            'aniType': 'timing',
            'duration': options ? options.duration : undefined,
        });
    },
};

(function ($) {
    var callbackHelper = {
        guid: function () {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        },
        register: function (animation) {
            if (typeof animation.onChange === "function") {
                var guid = this.guid();
                window._UXK_Animation.callbacks[guid] = animation.onChange;
                animation.onChange = guid;
            }
            if (typeof animation.onComplete === "function") {
                var guid = this.guid();
                window._UXK_Animation.callbacks[guid] = animation.onComplete;
                animation.onComplete = guid;
            }
        },
    };
    $.fn.animate = function (duration, options) {
        var animation = window._UXK_Animation.timing(Object.assign({ duration: duration }, (options ? options : {})));
        callbackHelper.register(animation);
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.spring = function (options) {
        var animation = window._UXK_Animation.spring(options);
        callbackHelper.register(animation);
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.decay = function (options) {
        var animation = window._UXK_Animation.decay(options);
        callbackHelper.register(animation);
        animation.vKey = this.get(0).getAttribute("_UXK_vKey");
        webkit.messageHandlers.UXK_AnimationHandler_DecayStart.postMessage(JSON.stringify(animation));
    };
    $.fn.stop = function (callback) {
        var vKey = this.get(0).getAttribute("_UXK_vKey");
        var callbackID = undefined;
        if (typeof callback === "function") {
            callbackID = callbackHelper.guid();
            window._UXK_Animation.callbacks[callbackID] = callback;
        }
        webkit.messageHandlers.UXK_AnimationHandler_Stop.postMessage(JSON.stringify({
            vKey: vKey,
            callbackID: callbackID,
        }));
    };
})(jQuery)