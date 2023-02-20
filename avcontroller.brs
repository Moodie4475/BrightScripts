REM
REM @title               AVcontroller
REM @author              Moodie4475
REM @date-created        30/01/2023
REM @date-last-modified  30/01/2023
REM @minimum-FW          8.0.119
REM
REM @description         Controller plugin voor zones

function avcontroller_Initialize(msgPort as object, userVariables as object, bsp as object)
	return {
		objectName: "avcontroller_object",
		msgPort: msgPort,
		userVariables: userVariables,
		bsp: bsp,
		ProcessEvent: function(event as object)
			if type(event) = "roAssociativeArray" then
				if type(event["EventType"]) = "roString"
					if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
						if event["PluginName"] = "avcontroller" then
							pluginMessage$ = event["PluginMessage"]
							return true
						end if
					end if
				end if
			end if

			'Send a plugin message to other plugins and BrightAuthor Objects
			if (false)
				pluginMessageCmd = {
					EventType: "EVENT_PLUGIN_MESSAGE",
					PluginName: "avcontroller",
					PluginMessage: "empty"
				}
				m.msgPort.PostMessage(pluginMessageCmd)
			end if

			return false
		end function
	}
end function

function ParsePluginMessage(message as object, s as object)
	retval = false
	command = " "

	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: " + msg
	r = CreateObject("roRegex", "^setup", "i")
	match = r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields = r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			s.mylog("Incorrect number of fields for downplay command:" + msg)
			return retval
		else if (numFields = 2) then
			command = fields[1]
		end if
	end if

	s.mylog("command found: " + command)

	if command = "debug" then
		s.mylog("Debug Enabled")
		s.debug = true
	else if command = "reboot" then
		s.mylog("Rebooting")
		rebootsystem()
	else if command = "unit"
		s.change()
	end if

	return retval
end function