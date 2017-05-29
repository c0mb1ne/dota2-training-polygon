

var VERSION="beta_0.2"
var DEFAULT_DURATION = "300.0ms";
var DEFAULT_EASE = "linear";
var publish_url = "http://combine.pro.host1530666.serv66.hostland.pro/training.php";
var dev_url = 'http://training/training.php';
/* AnimatePanel
 * Animates a panel
 * 
 * Params:
 * 		panel 		- Panel to animate
 *		values 		- Dictionary containing the properties and values to animate.
 *					  Example: { "transform": "translateX(100);", "opacity": "0.5" }
 *		duration 	- The animation duration in seconds
 *		ease 		- Easing function to use. Example: "linear" or "ease-in"
 *		delay		- Time to wait before starting the animation in seconds
 */
function AnimatePanel(panel, values, duration, ease, delay)
{
	// generate transition string
	var durationString = (duration != null ? parseInt(duration * 1000) + ".0ms" : DEFAULT_DURATION);
	var easeString = (ease != null ? ease : DEFAULT_EASE);
	var delayString = (delay != null ? parseInt(delay * 1000) + ".0ms" : "0.0ms"); 
	var transitionString = durationString + " " + easeString + " " + delayString;

	var i = 0;
	var finalTransition = ""
	for (var property in values)
	{
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


var castpoint=0.95;
var manta=0.1;
var screenW=Game.GetScreenWidth();
var barW=Math.floor(screenW*0.8*0.6);
var TimeBar=$("#TimeBar")
var TimingBar=$("#Timing")
TimeBar.style.width=barW.toString()+"px";

var cursorPos=barW/2-29;
$("#cursor").style.marginLeft=cursorPos.toString()+"px";
var barTime=3.0;
var castbarW=barW/barTime*castpoint;
var mantaBarW=barW/barTime*manta;
var spellIconW=65;
var mainBarW=Math.floor(screenW*0.8);
var spellIconEnd=(mainBarW-barW)/2-spellIconW;
var spellIconStart=(mainBarW-barW)/2+barW+spellIconW;
var spellIcon=$("#myability");
changeSpellIcon("monkey_king_boundless_strike")
//spellIcon.style.marginLeft=(spellIconStart).toString()+"px";
var pixelTime=barW/barTime;
var spellDelay=pixelTime*spellIconW;
var showBar=true;
hideNotify();

rootpanel=$("#btnTest").GetParent()
rootpanel.style['visibility']='collapse';
rootpanel.style['opacity']='0';


function changeSpellIcon(spell){
	var panel=$("#myability");
	panel.abilityname=spell;
}

function iconAnimation2(spell,time){
	var panel=$("#myability");
	var distance=(barW+spellIconW);
	changeSpellIcon(spell)
	panel.style.marginLeft=(distance).toString()+"px";
	AnimatePanel(panel,{ "opacity": "1;" }, 1, "ease-in")
	AnimatePanel(panel, { "transform": "translateX(-"+(distance).toString()+"px);" }, time, "cubic-bezier(0,1,1,0)");
	$.Schedule(time-1, function(){AnimatePanel(panel,{ "opacity": "0;" }, 1);});
	$.Schedule(time, function(){AnimatePanel(panel,{ "transform": "translateX(0px);" }, 0.1);});
}

function HideUI(){
	var rootpanel=$("#btnTest").GetParent()
	AnimatePanel(rootpanel,{ "opacity": "0;" }, 0.5, "ease-in")
	$.Schedule(0.5, function(){rootpanel.style['visibility']='collapse';})
}
function ShowUI(){
	var rootpanel=$("#btnTest").GetParent()
	rootpanel.style['visibility']='visible'
	$.Schedule(0.5, function(){AnimatePanel(rootpanel,{ "opacity": "1;" }, 0.5, "ease-in");})
}





function onBtnTestClick(event){
	var player=Game.GetLocalPlayerID()
	$.Msg(player)
	var hero=Players.GetPlayerHeroEntityIndex(player);
	panel=$("#btnTest")
	AnimatePanel(panel,{ "opacity": "0;" }, 0.5, "ease-in")
	$.Schedule(0.5, function(){panel.visible=false;panel.enabled=false;})
	GameEvents.SendCustomGameEventToServer( "simple_game_start", { "player" : player, "key2" : "value2" } );
}
function onBtnTestClick2(event){
	
	iconAnimation2("queenofpain_scream_of_pain",barTime)

}
function onBtnTestClick3(event){
	//Game.EmitSound("good1")
	 Good()
}
function endCustomTraining(event){
	GameEvents.SendCustomGameEventToServer( "custom_manta_training_end", {} );
	HideUI()
}

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function voiceAnnounce(result){
	if(result==1){
		var i=getRandomInt(1,5)
		Game.EmitSound("good"+i.toString())
	}else{
		var i=getRandomInt(1,12)
		Game.EmitSound("bad"+i.toString())
	}
}

function showNotify(){
	$("#mantaNotify").RemoveClass("FadeOut");
	$("#mantaNotify").AddClass("FadeIn");
}
function hideNotify(){
	$("#mantaNotify").RemoveClass("FadeIn");
	$("#mantaNotify").AddClass("FadeOut");
}
function updateStreak(streak){
	$("#textTest").text=$.Localize( "#InARow" )+streak.toString();
}
function updateTopScore(info){
	streak=info.score
	//$("#bestScore").text="Best score: "+streak.toString();
}
function evasionControl(info){
	var success=info.how
	var streak=info.dodgestreak
	var skill=info.skillId
	var lives=info.lives
	var time=info.time
	var result=0
	updateStreak(streak)
	if (success=="good"){
		Good();
		result=1
	}else{
/*		if (lives==0){
			Lost();
		}else{*/
			if (time){
				Bad(time);
			}else{
				Bad();
			}
			
		}
		
	
	//addSkillData(skill,result)
}
function Good(){
	$("#notify").text=$.Localize( "#mantaGood" );
	$("#notify").style.color="#02ff06";
	$("#desc").text=""
	showNotify();
	//voiceAnnounce(1)
	$.Schedule(1,function(){hideNotify()});
}
function Bad(time){
	$("#notify").text=$.Localize( "#mantaBad" );
	if (time){
		$("#desc").text=time.toFixed(3)+" s"
	}else{
		$("#desc").text=""
	}
	$("#notify").style.color="#ff0202";
	showNotify();
	//voiceAnnounce(0)
	$.Schedule(1,function(){hideNotify()});
}
function Lost(){
	$("#notify").text="You lost";
	$("#notify").style.color="#ff0202";
	showNotify();
	$.Schedule(4,function(){hideNotify()});
}

function spellCasted(castpoint){

	var mantaBar = $("#manta");
	var spell=$("#spellBar");
	var castbarW=barW/barTime*castpoint;
	//$.Msg("***********animation starts*************");

	var epsilon=0.05

	startBarAnimation(spell,castpoint);
	$.Schedule(castpoint-manta+epsilon, function(){startBarAnimation(mantaBar,manta);});

}


function startBarAnimation(panel,time){	
	if (time>=barTime){
		var panelW=barW;
		animeOnTimeAppear(panel,barW,panelW,60,barTime);
		$.Schedule(time, function(){animeOnTimeDisappear(panel,barW,panelW,60,barTime);});
	}else{
		var panelW=barW/barTime*time;
		animeOnTimeAppear(panel,barW,panelW,60,time);
		$.Schedule(time, function(){animeOnTimeMove(panel,barW,panelW,60,barTime-time);});
		$.Schedule(barTime, function(){animeOnTimeDisappear(panel,barW,panelW,60,time);});	
	}
}
function scheduleCast(table){
	delay=table.delay;
	castpoint=table.castpoint;
	spell=table.abil
	if (showBar==true){
		$.Schedule(delay-barTime/2, function(){spellCasted(castpoint)});
	}
	$.Schedule(delay-barTime/2, function(){iconAnimation2(spell,barTime)});

}
function animeOnTimeAppear(panel,barW,castbarW,fps,duration){
	var startTime=Date.now();
	var endTime=duration*1000+startTime;
	var interval=1/fps;
	var start=0;
	var inc=0;
	var timeNow=0;
	var razn=startTime-endTime;
	var razn2=0;
	anime();
	function anime(){
		timeNow=Date.now();
		//$.Msg("starttime+timenow:")
		//$.Msg(startTime+timeNow)
		if (timeNow<=endTime){
			razn2=startTime-timeNow;
			inc=castbarW/(razn/razn2);
			draw(inc);
			$.Schedule(interval, function(){anime();})
		}
		else{
			var end2=Date.now();
			//$.Msg(panel.id.toString()+" app end in:");
			//$.Msg(end2-startTime);
		}
	}
	function draw(inc){
		panel.style["margin-left"]=(barW-inc).toString()+"px";
		panel.style["width"]=inc.toString()+"px";
	}

}
function animeOnTimeMove(panel,barW,castbarW,fps,duration){
	var startTime=Date.now();
	var endTime=duration*1000+startTime;
	var interval=1/fps;
	var start=barW-castbarW;
	var inc=0;
	var timeNow=0;
	var razn=startTime-endTime;
	var razn2=0;
	anime();
	function anime(){
		timeNow=Date.now();
		//$.Msg("starttime+timenow:")
		//$.Msg(startTime+timeNow)
		if (timeNow<=endTime){
			razn2=startTime-timeNow;
			inc=(start)/(razn/razn2);
			draw(inc);
			$.Schedule(interval, function(){anime();})
		}
		else{
			draw(start);
			var end2=Date.now();
			//$.Msg(panel.id.toString()+" move end in:");
			//$.Msg(end2-startTime);
			//$.Msg("start:");
			//$.Msg(start);
			//$.Msg("last inc:");
			//$.Msg(inc);
		}
	}
	function draw(inc){
		panel.style["margin-left"]=(start-inc).toString()+"px";
		if (start-inc<=cursorPos && start-inc+castbarW>=cursorPos){
			
		}else{
			
		}
		//panel.style["width"]=inc.toString()+"px";
	}
}
function animeOnTimeDisappear(panel,barW,castbarW,fps,duration){
	var startTime=Date.now();
	var endTime=duration*1000+startTime;
	var interval=1/fps;
	var start=0;
	var inc=0;
	var timeNow=0;
	var razn=startTime-endTime;
	var razn2=0;
	anime();
	function anime(){
		timeNow=Date.now();
		//$.Msg("starttime+timenow:")
		//$.Msg(startTime+timeNow)
		if (timeNow<=endTime){
			razn2=startTime-timeNow;
			inc=castbarW/(razn/razn2);
			draw(inc);
			$.Schedule(interval, function(){anime();})
		}
		else{
			draw(castbarW);
			var end2=Date.now();
			//$.Msg(panel.id.toString()+" disapp end in:");
			//$.Msg(end2-startTime);
		}
	}
	function draw(inc){
		//panel.style["margin-left"]=(barW-inc).toString()+"px";
		panel.style["width"]=(castbarW-inc).toString()+"px";
	}
}
function barChangeVisibleState(state){
	var panel=$("#Timing");
	if (!state){
		AnimatePanel(panel,{ "opacity": "0;" }, 0.5, "ease-in")
		$.Schedule(0.5, function(){panel.visible=false;panel.enabled=false;})
	}else{
		panel.visible=true
		panel.enabled=true
		AnimatePanel(panel,{ "opacity": "1;" }, 0.5, "ease-in")
	}
}




/*function addSkillData(skill,result){
	skills_arr.push(skill)
	result_arr.push(result)
	timebar_arr.push(showBar)
}*/
/*function endEvasionGame(info){
	Lost();
	score=info.score
	sendEvadeResult(score)
	panel=$("#btnTest")
	panel.visible=true
	panel.enabled=true
	AnimatePanel(panel,{ "opacity": "1;" }, 0.5, "ease-in")
}*/


/*function sendEvadeResult(score){
	var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID())
	var steamID64 = playerInfo.player_steamid
	var info={
		skill_name: skills_arr,
		result: result_arr,
		steam: steamID64.toString(),
		version: VERSION,
		timebar: timebar_arr,
		score: score,
		lang: $.Language()
	};

	$.AsyncWebRequest(publish_url,
        {
            type: 'POST',
            data: {info: JSON.stringify(info)},
            success: function (data) {
                $.Msg('cmb Reply: ', data)
            }
        });
}*/
function updateLives(info){
	lives=info.lives
	$("#livesLeft").text="Lives left: "+lives.toString();
}
function trainingStart(info){
	if (info.timebar==0){
		barChangeVisibleState(false)
	}else{
		barChangeVisibleState(true)
	}
	ShowUI();
	$.Msg("AHAHAHHAHAhA")
}


  GameEvents.Subscribe( "spell_casted", scheduleCast );
  GameEvents.Subscribe( "evasion_check", evasionControl );
  GameEvents.Subscribe( "top_score", updateTopScore );
  GameEvents.Subscribe( "update_lives", updateLives );
  //GameEvents.Subscribe( "end_evasion_game", endEvasionGame );
  GameEvents.Subscribe( "custom_training_start", trainingStart );


