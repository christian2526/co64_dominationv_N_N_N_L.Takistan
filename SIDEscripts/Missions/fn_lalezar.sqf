
private ["_side_log_pos","_side_rad","_side_name","_side_trig", "_side_ai_skill_array","_cacheside_loc_select","_cacheside_loc","_trigx","_trigy","_trigz"];

_cacheside_loc = ["marker1", "marker2","marker3","marker4"];
_cacheside_loc_select = _cacheside_loc call BIS_fnc_selectRandom;

switch (_cacheside_loc_select) do { 
	case "marker1" : { 
	log_lalezar setpos [4620.073,9428.168,0]; // Lalezear
    _trigx = 110;
    _trigy = 30;
    _trigz = 151.698;
	}; 
	case "marker2" : {
	log_lalezar setpos [3652.415,8596.474,0]; // Gospandi
    _trigx = 72;
    _trigy = 20;
    _trigz = 107.04;
	};
    case "marker3" : {
	log_lalezar setpos [9384.178,10010.58,0]; // Sagram
    _trigx = 50;
    _trigy = 40;
    _trigz = 29.703;    
	};
    case "marker4" : {
	log_lalezar setpos [8683.315,11393.894,0]; // Par-e Siah oilfield
    _trigx = 18;
    _trigy = 18;
    _trigz = 0;	
    };
	default {}; 
};


_side_log_pos   	    = log_lalezar;
_side_rad    		    = 150;
//_mkr_text  		    =
_side_name   		    = "Weapons Cache";
_side_ai_skill_array  = [0.3,0.5,0.3,0.7,0.5,1,0.8,0.5,0.5,0.5]; // [aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general, endurance, reloadSpeed] 
sleep 1;

//////////////// create a cache /////////////////////////////////////////////////////////////////////////////////////////////
_side_trig1 = createTrigger          ["EmptyDetector", getPos _side_log_pos];   
_side_trig1 setTriggerArea           [_trigx, _trigy, _trigz, true];
_side_trig1 setTriggerActivation     ["none", "notpresent", true]; 
_side_trig1 setTriggerStatements      ["!alive cache1", 
                                     "deletevehicle thisTrigger" , ""];
 
_side_position = [ _side_trig1] call BIS_fnc_randomPosTrigger;
cache1 = "CUP_TKBasicWeapons_EP1" createVehicle _side_position;
waitUntil { sleep 0.5; alive cache1 };
cache1 setVectorUp [0,0,1];
cache1Alive = true;									

//////////////// creates a task/show notification for the ao ///////////////////////////////////////////////////////////////////////////////////////		

["tsk4", true, ["Find the hidden weapons cache and destroy it!","Side Mission: Weapons Cache","Side Mission"],getPos _side_log_pos, "ASSIGNED", 1, true, true,"",true] call BIS_fnc_setTask;


//////////////// create 2 ai patrol around cache /////////////////////////////////////////////////////////////////////////

sleep 0.1;
nul = [cache1,2,20,[true,false],[false,false,false],false,[2,0],[0,0],_side_ai_skill_array,nil,nil,nil] execVM "LV\militarize.sqf";	

nul = [_side_log_pos,2,true,2,[2,2],_side_rad,_side_ai_skill_array,nil,nil,nil] execVM "LV\fillHouse.sqf";
nul = [_side_log_pos,2,_side_rad,[true,false],[true,false,false],false,[10,0],[0,0],_side_ai_skill_array,nil,nil,nil] execVM "LV\militarize.sqf";
nul = [_side_log_pos,2,_side_rad,[true,false],[true,false,false],true,[0,0],[1,0],_side_ai_skill_array,nil,nil,nil] execVM "LV\militarize.sqf";

//////////////// create trigger at the side ////////////////////////////////////////////////////////////////////////////////////////			

sleep 1;

_side_trig = createTrigger 		["EmptyDetector", getPos _side_log_pos];   
_side_trig setTriggerArea 		[_side_rad, _side_rad, 0, false];  
_side_trig setTriggerActivation ["none", "notpresent", true];   
_side_trig setTriggerStatements ["!alive cache1", 
								"0 = execVM ""SIDEscripts\militarizeSideEast.sqf""; 
								[side_endText] remoteExec [""SEPP_fnc_globalHint"",0,false]; 
								[""Sidemission_complete""] remoteExec [""SEPP_fnc_globalsound"",0,false]; 
								[""tsk4"", true, ['Find the hidden weapons cache and destroy it!','Side Mission: Weapons Cache',""Side Mission""],
								getPos _side_log_pos, ""SUCCEEDED"", 1, true, true,"""",true] call BIS_fnc_setTask; 
								[""tf47_changetickets"", [WEST, 2, 5]] call CBA_fnc_globalEvent;
								[[cache1]] spawn tf47_fnc_cleanside;
                                trig_sandstorm setpos [0,0,0];
								deletevehicle thisTrigger" , ""];

//////////////// moves sandstorm trigger to side ///////////////////////////////////////////////////////////////////////////		
sleep 1;
trig_sandstorm setpos (getpos _side_log_pos);

/*
sleep 1;

_side_trig2 = createTrigger 				["EmptyDetector", getPos _side_log_pos];   
_side_trig2 setTriggerArea 					[500, 500, 0, false];  
_side_trig2 setTriggerActivation 			["any", "present", true];   
_side_trig2 setTriggerStatements 			["player in thislist", "0 = [[1,1,100],"""",true] execVM ""MKY\MKY_Sand_Snow_Init.sqf""; " , "0 = [] call MKY_fnc_Exit_Sand;"];
*/

[_side_log_pos,_side_rad,_side_name]