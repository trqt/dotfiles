config.load_autoconfig(False)

c.content.webgl = False
c.content.cookies.accept = 'no-3rdparty'
c.content.headers.user_agent =  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36'
c.content.javascript.enabled = False


import catppuccin

# set the flavor you'd like to use
# valid options are 'mocha', 'macchiato', 'frappe', and 'latte'
# last argument (optional, default is False): enable the plain look for the menu rows
catppuccin.setup(c, 'mocha', True)
c.colors.webpage.darkmode.enabled = True
