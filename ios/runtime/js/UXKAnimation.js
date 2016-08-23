window._UXK_Animation = {
    spring: function(options) {
        return {
            'aniType': 'spring',
            'tension': options ? options.tension : undefined,
            'friction': options ? options.friction : undefined,
            'bounciness': options ? options.bounciness : undefined,
            'speed': options ? options.speed : undefined,
        }
    },
    decay: function(options) {
        return {
            'aniType': 'decay',
            'velocity': options ? options.velocity : undefined,
            'deceleration': options ? options.deceleration : undefined,
        }
    },
    timing: function(options) {
        return {
            'aniType': 'timing',
            'duration': options ? options.duration : undefined,
        }
    },
};