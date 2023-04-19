return function(browserName)
	local function open()
		hs.application.launchOrFocus(browserName)
	end
	local function jump(url)
		local script = ([[
  (function() {
    var brave = Application('%s');
    brave.activate();

    for (win of brave.windows()) {
      var tabIndex =
        win.tabs().findIndex(tab => tab.url().match(/%s/));

      if (tabIndex != -1) {
        win.activeTabIndex = (tabIndex + 1);
        win.index = 1;
      }
    }
  })();
  ]]):format(browserName, url)

		print(script)
		hs.osascript.javascript(script)
	end
	return { open = open, jump = jump }
end
