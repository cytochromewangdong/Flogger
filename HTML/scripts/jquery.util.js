/**
 * @filename jquery.util.js
 * @version 1.0
 * @author f.du
 * 
 * $.json2string(); //json to string 
 *
 * $.getUrlParams();  //get url params , return json object
 * 
 * $("box").createImage(src); //create img element 
 **/
(function($){
	//json to string
	$.json2string=function(obj){
		var t = typeof (obj);
		if (t != "object" || obj === null) {
			// simple data type
			if (t == "string") obj = '"'+obj+'"';
			return String(obj);
		}
		else {
			// recurse array or object
			var n, v, json = [], arr = (obj && obj.constructor == Array);
			for (n in obj) {
				v = obj[n]; t = typeof(v);
				if (t == "string"){
					v = '"'+v+'"';
				}else if (t == "object" && v !== null){
					v = $.json2string(v);
				}
				json.push((arr ? "" : '"' + n + '":') + String(v));
			}
			return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
		}
	};
	
	$.getUrlParams=function(){
		var hash={};
	
		var hashes = window.location.href.slice(window.location.href.lastIndexOf('?') + 1).split('&');
		
		for(var i = 0; i < hashes.length; i++)
		{
		  var obj = hashes[i].split('=');
		  hash[obj[0]]=obj[1];
		}
		
		return hash;
	};
	//创建图片
	$.fn.createImage=function(src){
		var that = $("<div id=\"image-box\" style=\"position:relative; width:100%; height: 100%;\" class=\"image-loading\"></div>");
		$(this).html(that);
		var image = document.createElement("img");
		//图片加载完成
		image.onload = function (e) { 
			var width = that.width(),height=that.height();
						
			var picWidth = this.width,picHeight=this.height;
			var per = 1;
			
			//计算缩放比例
			if(picWidth > width){
				per = picWidth/width;
			}else if(picHeight > height){
				per = picHeight/height;
			}
			
			if(per > 0){
				picWidth = picWidth/per ;
				picHeight = picHeight/per ;
			}
			$(this).css({
				"width":picWidth , 
				"height": picHeight, 
				"position":"absolute", 
				"top":((height-picHeight)/2)+"px", 
				"left":((width-picWidth)/2)+"px", 
				"-webkit-box-shadow": "0px 3px 5px #6A6A6A, 0px 0px 5px #6A6A6A"
			});
			
			that.html(image);
		};
		
		image.src = src;
	};
	

})(jQuery);
function getHeight(){
	return $("body").outerHeight();
};