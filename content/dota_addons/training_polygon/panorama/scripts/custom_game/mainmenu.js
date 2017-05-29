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

setPlayerName()

var skills=["alchemist_unstable_concoction",
			"leshrac_split_earth",
			"invoker_sun_strike",
			"kunkka_torrent",
			"kunkka_tidebringer",
			"elder_titan_earth_splitter",
			"roshan_slam",
			"lina_light_strike_array",
			"kunkka_ghostship",
			"lina_laguna_blade",
			"bloodseeker_blood_bath",
			"pugna_nether_blast",
			"meepo_poof",
			"necrolyte_death_pulse",
			"mirana_starfall",
			"nevermore_shadowraze1",
			"nevermore_shadowraze2",
			"nevermore_shadowraze3",
			"zuus_lightning_bolt",
			"zuus_thundergods_wrath",
			"tidehunter_anchor_smash",
			"ursa_earthshock",
			"omniknight_purification",
			"alchemist_unstable_concoction",
			"skywrath_mage_arcane_bolt",
			"medusa_mystic_snake",
			"medusa_stone_gaze",
			"medusa_stone_gaze",
			"medusa_stone_gaze",
			"techies_suicide",
			"monkey_king_boundless_strike",
			"shadow_demon_demonic_purge",
			"earthshaker_fissure",
			"earthshaker_enchant_totem",
			"earthshaker_enchant_totem",
			"invoker_emp",
			"obsidian_destroyer_sanity_eclipse",
			"undying_decay","elder_titan_echo_stomp",
			"rattletrap_rocket_flare",
			"rattletrap_hookshot",
			"rattletrap_hookshot",
			"rattletrap_hookshot",
			"windrunner_powershot",
			"huskar_life_break",
			"gyrocopter_homing_missile",
			"tiny_toss",
			"phoenix_supernova",
			"legion_commander_overwhelming_odds",
			"magnataur_reverse_polarity",
			"slardar_slithereen_crush",
			"axe_berserkers_call",
			"brewmaster_thunder_clap",
			"centaur_hoof_stomp",
			"lion_finger_of_death",
			"queenofpain_scream_of_pain",
			"monkey_king_primal_spring",
			"visage_summon_familiars_stone_form",
			"polar_furbolg_ursa_warrior_thunder_clap",
			"centaur_khan_war_stomp",
			"spawnlord_master_stomp",
			"obsidian_destroyer_astral_imprisonment"]
var ids=[420,61,57,58,59,60,54,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,55,56,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53]
var skillPanel=$('#skillList')
var skillCount=ids.length

var eul_ids=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,23,24,25]
var eul_skills=[  "kunkka_torrent",
          		  "nevermore_requiem",
	              "invoker_sun_strike",
	              "elder_titan_echo_stomp",
	              "techies_suicide",
	              "death_prophet_silence",
	              "lina_light_strike_array",
	              "earthshaker_fissure",
	              "earthshaker_enchant_totem",
	              "leshrac_split_earth",
	              "slardar_slithereen_crush",
	              "centaur_hoof_stomp",
	              "bloodseeker_blood_bath",
	              "earthshaker_enchant_totem",
	              "lion_impale",
	              "nyx_assassin_impale",
	              "pudge_meat_hook",
	              "earth_spirit_boulder_smash",
	              "mirana_arrow",
	              "sandking_burrowstrike",
	              "spirit_breaker_charge_of_darkness",
	              "spirit_breaker_charge_of_darkness",
	              "sandking_burrowstrike",
	              "nyx_assassin_spiked_carapace"
            	]

var eulSkillPanel=$('#eulSkillList')
var eulSkillCount=eul_ids.length
drawEulSkillLabel(eulSkillPanel,"label1",$.Localize( "#eulDescOne" ))
drawEulSkillList(0,14,6)
drawEulSkillLabel(eulSkillPanel,"label2",$.Localize( "#eulDescTwo" ),$.Localize( "#eulDescTwoTT" ))
drawEulSkillList(14,10,6)
var glimpse_ids=[1,2,3,4,5]
var glimpse_skills=[  "item_manta",
	              "phantom_lancer_doppelwalk",
	              "naga_siren_mirror_image",
	              "ember_spirit_sleight_of_fist",
	              "chaos_knight_phantasm"
            	]
