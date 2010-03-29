load = function()
	{
	load.getScript("jquery-1.2.6.js");
	load.tryReady(0);
	}

// dynamically load any javascript file.
load.getScript = function(filename)
	{
	var script = document.createElement('script')
	script.setAttribute("type","text/javascript")
	script.setAttribute("src", filename)
	if (typeof script!="undefined")
		document.getElementsByTagName("head")[0].appendChild(script)
	}

load.tryReady = function(time_elapsed)
	{
	// Continually polls to see if jQuery is loaded.
	if (typeof $ == "undefined")
		{ // if jQuery isn't loaded yet...
		if (time_elapsed <= 5000)
			{ // and we havn't given up trying...
			setTimeout("load.tryReady(" + (time_elapsed + 200) + ")", 200); // set a timer to check again in 200 ms.
			}
		else
			{
			alert("Timed out while loading jQuery.")
			}
		}
	else
		{
		// Any code to run after jQuery loads goes here!
		// for example:
		}
	}
