window._UXK_Components.SWITCH = {
    props: function (dom) {
        return {
            on: $(dom).attr('on') === "true" ? true : false,
        }
    },
    setProps: function (dom, props) {
        var switchProps = window._UXK_Components.SWITCH.props(dom);
        if (switchProps.on) {
            dom.querySelector("[vKey='backgroundView']").setAttribute("backgroundColor", "#209b53");
            dom.querySelector("[vKey='controlView']").setAttribute("frame", "24,2,24,24");
        }
        else {
            dom.querySelector("[vKey='backgroundView']").setAttribute("backgroundColor", "#dcdcdc");
            dom.querySelector("[vKey='controlView']").setAttribute("frame", "2,2,24,24");
        }
    },
    onLoad: function(dom) {
        $(dom).onTap(function(sender){
            var switchProps = window._UXK_Components.SWITCH.props(dom);
            $(dom).attr('on', switchProps.on ? 'false' : 'true');
            $(dom).animate();
        })
    },
}
