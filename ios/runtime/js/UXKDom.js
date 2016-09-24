(function ($) {
    var domHelper = {
        kVisualDOMNames: ["BODY", "VIEW"],
        kVisualDOMAttrs: ["frame",
            "userInteractionEnabled",
            "transform",
            "clipsToBounds",
            "backgroundColor",
            "alpha",
            "hidden",
            "cornerRadius",
            "borderWidth",
            "borderColor",
        ],
        guid: function () {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        },
        assignKeys: function (node) {
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                var childNode = childNodes[i];
                if (this.kVisualDOMNames.indexOf(childNode.nodeName) < 0 &&
                    window._UXK_Components.contents[childNode.nodeName] === undefined) {
                    continue;
                }
                if (!childNode.hasAttribute("_UXK_vKey")) {
                    childNode.setAttribute("_UXK_vKey", this.guid());
                }
                this.assignKeys(childNode);
            }
        },
        createTree: function (node, updatePropsOnly) {
            if (this.kVisualDOMNames.indexOf(node.nodeName) < 0 &&
                window._UXK_Components.contents[node.nodeName] === undefined) {
                return undefined;
            }
            var tree = {
                name: window._UXK_Components.contents[node.nodeName] !== undefined ? "VIEW" : node.nodeName,
                vKey: node.getAttribute("_UXK_vKey"),
                props: {},
                subviews: [],
            };
            for (var i = 0; i < this.kVisualDOMAttrs.length; i++) {
                var attr = this.kVisualDOMAttrs[i];
                if (node.hasAttribute(attr)) {
                    tree.props[attr] = node.getAttribute(attr);
                }
            }
            if (updatePropsOnly === true) {
                delete tree.subviews;
                return tree;
            }
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                var childNode = childNodes[i];
                var branch = this.createTree(childNode);
                if (branch !== undefined) {
                    tree.subviews.push(branch);
                }
            }
            return tree;
        },
        commitTree: function (node, updatePropsOnly) {
            try {
                webkit.messageHandlers.UXK_ViewUpdater.postMessage(JSON.stringify(this.createTree(node, updatePropsOnly)));
            } catch (err) {
                console.log("UXK_ViewUpdater not ready.");
            }
        },
        updateComponents: function (node) {
            if (window._UXK_Components.contents[node.nodeName] !== undefined) {
                if (node.getAttribute("_UXK_cKey") !== "_") {
                    node.innerHTML = window._UXK_Components.rendComponent(node.nodeName, {});
                    node.setAttribute("_UXK_cKey", "_");
                    var attributes = {};
                    for (var i = 0; i < node.attributes.length; i++) {
                        var element = node.attributes[i];
                        attributes[element.name] = element.value;
                    }
                    window._UXK_Components[node.nodeName].setProps(node, attributes);
                }
                else {
                    var attributes = {};
                    for (var i = 0; i < node.attributes.length; i++) {
                        var element = node.attributes[i];
                        attributes[element.name] = element.value;
                    }
                    window._UXK_Components[node.nodeName].setProps(node, attributes);
                }
            }
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                this.updateComponents(childNodes[i]);
            }
        },
    }
    $.fn.update = function (updatePropsOnly) {
        if (updatePropsOnly === true) {
            domHelper.commitTree(this.get(0), true);
        }
        else {
            domHelper.updateComponents(this.get(0));
            domHelper.assignKeys(this.get(0));
            domHelper.commitTree(this.get(0));
        }
    }
})(jQuery)