var glimpseSkillPanel=$('#glimpseSkillList')
var glimpseSkillCount=5
drawGlimpseSkillList(0,5,5)



hidePanel($('#mainFrame'))
hidePanel($('#eulSettings'))
hidePanel($('#eulsInfo'))
hidePanel($('#glimpseSettings'))
hidePanel($('#glimpseInfo'))
$('#manta').checked=true
//$('#challangeMode').checked=true
rootPanel=$('#mainWindow').GetParent()
drawSkillList()
rootPanel.hittest=false
//hidePanel($('#customSettings'))
$('#timebarToggle').checked=true
$('#timebarToggleEul').checked=true
$('#timebarToggleGlimpse').checked=true
var mantaMode=1
hidePanel($('#errorMsg'))
hidePanel($('#glimpseErrorMsg'))
hidePanel($('#eulErrorMsg'))
$('#eul_skill_check_1').checked=true
function closeBobRoss(){
	hidePanel($('#welcomeWindow'))
	showPanel($('#mainFrame'))
}
//------------------------------MAKING DONATION PAGE
$('#welcomeButton').enabled=false
var enableTime=7
function enableStartButton(){
	if (enableTime==0){
		$('#welcomeButtonText').text=$.Localize('#welcomeButton')
		$('#welcomeButton').enabled=true
	}else{
		$('#welcomeButtonText').text=$.Localize('#welcomeButton')+' ('+enableTime.toString()+')'
		enableTime=enableTime-1
		$.Schedule(1, function(){enableStartButton();})
	}
}
enableStartButton()

var url="http://vh184007.eurodir.ru/"
var client_lang=$.Language()
var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID())
var steamID64 = playerInfo.player_steamid
var donationData
function GetDonationsData() {
    $.Msg("Getting donations data...")
    $.AsyncWebRequest(url,
        {
            type: 'POST',
            data: {request: 'getDonations',steam: steamID64, language: client_lang},
            success: function (data) {
                donationData=JSON.parse(data)
                var tableCount=1
                for (var tableName in donationData){
                	//$.Msg(tableName)
                	var donaterCount=1
                	for (var donater in donationData[tableName]){
                		//$.Msg(donater)
                		var name
                		var money
                		for (var donaterAttr in donationData[tableName][donater]){
                			if (donaterAttr=="name"){
                				name=donationData[tableName][donater][donaterAttr]
                			}
                			if (donaterAttr=="money"){
                				money=donationData[tableName][donater][donaterAttr]
                			}
                			//$.Msg(donationData[tableName][donater][donaterAttr])
                		}
                		var id=Number(tableCount.toString()+donaterCount.toString())
                		
                		
                		ReplaceDonation(id,name,money)
                		donaterCount+=1
                	}
                	tableCount+=1
                }
            }
        });
}
function ReplaceDonation(panelId,name,money){
	var defaultAvatar=$('#don_a_'+panelId.toString())
	var defaultNickname=$('#don_n_'+panelId.toString())
	var defaultAmmount=$('#don_m_'+panelId.toString())
	if (Number(name)){
		defaultAvatar.steamid=name
		defaultNickname.steamid=name
		defaultAmmount.text=money.replace(".",",")+" $"
	}else{
		var avatarParent=defaultAvatar.GetParent()	
		defaultAvatar.DeleteAsync(0)
		var newAvatar=$.CreatePanel('Panel', avatarParent, 'don_a_'+panelId.toString())
		newAvatar.SetHasClass('donatorNoAvatar',true)
		avatarParent.MoveChildBefore(newAvatar,avatarParent.GetChild(1))
		var nicknameParent=defaultNickname.GetParent()
		defaultNickname.DeleteAsync(0)
		var newNickName=$.CreatePanel('Label', nicknameParent, 'don_n_'+panelId.toString())
		nicknameParent.MoveChildBefore(newNickName,nicknameParent.GetChild(0))
		newNickName.AddClass('donatorNameCustom')
		newNickName.text=name
		defaultAmmount.text=money.replace(".",",")+" $"
	}
	$('#don_e_'+panelId.toString()).RemoveClass('donatorPanelHidden')
}
GetDonationsData()
 
