--[[
*	main.lua
*
*
]]

local wx 		= require("wx")
local mainWin	= require("lib.window")			-- GUI for the application
local trace 	= require("lib.trace")

local _frmt		= string.format
local _floor	= math.floor

-- ----------------------------------------------------------------------------
--
local m_trace = trace.new("wxSkeleton")

-- ----------------------------------------------------------------------------
--
local m_App = 
{
	sAppVersion	= "0.0.1",				-- application's version
	sAppName	= "wxSkeleton",			-- name for the application
	sRelDate 	= "2021/08/26",
	
	tPoints		= { },					-- list of points
}

_G.m_App = m_App						-- make it globally visible

-- ----------------------------------------------------------------------------
--


-- ----------------------------------------------------------------------------
--


-- ----------------------------------------------------------------------------
--
local function RunApplication()

	local sAppTitle = m_App.sAppName .. " [" .. m_App.sAppVersion .. "]"
	
	m_trace:open()
	m_trace:time(sAppTitle .. " started")
	
	assert(os.setlocale('us', 'all'))
	m_trace:line("Current locale is [" .. os.setlocale() .. "]")

	wx.wxGetApp():SetAppName(sAppTitle)

	if mainWin.CreateMainWindow(sAppTitle) then
		
		mainWin.ShowMainWindow()
	end

	m_trace:newline(sAppTitle .. " terminated ###")
	m_trace:close()
end

-- ----------------------------------------------------------------------------
--
local function SetupPublic()


end

-- ----------------------------------------------------------------------------
--
SetupPublic()
RunApplication()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
