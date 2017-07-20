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
var enemyUnit
var enemyUnitInd
HideUI()

function HideUI() {
	rootpanel = $("#settingsPanel").GetParent()
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
	rootpanel = $("#settingsPanel").GetParent()
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

function UpdateStats(info){
	var unitInd=info.attacker
	var attackSpeed=Entities.GetAttackSpeed(unitInd)
	var minDmg=Entities.GetDamageMin(unitInd)
	var maxDmg=Entities.GetDamageMax(unitInd)
	var bonusDmg=Entities.GetDamageBonus(unitInd)
	$("#asField").text=attackSpeed.toFixed(3)*100
	$('#dmgField').text=(minDmg+maxDmg)/2+bonusDmg
	if (Entities.IsAlive(unitInd)){
		$.Schedule(0.1, function() {
			UpdateStats(info);
		});
	}
}
function ToggleFakeMod(){
	GameEvents.SendCustomGameEventToServer("armlet_mod_attacker", {"type" : "fm", "target" : enemyUnitInd});
}
function ChangeAttackSpeed(ASvalue){
	GameEvents.SendCustomGameEventToServer("armlet_mod_attacker", {"type" : "as", "value" : ASvalue, "target" : enemyUnitInd});
}
function ChangeAttackDamage(ADvalue){
	GameEvents.SendCustomGameEventToServer("armlet_mod_attacker", {"type" : "ad", "value" : ADvalue, "target" : enemyUnitInd});
}
function ArmTrainingStart(info){
	ShowUI()
	enemyUnitInd=info.attacker
/*	UpdateStats(enemyUnitInd)
	$.Msg(enemyUnit)*/
}
function ArmletEnd(){
	HideUI()
	GameEvents.SendCustomGameEventToServer("armlet_training_end", {});
}
GameEvents.Subscribe("armlet_training_start", ArmTrainingStart);
GameEvents.Subscribe("armlet_update_stats", UpdateStats);