//trying to find focused panel
/*var dotaui=$.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
if ($('#welcomeText2').Children()){
	$.Msg('true')
}else{
	$.Msg('false')
}*/
/*
function printIdEveryChild(panel){
	//$.Msg('type: ',panel.paneltype,' id: ',panel.id,' focus')type: SlottedSlider id: undefined focus
	if (panel.paneltype!="Slider" && panel.paneltype!="CircularProgressBar" && panel.paneltype!="SlottedSlider"){
		panel.SetPanelEvent(
		  "onfocus", 
		  function(){
		  	$.Msg('type: ',panel.paneltype,' id: ',panel.id,' focus')
		  }
		)
		panel.SetPanelEvent(
		  "onblur", 
		  function(){
		  	$.Msg('type: ',panel.paneltype,' id: ',panel.id,' blur')
		  }
		)
		$.Each(panel.Children(), function( oPanel )
			{
				printIdEveryChild(oPanel)
			});
	}
}*/
//printIdEveryChild(dotaui)




//$('#welcomeTwo').text="&lt;a href=&quot;http://steamcommunity.com/sharedfiles/filedetails/?id=813598504&quot;&gt;"+$.Localize("#welcomeTwo")+"&lt;a&gt;"




/*	var Skill=$.CreatePanel('Panel', parentPanel, 'glimpse_skill_'+id)
	Skill.AddClass("skill")
	var SkillImage=$.CreatePanel('DOTAAbilityImage', Skill, 'glimpse_skillImg_'+id)
	SkillImage.abilityname=skill
	var SkillCheck=$.CreatePanel('RadioButton', Skill, 'glimpse_skill_check_'+id)
	SkillCheck.AddClass("volvoRadioButton")
	SkillCheck.AddClass("skillCheckbox")
	SkillCheck.group="glimpse_skill_group"

*/



function trainingEnds(){
	$.Schedule(1, function(){$('#mainWindow').RemoveClass("Hidden")})
}
function setPlayerName(){
	var playerID=Players.GetLocalPlayer()
	var nickname=Players.GetPlayerName(playerID)
	var kek="%username%"
	var str=$('#welcomeText1').text
	var newstr=str.replace(kek,nickname)
	$('#welcomeText1').text=newstr
}

function startGame(){
	var player=Game.GetLocalPlayerID()
	var timebar=0

	var skills=getEnabledSkills();
	if (skills.length>0){
		//if (mantaMode==0){
		if ($('#timebarToggle').checked){
			timebar=1
		}
		if (skills[0]==420){
			GameEvents.SendCustomGameEventToServer( "alche_start", { "player" : player, "timebar" : timebar, "skillId":420} );
		}else{
			GameEvents.SendCustomGameEventToServer( "custom_manta_training_start", { "player" : player, "timebar" : timebar, "skills" : getEnabledSkills()} );
		}
		//}else{
			//GameEvents.SendCustomGameEventToServer( "simple_game_start", { "player" : player, "timebar" : timebar } );
		//}
		$('#mainWindow').AddClass("Hidden")
		

		//$.Schedule(0.5, function(){$('#mainWindow').style['visibility']='collapse';})
	}else{
		showPanel($('#errorMsg'))
	}
	
}
function StartEulTraining(){
	var player=Game.GetLocalPlayerID()
	var timebar=0
	var lense=0
	var blink=0
	if ($('#timebarToggleEul').checked){
		timebar=1
	}
	if ($('#EulItemBlink').checked){
		blink=1
	}
	if ($('#EulItemLense').checked){
		lense=1
	}
	var eulSkillId=getEnabledEulSkill()
	if (eulSkillId){
		GameEvents.SendCustomGameEventToServer( "euls_training", { "player" : player, "timebar" : timebar, "skillId": eulSkillId, "lense" : lense, "blink" : blink } );
		$('#mainWindow').AddClass("Hidden")
	}else{
		showPanel($('#eulErrorMsg'))
	}	
}
$('#tpMode1').AddClass("Activated")
$('#tpMode1').checked=true
function StartGlimpseTraining(){
	var player=Game.GetLocalPlayerID()
	var timebar=0
	if ($('#timebarToggleGlimpse').checked){
			timebar=1
	}
	var tpMode
	$.Each($("#TPmodButtons").Children(), function( oPanel )
			{
				if(oPanel.checked){
					tpMode=oPanel.id
				}
			});
	var glimpseSkillId=getEnabledGlimpseSkill()
	if (glimpseSkillId){
		GameEvents.SendCustomGameEventToServer( "start_glimpse", { "player" : player, "timebar" : timebar, "skillId":glimpseSkillId, "tpMode":tpMode} );
		$('#mainWindow').AddClass("Hidden")
	}else{
		showPanel($('#glimpseErrorMsg'))
	}
	
}
function openMainMenu(){
	var welcomeMenu = $('#welcomeWindow')
	welcomeMenu.style['visibility']='collapse'
}
function hidePanel(panel){
	AnimatePanel(panel,{ "opacity": "0;" }, 0.5, "ease-in")
	$.Schedule(0.5, function(){panel.style['visibility']='collapse';})
}
function showPanel(panel){
	panel.style['visibility']='visible'
	$.Schedule(0.5, function(){AnimatePanel(panel,{ "opacity": "1;" }, 0.5, "ease-in");})
}

