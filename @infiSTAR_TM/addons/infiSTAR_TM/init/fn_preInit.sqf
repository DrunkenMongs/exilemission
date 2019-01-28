fn_infiSTAR_TM_GetCfgSettings = compileFinal "
params['_inputclassname','_default'];
if(isNil'_inputclassname')exitWith{diag_log format['fn_infiSTAR_TM_GetCfgSettings ERROR 1: %1',_this];};
if(isNil'_default')exitWith{diag_log format['fn_infiSTAR_TM_GetCfgSettings ERROR 2: %1',_this];};

private '_path';
if(_inputclassname isEqualType '')then
{
	_path = configfile >> 'Cfg_infiSTAR_TM' >> _inputclassname;
}
else
{
	_path = configfile >> 'Cfg_infiSTAR_TM' >> _inputclassname select 0 >> _inputclassname select 1;
};
if(isNil'_path')exitWith{diag_log format['fn_infiSTAR_TM_GetCfgSettings ERROR 3: %1',_this];};

call {
	if(_default isEqualType 0)exitWith{getNumber _path};
	if(_default isEqualType [])exitWith{getArray _path};

	_txt = getText _path;
	_default = _txt;

	if((toLower _txt) isEqualTo 'true')then{_default = true};
	if((toLower _txt) isEqualTo 'false')then{_default = false};
	_default
}
";
