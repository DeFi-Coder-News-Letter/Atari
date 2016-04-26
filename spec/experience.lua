local mytest = torch.TestSuite()

local tester = torch.Tester()

local Singleton = require 'structures/Singleton'
local Experience = require 'Experience'

local size = 10000

local opt = {
  ["memSize"] = size,
  ["memPriority"] = "rank",
  ["batchSize"] = math.ceil(size/1000),
  ["histLen"] = 4,
  ["nChannels"] = 1,
  ["height"] = 12,
  ["width"] = 12,
  ["alpha"] = 0.65,
  ["betaZero"] = 0.45,
  ["gpu"] = 0,
  ["steps"] = 5e7,
  ["learnStart"] = math.ceil(size/10)
}
--print(opt)
opt.Tensor = function(...)
  return torch.Tensor(...)
end

-- Set up singleton global object for transferring step
local globals = Singleton({step = 1}) -- Initial step

experience = Experience(opt.memSize, opt)

-- Insert
for i = 1, size do
  local reward = math.random(1000)/1000
  local state = torch.Tensor(opt.nChannels, opt.height, opt.width):zero()
  local terminal = false
  local action = math.random(3)
  experience:store(reward, state, terminal, action)
end

function mytest.sample()
  tester:eq("userdata", type(experience:sample(1)), "should have a 'sample' member of type userdata")
end

--function mytest.findMax()
--  tester:eq("number", type(heap:findMax()), "should have a 'findMax' member of type number")
--  tester:eq(max, heap:findMax(), "'findMax' should equal inserted max")
--end

tester:add(mytest)
tester:run()