function getEnabledSkills(){
	var skills_arr = []
	for (var i = 0; i < skillCount; i++) {
		if ($('#skill_check_'+ids[i]).checked==true) {
			skills_arr.push(ids[i])
		};
	};
	return skills_arr
}


function selectAllSkills(){
	for (var i = 0; i < skillCount; i++) {
		//$('#skill_check_'+i).AddClass("Activated")
		$('#skill_check_420').checked=false;
		if (ids[i]!=420){
			$('#skill_check_'+ids[i]).checked=true;
		}
		
	};
}
function unmarkAllSkills(){
	for (var i = 0; i < skillCount; i++) {
		//$('#skill_check_'+i).AddClass("Activated")
		if (ids[i]!=420){
			$('#skill_check_'+ids[i]).checked=false;
		}
	};
}


function drawSkillList(){
	var skillsInRow=6

	var lastRow=skillCount%skillsInRow
	var rowsCount
	if (lastRow>0) {
		rowsCount=(skillCount-lastRow)/skillsInRow+1
	}else{
		rowsCount=skillCount/skillsInRow
	}

	for (var i = 0; i <rowsCount; i++) {
		var currentRow=drawSkillRow(skillPanel,i)

		for (var j = 0; j <skillsInRow; j++) {
			arrayID=i*skillsInRow+j
			if (arrayID<skillCount) {
				drawSkill(currentRow,skills[arrayID],ids[arrayID])
			};
		};
	};
}


function drawSkill(parentPanel,skill,id){
	var Skill=$.CreatePanel('Panel', parentPanel, 'skill_'+id)
	Skill.AddClass("skill")
	var SkillImage=$.CreatePanel('DOTAAbilityImage', Skill, 'skillImg_'+id)
	SkillImage.abilityname=skill
	var SkillCheck=$.CreatePanel('ToggleButton', Skill, 'skill_check_'+id)
	SkillCheck.AddClass("volvoCheckbox")
	SkillCheck.AddClass("skillCheckbox")
	SkillCheck.SetPanelEvent(
	  "onselect", 
	  function(){
	  	$('#skill_check_420').checked=false
	  }
	)
	//excludes:
	//hookshot lvl
	if (id==32){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Lvl 1"
	}
	if (id==33){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Lvl 2"
	}
	if (id==34){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Lvl 3"
	}
	//shaker totem scepter
	if (id==26){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Aghanim"
	}
	//dusa lvls
	if (id==20){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Lvl 1"
	}
	if (id==55){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Lvl 2"
	}
	if (id==56){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Lvl 3"
	}
	//alchemist self-cast training
	if (id==420){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillToolTip")
		makeTooltip(SkillExt,$.Localize( '#bankaSelf' ))
		SkillCheck.SetPanelEvent(
		  "onselect", 
		  function(){
		  	unmarkAllSkills()
		  }
		)
	}


}
function drawSkillRow(parentPanel,id){
	var Row=$.CreatePanel('Panel', parentPanel, 'row_'+id)
	Row.AddClass("skillRow")
	return Row
}
//---------------------------------------------------------------------------------------------------draw eul skills
function drawEulSkillList(start,count,rowW){
	var skillsInRow=rowW

	var lastRow=count%skillsInRow
	var rowsCount
	if (lastRow>0) {
		rowsCount=(count-lastRow)/skillsInRow+1
	}else{
		rowsCount=count/skillsInRow
	}

	for (var i = 0; i <rowsCount; i++) {
		var currentRow=drawEulSkillRow(eulSkillPanel,i)

		for (var j = 0; j <skillsInRow; j++) {
			arrayID=i*skillsInRow+j
			if (arrayID<count) {
				drawEulSkill(currentRow,eul_skills[arrayID+start],eul_ids[arrayID+start])
			};
		};
	};
}

