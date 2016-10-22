window._UXK_Components.SLIDER = {
    props: function (dom) {
        return {
            progress: $(dom).attr('progress') ? parseFloat($(dom).attr('progress')) : 0.5,
            tintColor: $(dom).attr('tintColor') || "#209b53",
        }
    },
    setProps: function (dom, props) {
        var sliderProps = window._UXK_Components.SLIDER.props(dom);
        var width = dom.frame != undefined ? dom.frame.width : 0.0;
        dom.querySelector("[vKey='trackView']").setAttribute("backgroundColor", sliderProps.tintColor);
        dom.querySelector("[vKey='trackView']").setAttribute("frame", '0,20,' + (width * sliderProps.progress) + ',4');
    },
    onLoad: function (dom) {
        $(dom).onLayout(function (frame) {
            dom.frame = frame;
            window._UXK_Components.SLIDER.setProps(dom, {});
            $(dom).update();
        })
        $(dom).value('frame', function(frame){
            dom.frame = frame;
            window._UXK_Components.SLIDER.setProps(dom, {});
            $(dom).update();
        })
    },
}