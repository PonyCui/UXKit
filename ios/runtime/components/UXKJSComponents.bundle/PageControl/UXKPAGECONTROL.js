window._UXK_Components.PAGECONTROL = {
    props: function (dom) {
        return {
            numberOfPages: $(dom).attr('numberOfPages') ? parseInt($(dom).attr('numberOfPages')) : 0,
            currentPage: $(dom).attr('currentPage') ? parseInt($(dom).attr('currentPage')) : 0,
            pageIndicatorTintColor: $(dom).attr('pageIndicatorTintColor') || "#80209b53",
            currentPageIndicatorTintColor: $(dom).attr('currentPageIndicatorTintColor') || "#ff209b53",
        }
    },
    setProps: function (dom, props) {
        var pageControlProps = window._UXK_Components.PAGECONTROL.props(dom);
        if (dom._props === undefined || dom._props.numberOfPages !== pageControlProps.numberOfPages) {
            // changed
            var wrapWidth = pageControlProps.numberOfPages * 8 + (pageControlProps.numberOfPages + 1) * 6;
            dom.querySelector("[vKey='wrapView']").setAttribute("frame", "|-@-[" + wrapWidth + "]-@-|,|-0-[]-0-|");
            var dotDOM = [];
            for (var index = 0; index < pageControlProps.numberOfPages; index++) {
                var x = index * 8 + (index + 1) * 6;
                dotDOM.push('<view frame="' + x + ',0,8,8" cornerRadius="4" backgroundColor="' + pageControlProps.pageIndicatorTintColor + '"></view>');
            }
            dom.querySelector("[vKey='wrapView']").innerHTML = dotDOM.join("");
        }
        $(dom).find("[vKey='wrapView']").find('view').attr('backgroundColor', pageControlProps.pageIndicatorTintColor);
        $(dom).find("[vKey='wrapView']").find('view:eq(' + pageControlProps.currentPage + ')').attr('backgroundColor', pageControlProps.currentPageIndicatorTintColor);
        dom._props = pageControlProps;
    },
}