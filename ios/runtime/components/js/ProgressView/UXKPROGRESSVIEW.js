window._UXK_Components.PROGRESSVIEW = {
    props: function (dom) {
        return {
            progress: $(dom).attr('progress') ? Math.max(0.0, Math.min(1.0, parseFloat($(dom).attr('progress')))) : 0.5,
            tintColor: $(dom).attr('tintColor') || "#209b53",
        }
    },
    setProps: function (dom, props) {
        var progressViewProps = window._UXK_Components.PROGRESSVIEW.props(dom);
        var width = dom.frame != undefined ? dom.frame.width : 0.0;
        if (width == 0.0) {
            dom.setAttribute("hidden", 'true');
            return;
        }
        else {
            dom.setAttribute("hidden", 'false');
        }
        dom.querySelector("[vKey='trackView']").setAttribute("backgroundColor", progressViewProps.tintColor);
        dom.querySelector("[vKey='trackView']").setAttribute("frame", '0,0,' + ((width - 0) * progressViewProps.progress) + ',2');
        dom.querySelector("[vKey='blurView']").setAttribute("frame", '0,0,' + (width - 0) + ',2');
    },
    onLoad: function (dom) {
        $(dom).onLayout(function (frame) {
            dom.frame = frame;
            $(dom).update();
        })
        $(dom).value('frame', function (frame) {
            dom.frame = frame;
            $(dom).update();
        })
    },
}

$._attach('setProgress', 'PROGRESSVIEW', function (progress, animated) {
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