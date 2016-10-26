window._UXK_Components.SLIDER = {
    props: function (dom) {
        return {
            progress: $(dom).attr('progress') ? Math.max(0.0, Math.min(1.0, parseFloat($(dom).attr('progress')))) : 0.5,
            tintColor: $(dom).attr('tintColor') || "#209b53",
        }
    },
    setProps: function (dom, props) {
        window._UXK_Components.SLIDER.render(dom);
    },
    render: function (dom) {
        var sliderProps = window._UXK_Components.SLIDER.props(dom);
        var width = dom.frame != undefined ? dom.frame.width : 0.0;
        if (width == 0.0) {
            dom.setAttribute("hidden", 'true');
            return;
        }
        else {
            dom.setAttribute("hidden", 'false');
        }
        dom.querySelector("[vKey='trackView']").setAttribute("backgroundColor", sliderProps.tintColor);
        dom.querySelector("[vKey='trackView']").setAttribute("frame", '10,18,' + ((width - 20) * sliderProps.progress) + ',9');
        dom.querySelector("[vKey='blurView']").setAttribute("frame", '10,18,' + (width - 20) + ',9');
        dom.querySelector("[vKey='controlView']").setAttribute("frame", ((width - 22) * sliderProps.progress - 11) + ',0,44,44');
    },
    onLoad: function (dom) {
        $(dom).onLayout(function (frame) {
            dom.frame = frame;
            $(dom).update();
        })
        $(dom).find("[vKey='controlView']").onPan(function (sender) {
            var width = dom.frame != undefined ? dom.frame.width : 0.0;
            if (sender.state == "Began") {
                var progress = Math.max(0.0, Math.min(1.0, sender.superX / width));
                $(dom).setProgress(progress, false);
                if (typeof dom._onchange === "function") {
                    dom._onchange.call(this, progress);
                }
            }
            else if (sender.state == "Changed") {
                var progress = Math.max(0.0, Math.min(1.0, sender.superX / width));
                $(dom).setProgress(progress, false);
                if (typeof dom._onchange === "function") {
                    dom._onchange.call(this, progress);
                }
            }
            else if (sender.state == "Ended") {
                var progress = Math.max(0.0, Math.min(1.0, sender.superX / width));
                $(dom).setProgress(progress, false);
                if (typeof dom._onchange === "function") {
                    dom._onchange.call(this, progress);
                }
            }
        })
        $(dom).value('frame', function (frame) {
            dom.frame = frame;
            $(dom).update();
        })
    },
}

$._attach('setProgress', 'SLIDER', function (progress, animated) {
    if (animated === undefined) {
        animated = true;
    }
    $(this).attr('progress', progress);
    if (animated === true) {
        $(this).animate();
    }
    else {
        $(this).update();
    }
})

$._attach('onChange', 'SLIDER', function (callback) {
    $(this).get(0)._onchange = callback;
})
