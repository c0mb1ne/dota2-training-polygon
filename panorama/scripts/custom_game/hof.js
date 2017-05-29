

var playerID=Players.GetLocalPlayer()







function checkForSelecting(interval){

	checking();
	function checking(){
		var selectedUnits=Players.GetSelectedEntities(playerID)
		$.Msg(selectedUnits)
		$.Schedule(interval, function(){checking();})
	}

}

checkForSelecting(0.5)