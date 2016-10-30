window._UXK_Animation = {
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
            'bounceRect': options ? options.bounceRect : undefined,
        });
    },
    decayBounce: function (options) {
        return Object.assign(this.base(options), {
            'aniType': 'decayBounce',
            'bounce': options ? options.bounce : true,
            'aniProps': options ? options.aniProps : undefined,
            'vKey': options ? options.vKey : undefined,
            'velocity': options ? options.velocity : undefined,
            'deceleration': options ? options.deceleration : undefined,
            'bounceRect': options ? options.bounceRect : undefined,
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
        register: function (animation) {
            if (typeof animation.onChange === "function") {
                animation.onChange = window.ux.createCallback(animation.onChange);;
            }
            if (typeof animation.onComplete === "function") {
                animation.onComplete = window.ux.createCallback(animation.onComplete);
            }
        },
    };
    $.fn.animate = function (duration, options, onComplete) {
        if (typeof duration === "function" && options === undefined && onComplete === undefined) {
            options = {
                onComplete: duration,
            };
        }
        else if (typeof options === "function" || (typeof onComplete === "function" && options === undefined)) {
            options = {
                onComplete: options,
            };
        }
        else if (typeof onComplete === "function") {
            options['onComplete'] = onComplete;
        }
        var animation = window._UXK_Animation.timing(Object.assign({ duration: duration }, (options ? options : {})));
        callbackHelper.register(animation);
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.spring = function (options, onComplete) {
        if (typeof options === "function" || (typeof onComplete === "function" && options === undefined)) {
            options = {
                onComplete: options,
            };
        }
        else if (typeof onComplete === "function") {
            options['onComplete'] = onComplete;
        }
        var animation = window._UXK_Animation.spring(options);
        callbackHelper.register(animation);
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.decay = function (options, onComplete) {
        if (typeof options === "function" || (typeof onComplete === "function" && options === undefined)) {
            options = {
                onComplete: options,
            };
        }
        else if (typeof onComplete === "function") {
            options['onComplete'] = onComplete;
        }
        var animation = window._UXK_Animation.decay(options);
        callbackHelper.register(animation);
        animation.vKey = this.get(0).getAttribute("_UXK_vKey");
        webkit.messageHandlers.UXK_AnimationHandler_Decay.postMessage(JSON.stringify(animation));
    };
    $.fn.decayBounce = function (options, onComplete) {
        if (typeof options === "function" || (typeof onComplete === "function" && options === undefined)) {
            options = {
                onComplete: options,
            };
        }
        else if (typeof onComplete === "function") {
            options['onComplete'] = onComplete;
        }
        var animation = window._UXK_Animation.decayBounce(options);
        callbackHelper.register(animation);
        animation.vKey = this.get(0).getAttribute("_UXK_vKey");
        webkit.messageHandlers.UXK_AnimationHandler_Decay.postMessage(JSON.stringify(animation));
    };
    $.fn.stop = function (callback) {
        var vKey = this.get(0).getAttribute("_UXK_vKey");
        webkit.messageHandlers.UXK_AnimationHandler_Stop.postMessage(JSON.stringify({
            vKey: vKey,
            callbackID: window.ux.createCallback(callback),
        }));
    };
})(jQuery)