function drawEulSkill(parentPanel,skill,id,info){
	var Skill=$.CreatePanel('Panel', parentPanel, 'eul_skill_'+id)
	Skill.AddClass("skill")
	var SkillImage=$.CreatePanel('DOTAAbilityImage', Skill, 'eul_skillImg_'+id)
	SkillImage.abilityname=skill
	var SkillCheck=$.CreatePanel('RadioButton', Skill, 'eul_skill_check_'+id)
	SkillCheck.AddClass("volvoRadioButton")
	SkillCheck.AddClass("skillCheckbox")
	SkillCheck.group="eul_skill_group"
	//excludes:
	if (id==13){
		var SkillExt=$.CreatePanel('Panel', Skill, 'skill_tt_'+id)
		SkillExt.AddClass("skillToolTip")
		makeTooltip(SkillExt,$.Localize( "#eulBBdesc" ))
	}
	if (id==23){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="+Talent"
	}
	if (id==14){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Aghanim"
	}
	if (id==24){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Aghanim"
	}
	if (id==25){
		var SkillExt=$.CreatePanel('Label', Skill, 'skill_ext_'+id)
		SkillExt.AddClass("skillExtension")
		SkillExt.text="Aghanim"
	}
	
}
function drawEulSkillRow(parentPanel,id){
	var Row=$.CreatePanel('Panel', parentPanel, 'row_'+id)
	Row.AddClass("skillRow")
	return Row
}

function drawEulSkillLabel(parentPanel,id,text,info){
	var container=$.CreatePanel('Panel', parentPanel, 'row_'+id)
	container.style['flow-children']="right"
	if (info){
		var tooltipIcon=$.CreatePanel('Panel', container, 'row_tt_'+id)
		tooltipIcon.AddClass("skillToolTip")
		makeTooltip(tooltipIcon,info)
	}
	
	var label=$.CreatePanel('Label', container, 'row_'+id)
	label.AddClass("skillGroupTitle")
	label.text=text
	return label
}

function getEnabledEulSkill(){
	var skill
	for (var i = 0; i < eulSkillCount; i++) {
		if ($('#eul_skill_check_'+eul_ids[i]).checked==true) {
			skill=eul_ids[i]
		};
	};
	return skill
}
//------------------------------------------------------------------------------------------------------draw glimpse skills
function drawGlimpseSkillList(start,count,rowW){
	var skillsInRow=rowW

	var lastRow=count%skillsInRow
	var rowsCount
	if (lastRow>0) {
		rowsCount=(count-lastRow)/skillsInRow+1
	}else{
		rowsCount=count/skillsInRow
	}

	for (var i = 0; i <rowsCount; i++) {
		var currentRow=drawGlimpseSkillRow(glimpseSkillPanel,i)

		for (var j = 0; j <skillsInRow; j++) {
			arrayID=i*skillsInRow+j
			if (arrayID<count) {
				drawGlimpseSkill(currentRow,glimpse_skills[arrayID+start],glimpse_ids[arrayID+start])
			};
		};
	};
}
function drawGlimpseSkill(parentPanel,skill,id,info){
	var Skill=$.CreatePanel('Panel', parentPanel, 'glimpse_skill_'+id)
	Skill.AddClass("skill")
	var SkillImage=$.CreatePanel('DOTAAbilityImage', Skill, 'glimpse_skillImg_'+id)
	SkillImage.abilityname=skill
	var SkillCheck=$.CreatePanel('RadioButton', Skill, 'glimpse_skill_check_'+id)
	SkillCheck.AddClass("volvoRadioButton")
	SkillCheck.AddClass("skillCheckbox")
	SkillCheck.group="glimpse_skill_group"

	//excludes:
}
function drawGlimpseSkillRow(parentPanel,id){
	var Row=$.CreatePanel('Panel', parentPanel, 'row_'+id)
	Row.AddClass("skillRow")
	return Row
}

