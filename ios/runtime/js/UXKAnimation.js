window._UXK_Animation = {
    spring: function (options) {
        return {
            'aniType': 'spring',
            'tension': options ? options.tension : undefined,
            'friction': options ? options.friction : undefined,
            'bounciness': options ? options.bounciness : undefined,
            'speed': options ? options.speed : undefined,
        }
    },
    decay: function (options) {
        return {
            'aniType': 'decay',
            'aniProps': options ? options.aniProps : undefined,
            'vKey': options ? options.vKey : undefined,
            'velocity': options ? options.velocity : undefined,
            'deceleration': options ? options.deceleration : undefined,
        }
    },
    timing: function (options) {
        return {
            'aniType': 'timing',
            'duration': options ? options.duration : undefined,
        }
    },
};

(function ($) {
    $.fn.animate = function (duration) {
        var animation = window._UXK_Animation.timing({duration: duration});
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.spring = function (options) {
        var animation = window._UXK_Animation.spring(options);
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.decay = function (options) {
        var animation = window._UXK_Animation.decay(options);
        animation.vKey = this.get(0).getAttribute("_UXK_vKey");
        webkit.messageHandlers.UXK_AnimationHandler_DecayStart.postMessage(JSON.stringify(animation));
    };
    $.fn.stop = function() {
        var vKey = this.get(0).getAttribute("_UXK_vKey");
        webkit.messageHandlers.UXK_AnimationHandler_Stop.postMessage(JSON.stringify({
            vKey: vKey,
        }));
    };
})(jQuery)