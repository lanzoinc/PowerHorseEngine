--[=[
	@class CoreGuiService
	@tag Service
]=]

local CoreGuiService = {}

local ErrorService = require(script.Parent.ErrorService);

local Shared = {};
local CoreGuiData = {
	PurchaseCallbackPrompts = true,
}
--[=[]=]
function CoreGuiService:SetCoreGuiEnabled(n:string,v:any):nil
	if(not CoreGuiData[n])then
		ErrorService.tossWarn("Cannot set value "..n.." to ".." because you don't have permission to do so.");
		return;
	end
	CoreGuiData[n]=v;
end;
--[=[]=]
function CoreGuiService:GetCoreGuiEnabled(n:string)
	return CoreGuiData[n];
end
--[=[]=]
function CoreGuiService:GetIsCoreScript(src:LocalScript|Script|CoreGuiServiceScript):boolean
	src = src or getfenv(0).script;
	local p = game:GetService("Players").LocalPlayer;
	local x = false;
	if(p)then
		local ui = p:WaitForChild("PlayerGui"):WaitForChild("PHeGui");
		if(src:IsDescendantOf(ui))then 
			x=true;
		end
	end
	return x;
end;

--[=[]=]
function CoreGuiService.GetCoreGuiRepository():ScreenGui
	return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PHeGui");
end;

local function try(n)
	local ran,results = pcall(function()
		return CoreGuiService:GetCoreGui(n);
	end)
	if(ran)then
		return results
	else
		return nil, results;
	end
end

--[=[
	@return Pseudo
]=]
function CoreGuiService:WaitFor(CoreGuiName:string,TIME:number?)
	local waits = 0;
	TIME = TIME or 60;
	--local totalwaits = TIME or 120;
	local returned;
	local error_;

	if(Shared[CoreGuiName])then
		return Shared[CoreGuiName];
	end; --<Doesn't enter loop if not needed
	
	
	repeat returned,error_ = try(CoreGuiName) waits+=1; wait(.1); until returned or waits >= TIME;

	
	return returned == nil and (ErrorService.tossWarn("Infinite Possible WaitFor Yield On \""..CoreGuiName.."\" ERROR: "..error_.." (waited for "..tostring(TIME).."s)") and nil) or returned;
	
	--if(returned)then
	--	return returned
	--else
	--	ErrorService.tossWarn("Infinite Possible WaitFor Yield On "..CoreGuiName..". Thread Was Freed, Errors May Occur If Not Handled.");
	--	return nil;
	--end;
end

function CoreGuiService.RemoveObject(Name)
	if(Shared[Name])then
		Shared[Name]=nil;
	else
		error(Name.." is not a coregui object");
	end	
end

function CoreGuiService.ShareObject(Name,Value)
	if(not Shared[Name])then
		Shared[Name]=Value;
	else
		error(Name.." has already been registered as a CoreGui.");
	end
end;

function CoreGuiService:GetCoreGui(Name)
	if(Shared[Name])then
		return Shared[Name];
	else
		error(Name.." has not been registered or doesn't exist in the CoreGui.");
	end
end

return CoreGuiService
