--[[
*	window.lua
*
*
]]

local wx 	= require("wx")
local trace = require("lib.trace")

local _frmt		= string.format
local _floor	= math.floor


-- ----------------------------------------------------------------------------
--
local m_trace = trace.new("wxSkeleton")

-- ----------------------------------------------------------------------------
--
local m_App = nil

-- ----------------------------------------------------------------------------
-- default dialog size and position
--
local m_tDefWinProp =
{
	window_xy	= {20,	 20},			-- top, left
	window_wh	= {990,	580},			-- width, height
	use_font	= {12, "Calibri"},		-- font for grid and tab
}

-- ----------------------------------------------------------------------------
--
local m_Mainframe =
{
	hWindow		= nil,					-- main frame
	
	tWinProps	= m_tDefWinProp,		-- window layout settings
}

-- ----------------------------------------------------------------------------
--
local function OnImport()
	m_trace:line("OnImport")
	
end

-- ----------------------------------------------------------------------------
--
local function OnSave()
	m_trace:line("OnSave")
	
end

-- ----------------------------------------------------------------------------
-- Simple interface to pop up a message
--
local function DlgMessage(inMessage)

	wx.wxMessageBox(inMessage, m_App.sAppName,
					wx.wxOK + wx.wxICON_INFORMATION, m_Mainframe.hWindow)
end

-- ----------------------------------------------------------------------------
--
local function OnAbout()

	DlgMessage(_frmt(	"%s [%s] Rel. date [%s]\n %s, %s, %s",
						m_App.sAppName, m_App.sAppVersion, m_App.sRelDate,
						_VERSION, wxlua.wxLUA_VERSION_STRING, wx.wxVERSION_STRING))
end

-- ----------------------------------------------------------------------------
-- Generate a unique new wxWindowID
--
local ID_IDCOUNTER = wx.wxID_HIGHEST + 1
local NewMenuID = function()
	
	ID_IDCOUNTER = ID_IDCOUNTER + 1
	return ID_IDCOUNTER
end

-- ----------------------------------------------------------------------------
-- create a filename just for the machine running on
--
local function SettingsName()
	
	return "wxSkeleton@" .. wx.wxGetHostName() .. ".ini"
end

-- ----------------------------------------------------------------------------
-- read dialogs' settings from settings file
--
local function ReadSettings()
	m_trace:line("ReadSettings")

	local sFilename = SettingsName()

	local fd = io.open(sFilename, "r")
	if not fd then return end

	fd:close()

	local tSettings = dofile(sFilename)

	if tSettings then m_Mainframe.tWinProps = tSettings end
end

-- ----------------------------------------------------------------------------
-- save a table to the settings file
--
local function SaveSettings()
	m_trace:line("SaveSettings")

	local fd = io.open(SettingsName(), "w")
	if not fd then return end

	fd:write("local window_ini =\n{\n")

	local tWinProps = m_Mainframe.tWinProps
	local sLine

	sLine = _frmt("\twindow_xy\t= {%d, %d},\n", tWinProps.window_xy[1], tWinProps.window_xy[2])
	fd:write(sLine)

	sLine = _frmt("\twindow_wh\t= {%d, %d},\n", tWinProps.window_wh[1], tWinProps.window_wh[2])
	fd:write(sLine)

	sLine = _frmt("\tuse_font\t= {%d, \"%s\"},\n", tWinProps.use_font[1], tWinProps.use_font[2])
	fd:write(sLine)
	
	fd:write("}\n\nreturn window_ini\n")
	io.close(fd)
end

-- ----------------------------------------------------------------------------
--
local function OnSize(event)
	m_trace:line("OnSize")
	
	
	event:Skip()
end

-- ----------------------------------------------------------------------------
-- called when closing the window
--
local function OnCloseMainframe()
	m_trace:line("OnCloseMainframe")

	if not m_Mainframe.hWindow then return end

	-- need to convert from size to pos
	--
	local pos  = m_Mainframe.hWindow:GetPosition()
	local size = m_Mainframe.hWindow:GetSize()

	-- update the current settings
	--
	local tWinProps = { }

	tWinProps.window_xy = {pos:GetX(), pos:GetY()}
	tWinProps.window_wh = {size:GetWidth(), size:GetHeight()}
	tWinProps.use_font	= m_Mainframe.tWinProps.use_font				-- just copy over
	tWinProps.dpi_scale	= m_Mainframe.tWinProps.dpi_scale				-- "	"	"	"

	m_Mainframe.tWinProps = tWinProps			-- switch structures
	
	SaveSettings()								-- write to file

	m_Mainframe.hWindow.Destroy(m_Mainframe.hWindow)
	m_Mainframe.hWindow = nil
