function AnimatePanel(panel, values, duration, ease, delay) {
	// generate transition string
	var durationString = (duration != null ? parseInt(duration * 1000) + ".0ms" : DEFAULT_DURATION);
	var easeString = (ease != null ? ease : DEFAULT_EASE);
	var delayString = (delay != null ? parseInt(delay * 1000) + ".0ms" : "0.0ms"); 
	var transitionString = durationString + " " + easeString + " " + delayString;

	var i = 0;
	var finalTransition = ""
	for (var property in values) {
		// add property to transition
		finalTransition = finalTransition + (i > 0 ? ", " : "") + property + " " + transitionString;
		i++;
	}

	// apply transition
	panel.style.transition = finalTransition + ";";

	// apply values
	for (var property in values)
		panel.style[property] = values[property];
}



rootpanel = $("#btnEnd").GetParent()
rootpanel.style['visibility'] = 'collapse';
rootpanel.style['opacity'] = '0';
$("#eulTimer").style['visibility'] = 'collapse';
$("#eulTimer").style['opacity'] = '0';
$("#lvlChanger").style['visibility'] = 'collapse';
$("#lvlChanger").style['opacity'] = '0';

function ChangeAbilityLvl(param) {
	if(param === 1)
		GameEvents.SendCustomGameEventToServer("euls_change_ability_lvl", {plus : 1});
	else
		GameEvents.SendCustomGameEventToServer("euls_change_ability_lvl", {plus : 0});
}

function HideUI() {
	rootpanel = $("#btnEnd").GetParent()
	AnimatePanel (
		rootpanel,
		{
			"opacity": "0;"
		},
		0.5,
		"ease-in"
	)
	$.Schedule(0.5, function() {
		rootpanel.style['visibility'] = 'collapse';
	})
}

function ShowUI() {
	rootpanel = $("#btnEnd").GetParent()
	rootpanel.style['visibility'] = 'visible'
	$.Schedule(0.5, function() {
		AnimatePanel (
			rootpanel,
			{
				"opacity": "1;"
			},
			0.5,
			"ease-in"
		);
	})
}

function voiceAnnounce(type) {
	if(type=="good")
		Game.EmitSound("eul_good_" + getRandomInt(1,23))
	if(type=="bad")
		Game.EmitSound("eul_bad_" + getRandomInt(1,5))
	if(type=="start_lina")
		Game.EmitSound("eul_start_game_5")
	if(type=="start_techies")
		Game.EmitSound("eul_start_game_6")
	if(type=="start")
		Game.EmitSound("eul_start_game_" + getRandomInt(1,4))
}

function getRandomInt(min, max) {
	return Math.floor(Math.random() * (max - min)) + min;
}

function eulTrainingStarted(info) {
	castpoint = info.castpoint
	eul = info.bartime
	barw = 300
	markerMargin = Math.floor(barw - (barw * castpoint) / eul)
	$("#barMarker").style["margin-top"] = "42px"
	$("#barMarker").style["margin-left"] = markerMargin + "px"
	//$("#barMarker").style["width"] = epsW + "px"
	$("#barMarker").style["width"]="100%"
	ShowUI()
	/*
	if (info.id!=4 && info.id!=6)
		voiceAnnounce("start")
	if (info.id==4)
		voiceAnnounce("start_techies")
	if (info.id==6)
		voiceAnnounce("start_lina")
	*/
	$("#btnEnd").SetPanelEvent("onactivate", endEulTraining)
	if (info.id === 420)
		$("#btnEnd").SetPanelEvent("onactivate", endAlcheTraining)
	if ([8,18,21,24].indexOf(info.id) !== -1) {
		$("#lvlChanger").style['visibility'] = 'visible';
		$("#lvlChanger").style['opacity'] = '1';
	} else {
		$("#lvlChanger").style['visibility'] = 'collapse';
		$("#lvlChanger").style['opacity'] = '0';
	}
	if(info.timebar === 0) {
		$("#eulTimer").style['visibility'] = 'collapse';
		$("#eulTimer").style['opacity'] = '0';
	} else {
		$("#eulTimer").style['visibility'] = 'visible';
		$("#eulTimer").style['opacity'] = '1';
	}
}
//----------------------------------------------------------------------------------------------------glimpse training

function glimpseTrainingStarted(info) {
	ShowUI()
	if(info.timebar === 0) {
		$("#eulTimer").style['visibility'] = 'collapse';
		$("#eulTimer").style['opacity'] = '0';
	} else {
		$("#eulTimer").style['visibility'] = 'visible';
		$("#eulTimer").style['opacity'] = '1';
	}
	$("#btnEnd").SetPanelEvent (
		"onactivate", 
		function() {
			HideUI()
			GameEvents.SendCustomGameEventToServer("end_glimpse", {});
		}
	)
}

