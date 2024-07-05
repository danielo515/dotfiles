return function(browserName)
	local function open()
		hs.application.launchOrFocus(browserName)
	end
	local function jump(url)
		local script = ([[(function() {
      var browser = Application('%s');
      browser.activate();

      for (win of browser.windows()) {
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

	local function tabById(tabId)
		if not tabId then
			hs.alert("No tab ID provided")
			return
		end
		local script = ([[(function() {
      var browser = Application('%s');

      for (win of browser.windows()) {
        var tabIndex =
          win.tabs().findIndex(tab => tab.id() == "%s");

        if (tabIndex != -1) {
          browser.activate();
          win.activeTabIndex = (tabIndex + 1);
          win.index = 1;
        }
      }
    })();
  ]]):format(browserName, tabId)

		print(script)
		hs.osascript.javascript(script)
	end

	---gathers all the browser tabs, with ID (so you can jump to them) and title, in case you need them for displaying
	local function getTabs()
		local script = ([[(function () {
      const browser = Application("%s");
      const tabs = [];

      for (win of browser.windows()) {
      for (let tab of win.tabs()) {
      tabs.push({ id: tab.id(), title: tab.title() });
      }
      }
      return tabs;
      })();
    ]]):format(browserName)

		print(script)
		return hs.osascript.javascript(script)
	end
	return { open = open, jump = jump, tabById = tabById, getTabs = getTabs }
end
