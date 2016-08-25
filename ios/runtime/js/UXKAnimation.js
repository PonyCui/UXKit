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
        var animation = {
            'aniType': 'timing',
            'duration': duration,
        };
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
    $.fn.spring = function (options) {
        var animation = {
            'aniType': 'spring',
            'tension': options ? options.tension : undefined,
            'friction': options ? options.friction : undefined,
            'bounciness': options ? options.bounciness : undefined,
            'speed': options ? options.speed : undefined,
        };
        webkit.messageHandlers.UXK_AnimationHandler_Commit.postMessage(JSON.stringify(animation));
        webkit.messageHandlers.UXK_AnimationHandler_Enable.postMessage("");
        this.update();
        webkit.messageHandlers.UXK_AnimationHandler_Disable.postMessage("");
    };
})(jQuery)