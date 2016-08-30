(function (global, factory) {
    if (typeof define === "function" && define.amd) {
        define([
            "exports",
            "react"
        ], factory);
    } else if (typeof exports !== "undefined") {
        factory(exports, require("react"));
    } else {
        var mod = {
                exports: {}
            };

        factory(mod.exports, global.uis);
        global.componentEs6 = mod.exports;
    }
})(this, function (exports, react) {
    "use strict" Object.defineProperty(exports, "__esModule", {
        value: true
    });
    var React = react;


    /* Imported components */


    /** * Merges the attributes list `b` `[{name,value,add:bool}]` * into the attribute map `a` `{
     * :
     * Any    }`, with * a special handling of style attributes. */
    var _mergeAttributes = function (a, b) {
            var r = {};

            Object.assign(r, a || {});
            var res = (b || []).reduce(function (r, v) {
                    if (v) {
                        var k = v.name;

                        if (k === "style") {
                            r[k] = r[k] || {};
                            Object.assign(r[k], v.value);
                        } else if (v.add) {
                            r[k] = r[k] ? r[k] + " " + v.value : v.value;
                        } else {
                            r[k] = v.value;
                        }
                    }

                    return r;
                }, r);

            return res;
        };


    /** * Parses the given CSS line into a style attribute map. */
    var _parseStyle = function (style) {
            var n = document.createElement("div");

            n.setAttribute("style", style);
            var res = {};

            for (var i = 0; i < n.style.length; i ++) {
                var k = n.style[i];

                var p = k.split("-").map(function (v, i) {
                        return i == 0 ? v : v[0].toUpperCase() + v.substring(1)
                    }).join("");

                res[p] = n.style[k];
            }

            return res;
        };


    /** * Flattens at one level the list argument starting after the `skip`ed * element */
    var __flatten = function (list, skip) {
            skip = skip || 0;
            var res = list.reduce(function (r, e, i) {
                    if (i < skip) {
                        r.push(e);
                    } else if (e instanceof Array) {
                        r = r.concat(e);
                    } else {
                        r.push(e);
                    }

                    return r;
                }, []);

            return res;
        }

        var STYLES = {};


    /* View */
    exports.View = function (data, component) {
        var state = data;

        return (React.createElement("button", null, (this.state.label)))
    };
});
