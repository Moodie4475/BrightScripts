REM
REM @title               Sjabloon
REM @author              Lee Dydo
REM @co-author           Moodie4475
REM @date-created        15/03/2017
REM @date-last-modified  30/01/2023
REM @minimum-FW          1.0.0
REM
REM @description         Een handige sjabloon om als een basis te gebruiken.
REM                      Door ctr+f/cmd+f te doen kan je het woord "sjabloon" veranderen naar het woord wat jij wilt.

function sjabloon_Initialize(msgPort as object, userVariables as object, bsp as object)
    return {
        objectName: "sjabloon_object",
        msgPort: msgPort,
        userVariables: userVariables,
        bsp: bsp,
        ProcessEvent: function(event as object)
            'Ontvang een plug-in bericht
            if type(event) = "roAssociativeArray" then
                if type(event["EventType"]) = "roString"
                    if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
                        if event["PluginName"] = "sjabloon" then
                            pluginMessage$ = event["PluginMessage"]
                            'Geef true terug als u niet wilt dat andere gebeurtenisprocessors deze gebeurtenis afhandelen
                            return true
                        end if
                    end if
                end if
            end if

            'Stuur een plug-in bericht naar andere plug-ins en BrightAuthor-objecten
            if (false)
                pluginMessageCmd = {
                    EventType: "EVENT_PLUGIN_MESSAGE",
                    PluginName: "sjabloon",
                    PluginMessage: "empty"
                }
                m.msgPort.PostMessage(pluginMessageCmd)
            end if

            'Geef false terug als een andere plug-in of gebeurtenisprocessor de kans krijgt om deze gebeurtenis af te handelen
            return false
        end function
    }
end function