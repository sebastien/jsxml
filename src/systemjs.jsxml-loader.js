// ----------------------------------------------------------------------------
// Project           : JSXML
// ----------------------------------------------------------------------------
// Author            : FFunction
// License           : License
// ----------------------------------------------------------------------------
// Creation date     : 2016-08-29
// Last modification : 2016-08-29
// ----------------------------------------------------------------------------

'use strict';

let JSXML_XSL_URL = "https://cdn.rawgit.com/sebastien/jsxml/master/dist/jsxml.xsl"
let RE_STYLESHEET = new RegExp("<\\?xml-stylesheet\\s+(.+)\\?>", "m");
let PROCESSORS    = {};

// ----------------------------------------------------------------------------
//
// XSL LOADING HELPERS
//
// ----------------------------------------------------------------------------

/**
 * Returns the URL of the XSL stylesheet defined in the given source
 * code.
*/
function getXSLURL ( text ) {
	let div   = document.createElement("div");
	let match = RE_STYLESHEET.exec(text);
	if (match) {
		div.innerHTML = "<div " + match[1] + "></div>";
		return div.firstChild.getAttribute("href");
	} else {
		return JSXML_XSL_URL;
	}
}

/**
 * Loads the XSLT processor for the stylesheet at the given URL. This returns
 * a resolved promise with the given processor, ready to transform a fragment.
*/
function loadXSLProcessor( url ) {
	if (!PROCESSORS[url]) {
		/* NOTE: We can't use `fetch()` here as somehow a DOMParser'ed 
		 * response.text() from fetch will result in an encoding error
		 * when the stylesheet contains an xsl:import, but the
		 * XMLHttpRequest works perfectly here.
		*/
		let res = new Promise(function(resolve,reject){
			let xsl = new XSLTProcessor();
			let req = new XMLHttpRequest();
			req.addEventListener("load", function(event){
				if (event.target.readyState == 4) {
					if (event.target.status >= 400) {
						return reject(console.error("jsxml: Could not find stylesheet", url , ":", response.url));
					} else {
						xsl.importStylesheet(event.target.responseXML);
						PROCESSORS[url] = xsl;
						return resolve(xsl);
					}
				}
			})
			req.open("GET", url);
			req.send();
		})
		return res;
	} else {
		return Promise.resolve(PROCESSORS[url]);
	}
}

/**
 * Translates the JSXML document represented by the give source text
 * and returns the corresponding JavaScript content.
*/
function translateJSXML( text ) {
	let url = getXSLURL(text);
	return loadXSLProcessor(url).then( function(processor) {
		let node = new window.DOMParser().parseFromString(text, "text/xml");
		let res  = processor.transformToFragment(node, document);
		if (!res) {
			console.error("jsxml: Could not transform document using styleseet", url);
			return null;
		} else {
			return res.textContent;
		}
	})
}

// ----------------------------------------------------------------------------
//
// SYSTEM JS HOOKS
//
// ----------------------------------------------------------------------------

/**
 * Fetches and translates the module, and asynchronously gets the XSL 
 * stylesheet. Technically, this should only fetch, but as translate
 * does not seem to take Promises, it's easier like this.
*/
exports.fetch    = function(source) {
	return fetch(source.address).then(function(response){
		return response.text()
	}).then(function(text){
		return translateJSXML(text);
	})
}

/**
 * Returns the XML translated to JavaScript
*/
exports.translate = function(load) {
	return load.source;
};

/* EOF */
