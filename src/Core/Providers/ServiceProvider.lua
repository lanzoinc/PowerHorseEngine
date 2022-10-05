local ConstantProviders = script.Parent.Constants;
local ModuleFetcher = require(ConstantProviders.ModuleFetcher);
local CoreEngine = script.Parent.Parent;
local CoreServices = CoreEngine.Services;
local rs = game:GetService("RunService");


--[=[
@tag Provider
Provides services

@class ServiceProvider
]=]
local ServiceProvider = {}
local AppPointer;



local ServerScriptServices = game:GetService("ServerScriptService");
local ServerSideServices = ServerScriptServices:FindFirstChild("PHeServer") and ServerScriptServices.PHeServer:FindFirstChild("ServerSideServices");

if(rs:IsServer() and rs:IsRunning())then
	local AppPointer = Instance.new("ObjectValue");
	AppPointer.Name = "$AppPointer";
	AppPointer.Value = script.Parent.Parent.Parent;
	AppPointer.Parent = ServerSideServices;
end;

function ServiceProvider:LoadServiceAsync(ServiceName:string)
	local Results = ModuleFetcher(ServiceName,CoreServices,ServiceName.." Is Not A Valid Service Name",false, (rs:IsServer() and rs:IsRunning()) and ServerSideServices);
	--local Results = ModuleFetcher(ServiceName,CoreServices,Servi);
	return Results;
end

return ServiceProvider;
