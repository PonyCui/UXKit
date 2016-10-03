window._UXK_Components.SCROLLVIEW = {
    onLoad: function(dom) {
        $(dom).onTap(function(){
            dom.querySelector("[vKey='contentView']").setAttribute('backgroundColor', '#000000');
            $('body').update();
        });
    },
    setProps: function(dom, props) {
        if (typeof props.contentsize === "string") {
            var contentSize = {
                width: props.contentsize.split(',')[0],
                height: props.contentsize.split(',')[1],
            }
            dom.querySelector("[vKey='contentView']").setAttribute('frame', '0,0,' + contentSize.width + ',' + contentSize.height);
        }
    }
}
