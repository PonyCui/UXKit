window._UXK_Components.SWITCH = {
    props: function (dom) {
        return {
            on: $(dom).attr('on') === "true" ? true : false,
            tintColor: $(dom).attr('tintColor') || "#209b53",
        }
    },
    setProps: function (dom, props) {
        var switchProps = window._UXK_Components.SWITCH.props(dom);
        if (switchProps.on) {
            dom.querySelector("[vKey='backgroundView']").setAttribute("backgroundColor", switchProps.tintColor);
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
            if (typeof dom._onchange === "function") {
                dom._onchange.call(this, !switchProps.on);
            }
        });
    },
}

$._attach('setOn', 'SWITCH', function(on, animated){
    if (animated === undefined) {
        animated = true;
    }
    $(this).attr('on', on ? "true" : "false");
    if (animated === true) {
        $(this).animate();
    }
    else {
        $(this).update();
    }
})

$._attach('onChange', 'SWITCH', function(callback){
    $(this).get(0)._onchange = callback; 
})
