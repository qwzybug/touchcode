/* 
 Resize images to fit within iPhone width
 Also create RunOnLoad, which is better than JQuery's .ready()
 */
var max_width = 280;
function runOnLoad(f) {
    if (runOnLoad.loaded) f();
    else runOnLoad.funcs.push(f);
}
runOnLoad.funcs = [];
runOnLoad.loaded = false;
runOnLoad.run = function() {
    if (runOnLoad.loaded) return;
	
    for(var i = 0; i < runOnLoad.funcs.length; i++) {
        try { runOnLoad.funcs[i](); }
        catch(e) { }
    }
    runOnLoad.loaded = true;
    delete runOnLoad.funcs;
    delete runOnLoad.run;
};

if (window.addEventListener)
window.addEventListener("load", runOnLoad.run, false);
else if (window.attachEvent) window.attachEvent("onload", runOnLoad.run);
else window.onload = runOnLoad.run;

// JQuery's .ready() triggers before images are fully loaded. We don't want that.
runOnLoad(function() {
	rescale_items();
});
function rescale_items()
{
    var item_width, item_height, new_height, item_ratio, container_width, local_max_width;
	$('img, embed, object').each(function()
	{
		item_width = $(this).width();
		container_width = $(this).parent().width();
		local_max_width = max_width;
		if(container_width < max_width)
	        local_max_width = container_width;
		if(item_width > local_max_width) 
		{
			item_height = $(this).height();
			item_ratio = item_width / item_height;
			new_height = local_max_width / item_ratio;
			$(this).width(local_max_width).height(new_height);
		}

		$(this).show();
	});
}