end

-- ----------------------------------------------------------------------------
-- show the main window and runs the main loop
--
local function ShowMainWindow()
	m_trace:line("ShowMainWindow")

	if not m_Mainframe.hWindow then return end

	m_Mainframe.hWindow:Show(true)
	
	-- run the main loop
	--
	wx.wxGetApp():MainLoop()
end

-- ----------------------------------------------------------------------------
--
local function CloseMainWindow()
	m_trace:line("CloseMainWindow")
	
	if m_Mainframe.hWindow then OnCloseMainframe() end
end

-- ----------------------------------------------------------------------------
-- create a window
--
local function CreateMainWindow(inAppTitle)
	m_trace:line("CreateMainWindow")

	-- store the application's handle
	--
	m_App = _G.m_App
	
	ReadSettings()

	local tWinProps = m_Mainframe.tWinProps

	local pos  = tWinProps.window_xy
	local size = tWinProps.window_wh
	
	-- create the frame
	--
	local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, inAppTitle,
							 wx.wxPoint(pos[1], pos[2]), wx.wxSize(size[1], size[2]))
	frame:SetMinSize(wx.wxSize(300, 250))
	
	-- ------------------------------------------------------------------------
	-- create the menus
	--
	local rcMnuImportFile	= NewMenuID()
	local rcMnuSaveFile		= NewMenuID()


	local mnuFile = wx.wxMenu("", wx.wxMENU_TEAROFF)

	mnuFile:Append(rcMnuImportFile,	"Import\tCtrl-I",	"Read the settings file")
	mnuFile:Append(rcMnuSaveFile,	"Save\tCtrl-S",		"Write the settings file")
	mnuFile:AppendSeparator()
	mnuFile:Append(wx.wxID_EXIT,    "E&xit\tAlt-X",		"Quit the program")
	
	local mnuEdit = wx.wxMenu("", wx.wxMENU_TEAROFF)

	
	local mnuHelp = wx.wxMenu("", wx.wxMENU_TEAROFF)
	mnuHelp:Append(wx.wxID_ABOUT,    "&About",			"About the application")

	-- create the menu bar and associate sub-menus
	--
	local mnuBar = wx.wxMenuBar()

	mnuBar:Append(mnuFile,	"&File")
	mnuBar:Append(mnuEdit,	"&Edit")
	mnuBar:Append(mnuHelp,	"&Help")

	frame:SetMenuBar(mnuBar)

	-- assign event handlers for this frame
	--
	frame:Connect(wx.wxEVT_SIZE,		 OnSize)
	frame:Connect(wx.wxEVT_CLOSE_WINDOW, OnCloseMainframe)
	
	-- menu event handlers
	--
	frame:Connect(rcMnuImportFile,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnImport)
	frame:Connect(rcMnuSaveFile,	wx.wxEVT_COMMAND_MENU_SELECTED,	OnSave)
	
	frame:Connect(wx.wxID_EXIT,		wx.wxEVT_COMMAND_MENU_SELECTED, OnCloseMainframe)
	frame:Connect(wx.wxID_ABOUT,	wx.wxEVT_COMMAND_MENU_SELECTED, OnAbout)
	
	-- assign an icon to frame
	--
	local icon = wx.wxIcon("lib/icons/Neko.ico", wx.wxBITMAP_TYPE_ICO)
	frame:SetIcon(icon)

	-- store interesting members
	--
	m_Mainframe.hWindow	= frame

	return true
end

-- ----------------------------------------------------------------------------
-- associate functions
--
local function SetupPublic()

	m_Mainframe.CreateMainWindow	= CreateMainWindow
	m_Mainframe.ShowMainWindow		= ShowMainWindow
	m_Mainframe.CloseMainWindow		= CloseMainWindow
end

-- ----------------------------------------------------------------------------
--
SetupPublic()

return m_Mainframe

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
