function udp_Initialize(msgPort as object, userVariables as object, bsp as object)

	print "udp_Initialize - entry"

	udp = newudp(msgPort, userVariables, bsp)

	return udp

end function


function newudp(msgPort as object, userVariables as object, bsp as object)
	print "newudp"

	s = {}
	s.version = 0.1
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = udp_ProcessEvent
	s.objectName = "udp_object"
	s.debug = false
	return s
end function


function udp_ProcessEvent(event as object) as boolean
	print "processing event udp plugin"
	retval = false

	if type(event) = "roAssociativeArray" then
		if type(event["EventType"]) = "roString" then
			if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then
				if event["PluginName"] = "udp" then
					pluginMessage$ = event["PluginMessage"]
					print "SEND_PLUGIN/EVENT_MESSAGE:";pluginMessage$
					retval = ParseudpPluginMsg(pluginMessage$, m)
				end if
			end if
		end if
	else if type(event) = "roDatagramEvent" then
		msg$ = event
		if (left(msg$, 3) = "udp") then
			retval = ParseudpPluginMsg(msg$, m)
		end if
	end if

	return retval

end function


function ParseudpPluginMsg(originalMsg as string, s as object) as boolean
	print "Parseudp function"
	retval = false
	command = ""

	' convert the message to all lower case for easier string matching later
	msg = lcase(originalMsg)
	print "Received Plugin message: " + msg
	r = CreateObject("roRegex", "^udp", "i")
	match = r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields = r2.split(originalMsg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			print "Error: Incorrect number of fields for udp command:";originalMsg
			return retval
		else if (numFields = 2) then
			command = fields[1]
			print "two fields found "; command

			targetIp = s.userVariables.Lookup("udp_ip")
			targetPort = s.userVariables.Lookup("udp_port")

			newPort = int(targetPort)

			' Check if variables exist
			if targetIp = invalid then
				print "Error: Expected variable udp_ip to exist"
				return retval
			end if

			if targetPort = invalid then
				print "Error: Expected variable udp_port to exist"
				stop
			end if

			if type(s.bsp.udpsender) <> "roDatagramSender" then
				print "creating udp sender"
				s.bsp.udpSender = createobject("roDatagramSender")
				print "Created udp sender succesfully"
			end if

			print "Updating udp destination"
			s.bsp.udpSender.SetDestination(targetIp, newPort)

			s.bsp.udpSender.Send(command)
		end if

	end if

	if command = "debug" then
		s.debug = true
	end if

	return retval
end function