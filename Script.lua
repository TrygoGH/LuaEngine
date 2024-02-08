--[[
The following functions have been exposed to lua:
setBackground(string aPath) sets the background to the texture in the folder textures.
createButton(string area name which the player enters, string context); adds a button to the current screen
createTextfield(string context); adds a textfield to the top of the screen.
CLS(); clears the screen.
exitGame(); exits the game.
playSound(string path to sound)
]]--

scenes = {};
currentScene = "";
previousScene = "";
truePreviousScene = "";
previousKey = "previous";
exitKey = "exit";
previousText = "go back";
startScene = "";

Observer = {
	name = "",
	gazePercent = 0
}

function Observer:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
  end


function giveError(errorMessage)
	local i = 0;
	while(1 == 1) do
		if(i == 0) then print(errorMessage); end
		i = i + 1;
	end
end

Scene = {
	id = 0,
	music = "",
	background = "",
	text = "",
	buttons = {},
	scripts = {},
  }
  
  function Scene:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	id = generateSceneID()
	o.scripts = o.scripts or {}
	addScene(o)
	return o
  end
  
function Scene:start()
	CLS();
	if(string.len(self.music) == 0) then 
		playMusic(self.music) 
	end

	setBackground(self.background)
	createTextfield(self.text)

	local buttonCount = #self.buttons
	for i = buttonCount, 1, -1 do
		local button = self.buttons[i]
		createButton(button.targetScene, button.text)
	end
	for _, script in ipairs(self.scripts) do
		script()
	end
end

function Scene:addButton(newButton)
	table.insert(self.buttons, newButton)
end

function Scene:setButtons(newButtonList)
	self.buttons = newButtonList
end
  
  SceneButton = {
	  text = "",
	  targetScene = "",
  }
  
  function SceneButton:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	--o.targetScene = o.targetScene or Scene:new() 
	return o
  end

  function addScene(scene) 
	if not (scene) then 
		giveError("Cant add invalid scene");
	end

	local sceneID = scene.id;

	if(sceneID == previousKey) then 
		giveError("Scene name cannot be " .. previousKey);
	end

	if(sceneID == exitKey) then 
		giveError("Scene name cannot be " .. exitKey);
	end

	if(string.len(startScene) == 0) then 
		startScene = sceneID;
	end

	scenes[sceneID] = scene;
end

function setSceneButtons(scene, buttons)
	if scene then
		scene:setButtons(buttons);
	  else
		giveError("Scene is invalid");
	  end
end

function generateSceneID()
	local id = math.random(1, 10000);
	local stringID = tostring(id);
	if(scenes[stringID]) then 
		return generateSceneID(); end

	return stringID;
end

function setNewScene(sceneName)
	if not (sceneName == currentScene) then 
		previousScene = currentScene; end
	truePreviousScene = currentScene;
	currentScene = sceneName;
end

function callScene(sceneName)
	local scene = scenes[sceneName]
	if scene then
	  scene:start();
	  setNewScene(sceneName);
	else
	  giveError("Scene '" .. sceneName .. "' not found in the scenes.");
	end
  end


function createSceneButton(buttonTarget, buttonText)
	return SceneButton:new{text = buttonText, targetScene = buttonTarget};
end

function createBackButton(backButtonText)
	local targetScene = previousKey;
	local buttonText = backButtonText or previousText;
	return createSceneButton(targetScene, buttonText);
end

function story(aName)
	local sceneName = aName

	if(sceneName == previousKey) then 
		sceneName = previousScene; 
	elseif(sceneName == "start") then 
		sceneName = startScene; 
	elseif(sceneName == exitKey) then 
		exitGame(); 
		return;
	end

	callScene(sceneName);
end

shipScene = Scene:new{
    background = "",
    text = 
	"You find yourself stranded on a planet you don't recognize"
	.."\nThe shipcrew you were with did not survive, but you must thread on nonetheless"
	,
	scripts = {},
}

scene2 = Scene:new{
    background = "",
    text = 
	"A barren landscape seems to await you, do you thread on?"
	,
	scripts = {},
};

shipScene.buttons = {
	createSceneButton(scene2, "explore"), 
	createSceneButton(exitKey, "exit")
};

scene2.buttons = {
	createSceneButton("mansion", "go inside"), 
	createBackButton("hi");
};







