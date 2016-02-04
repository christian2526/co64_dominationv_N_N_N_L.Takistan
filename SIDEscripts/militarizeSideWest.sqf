//////////////// Exit if not server /////////////////////////////////////////////////////////////////////////////////////////////
if(!isServer) exitwith {};

//////////////// Declare Variables  /////////////////////////////////////////////////////////////////////////////////////////////

private ["_side_Playertext", "_side_select", "_side_mkr", "_side_trig", "_side_log_pos", "_side_mkr_text", "_side_name", "_side_rad", "_side_position","_side_flatPos", "_side_iniText"];



_side_select			= "";
_side_mkr				= "";
_side_side_trig			= "";
_side_mkr_text 			= "";
_side_log_pos		    = 0;
_side_name 				= "";
_side_rad 				= 200;


//////////////// Count all playable Blufor Units /////////////////////////////////////////////////////////////////////////////////

_NumOfPlayers = west countSide playableUnits;


//////////////// Deletes/Moves all remaining Marker/Object/Trigger ////////////////////////////////////////////////////////////////////

		"side_mkr1" setmarkerpos [0,0,0];
		sleep 1;
		if (alive  CapVeh1) then {deletevehicle CapVeh1;};
		sleep 60;
		
//////////////// Random Selects the AO  //////////////////////////////////////////////////////////////////////////////////////////		
_side_select = ["lalezar", "woods"] call BIS_fnc_selectRandom;


//,"mine"


//////////////// Side is Lalezar ////////////////////////////////////////////////////////////////////////////////////////////////		
if ( _side_select == "lalezar") then {
									_side_log_pos   	= log_lalezar;
									_side_rad    		= 150;
									//_mkr_text  		=
									_side_name   		= "Lalezar";
																	
									sleep 1;

									//////////////// create a powertrans /////////////////////////////////////////////////////////////////////////////////////////////

									_side_position = getPos _side_log_pos;
									powertrans = "Land_dp_transformer_F" createVehicle _side_flatPos;
									waitUntil { sleep 0.5; alive powertrans };
									powertrans setVectorUp [0,0,1];
									powertransAlive = true;									
									
									//////////////// create 2 ai patrol around powertrans /////////////////////////////////////////////////////////////////////////

									sleep 0.1;
									nul = [powertrans,2,20,[true,false],[false,false,false],false,[2,0],[0,0],"default",nil,nil,nil] execVM "LV\militarize.sqf";	
	
									nul = [_side_log_pos,2,true,2,[2,2],_side_rad,"default",nil,nil,nil] execVM "LV\fillHouse.sqf";
									nul = [_side_log_pos,2,_side_rad,[true,false],[true,false,false],false,[10,0],[0,0],"default",nil,nil,nil] execVM "LV\militarize.sqf";
									nul = [_side_log_pos,2,_side_rad,[true,false],[true,false,true],true,[0,0],[1,0],"default",nil,nil,nil] execVM "LV\militarize.sqf";
									
									//////////////// create trigger at the side ////////////////////////////////////////////////////////////////////////////////////////			
		
									sleep 1;
		
									_side_trig = createTrigger 					["EmptyDetector", getPos _side_log_pos];   
									_side_trig setTriggerArea 					[_side_rad, _side_rad, 0, false];  
									_side_trig setTriggerActivation 			["EAST", "notpresent", true];   
									_side_trig setTriggerStatements 			["this", "0 = execVM ""SIDEscripts\militarizeSideEast.sqf""; [side_endText] remoteExec [""SEPP_fnc_globalHint"",0,false]; 0 = execVM ""sounds\sidemissionComplete.sqf""; deletevehicle thisTrigger" , ""];
		

									
};

//////////////// Side is Valley ////////////////////////////////////////////////////////////////////////////////////////////////		
if ( _side_select == "woods") then {
									_side_log_pos   			= log_woods;
									_side_rad    				= 150;
									//_mkr_text 	 			=
									_side_name   				= "Valley of Death";
									
									_posTent1 = (getpos _side_log_pos) findEmptyPosition [0,10];
									_posTent2 = (getpos _side_log_pos) findEmptyPosition [0,10];
									_posTent3 = (getpos _side_log_pos) findEmptyPosition [0,10];
		
									sleep 0.1;
		
									Tent1 = "ACamp_EP1" createVehicle _posTent1;
									Tent2 = "ACamp_EP1" createVehicle _posTent2;
									Tent3 = "ACamp_EP1" createVehicle _posTent3;
		
									sleep 0.1;
		
									nul = [_side_log_pos,2,_side_rad,[true,false],[true,false,false],false,[15,0],[0,0],"default",nil,nil,nil] execVM "LV\militarize.sqf";
									
									//////////////// create trigger at the side ////////////////////////////////////////////////////////////////////////////////////////			
		
									sleep 1;
		
									_side_trig = createTrigger 					["EmptyDetector", getPos _side_log_pos];   
									_side_trig setTriggerArea 					[_side_rad, _side_rad, 0, false];  
									_side_trig setTriggerActivation 			["EAST", "notpresent", true];   
									_side_trig setTriggerStatements 			["this", "0 = execVM ""SIDEscripts\militarizeSideEast.sqf""; [side_endText] remoteExec [""SEPP_fnc_globalHint"",0,false]; 0 = execVM ""sounds\sidemissionComplete.sqf""; deletevehicle thisTrigger" , ""];
		

									
};									
		
//////////////// moves a visible marker to the ao //////////////////////////////////////////////////////////////////////////		

		"side_mkr1" setmarkerpos getpos _side_log_pos;
		
		
//////////////// Hint for completed Main Mission /////////////////////////////////////////////////////////////////////////////////////////// 

side_endText = format
	[
		"<t align='center' size='1.5'>Side Mission Completed!</t><br/><t size='1' align='center' color='#0040FF'>%1</t><br/>____________________<br/>Congratulations!<br/><br/> Outstanding work, Soldiers!",
		_side_name
	];

//////////////// Hint for active Main Mission /////////////////////////////////////////////////////////////////////////////////////////// 

_side_iniText = format
	[
		"<t align='center' size='1.5'>New Side Mission available!</t><br/><t size='1' align='center' color='#0040FF'>%1</t>",
		_side_name
	];

	//-------------------------------------------- Show global target start hint
	
	[_side_iniText] remoteExec ["SEPP_fnc_globalHint",0,false];

	
//////////////// Sound for Hint for active Main Mission /////////////////////////////////////////////////////////////////////////////////////////// 

sleep 0.1;

[] execVM "sounds\sidemissionNew.sqf";
 
//[playSound "sidemission_new"] call BIS_fnc_MP;