function startGlimpseTimer(info) {
	castpoint = info.castpoint
	//$.Msg(castpoint)
	travel = info.bartime
	barw = 300
	markerMargin = Math.floor(barw - (barw * castpoint) / travel)
	$("#barMarker").style["margin-left"] = markerMargin + "px"
	$("#barMarker").style["margin-top"] = "42px"
	//$("#barMarker").style["width"] = epsW.toString()+"px"
	$("#barMarker").style["width"] = "100%"
	animateOnTimeAppear($("#barDynamic"), barw, 60, info.bartime)
}
//----------------------------------------------------------------------------------------------------glimpse training end
hideNotify()
//showNotify()


function endEulTraining() {
	HideUI()
	GameEvents.SendCustomGameEventToServer("euls_end", {});
}
function endAlcheTraining() {
	HideUI()
	GameEvents.SendCustomGameEventToServer("alche_end", {});
}


function startTimer(info) {
	animateOnTimeAppear($("#barDynamic"), barw, 60, info. time)
}


function eulResult(info) {
	//$.Msg(Game.Time())
	//$.Msg("infobad: ", info.bad)
	//$.Msg("infotime: ", info.time)
	if (info.bad === 1) {
		$("#desc").text = ""
		if(info.time==420) {
			//$("#desc").text=$.Localize("#mantaBad")
		} else {
			//$("#desc").text=$.Localize("#mantaBad")
		}
		Bad()
	} else {
		if (info.time < 0.25) {
			if (info.time === 0) {
				$("#desc").text = $.Localize("#eulDesc") + info.time.toString().substring(0,5) + " sec."
				Perfect()
			} else {
				$("#desc").text = $.Localize("#eulDesc") + info.time.toString().substring(0,5) + " sec."
				Good()
			}
		} else if(info.time === 420) {
			$("#desc").text = ""
			Good()
		} else {
			$("#desc").text = $.Localize("#eulDesc") + info.time.toString().substring(0,5) + " sec."
			Bad()
		}
	}
}



function showNotify() {
	$("#eulNotification").RemoveClass("FadeOut");
	$("#eulNotification").AddClass("FadeIn");
}
function hideNotify() {
	$("#eulNotification").RemoveClass("FadeIn");
	$("#eulNotification").AddClass("FadeOut");
}
function Good() {
	$("#header").text=$.Localize("#mantaGood");
	$("#eulNotification").style.color = "#02ff06";
	showNotify();
	//voiceAnnounce("good")
	$.Schedule (2, hideNotify);
}
function Bad() {
	$("#header").text = $.Localize( "#mantaBad" );
	$("#eulNotification").style.color="#ff0202";
	showNotify();
	//voiceAnnounce("bad")
	$.Schedule(2, hideNotify);
}
function Perfect() {
	$("#header").text = $.Localize("#notifyPerfect");
	$("#eulNotification").style.color = "#02ff06";
	showNotify();
	//voiceAnnounce("good")
	$.Schedule(2, hideNotify);
}

function animateOnTimeAppear(panel, castbarW, fps, duration) {
	var startTime = Date.now();
	var endTime = duration * 1000 + startTime;
	var interval = 1 / fps;
	var start=0;
	var inc=0;
	var timeNow=0;
	var razn = startTime - endTime;
	var razn2=0;
	animate();
	function animate() {
		timeNow = Date.now();
		//$.Msg("starttime + timenow = " + (startTime + timeNow))
		if (timeNow <= endTime) {
			razn2 = startTime - timeNow;
			inc = castbarW / (razn / razn2);
			draw(inc, razn2);
			$.Schedule(interval, animate)
		} else {
			var end2 = Date.now();
			panel.style["width"] = "0px";
			$("#timerText").text = "0.000";
			//$.Msg(panel.id.toString() + " app end in " + (end2 - startTime));
		}
	}
	function draw(inc) {
		//panel.style["margin-left"] = (barW - inc).toString() + "px";
		panel.style["width"] = inc.toString() + "px";
		$("#timerText").text = ((razn2 + (duration * 1000)) / 1000).toFixed(3);
	}

}
function pingOnMinimap(event) {
	GameUI.PingMinimapAtLocation(event.respawn_place)
}
function travelReminder(event) {
	$("#header").text=$.Localize( "#tpReminder" );
	$("#eulNotification").style.color="#dd833e";
	$("#desc").text=""
	showNotify();
	//voiceAnnounce("bad")
	$.Schedule(2,function(){hideNotify()});
}

 GameEvents.Subscribe("eul_training_started", eulTrainingStarted);
 GameEvents.Subscribe("eul_casted", startTimer);
 GameEvents.Subscribe("glimpse_training_started", glimpseTrainingStarted);
 GameEvents.Subscribe("glimpse_casted", startGlimpseTimer);
 GameEvents.Subscribe("eul_result", eulResult);
 GameEvents.Subscribe("ping_on_minimap", pingOnMinimap);
 GameEvents.Subscribe("travel_reminder", travelReminder);