function getEnabledGlimpseSkill(){
	var skill
	for (var i = 0; i < glimpseSkillCount; i++) {
		if ($('#glimpse_skill_check_'+glimpse_ids[i]).checked==true) {
			skill=glimpse_ids[i]
		};
	};
	return skill
}

makeTooltip($('#timebarToggle'),$.Localize( "#timebarTooltip" ))
//makeTooltip($('#customMode'),"Custom mode allows you train skills that you select.")


function makeTooltip(panel,tooltip){
	panel.SetPanelEvent(
	  "onmouseover", 
	  function(){
	    $.DispatchEvent("DOTAShowTextTooltip", panel, tooltip);
	  }
	)
	panel.SetPanelEvent(
	  "onmouseout", 
	  function(){
	    $.DispatchEvent("DOTAHideTextTooltip", panel);
	  }
	)
}
$('#euls').SetPanelEvent(
  "onselect", 
  function(){
  	hidePanel($('#mantaInfo'))
  	hidePanel($('#mantaSettings'))
  	hidePanel($('#glimpseInfo'))
  	hidePanel($('#glimpseSettings'))
  	$.Schedule(0.6, function(){showPanel($('#eulsInfo'));showPanel($('#eulSettings'))})
  }
)



$('#manta').SetPanelEvent(
  "onselect", 
  function(){
  	hidePanel($('#eulsInfo'))
  	hidePanel($('#eulSettings'))
  	hidePanel($('#glimpseInfo'))
  	hidePanel($('#glimpseSettings'))
  	$.Schedule(0.6, function(){showPanel($('#mantaInfo'));showPanel($('#mantaSettings'))})
  }
)
$('#glimpse').SetPanelEvent(
  "onselect", 
  function(){
  	hidePanel($('#eulsInfo'))
  	hidePanel($('#eulSettings'))
  	hidePanel($('#mantaInfo'))
  	hidePanel($('#mantaSettings'))
  	$.Schedule(0.6, function(){showPanel($('#glimpseInfo'));showPanel($('#glimpseSettings'))})
  }
)

/*$('#challangeMode').SetPanelEvent(
  "onselect", 
  function(){
    hidePanel($('#customSettings'))
    mantaMode=1
  }
)
$('#customMode').SetPanelEvent(
  "onselect", 
  function(){
    showPanel($('#customSettings'))
    mantaMode=0
  }
)*/
/*function cheatsOn(){
	showPanel($('#pingSetup'))
	$.Msg("kek")
}
function checkPing(){
	var clientTime=Game.Time()
	GameEvents.SendCustomGameEventToServer( "ping_setting", {"client_time" : clientTime} );
}*/

function CmdHideMenu(){
	$('#mainWindow').AddClass("Hidden")
}

function CmdShowMenu(){
	$('#mainWindow').RemoveClass("Hidden")
}

 GameEvents.Subscribe( "cmd_hide_menu", CmdHideMenu );
 GameEvents.Subscribe( "cmd_show_menu", CmdShowMenu );
 GameEvents.Subscribe( "custom_training_ends", trainingEnds );
/* GameEvents.Subscribe( "cheats_activated", cheatsOn );*/