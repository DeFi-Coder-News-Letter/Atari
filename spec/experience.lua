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

local indices = torch.LongTensor(opt.batchSize)

function begin()
  experience = nil
  experience = Experience(opt.memSize, opt)
end

function insertAll()
  for i = 1, size do
    local reward = math.random(500)/1000
    local state = torch.Tensor(opt.nChannels, opt.height, opt.width):zero()
    local terminal = false
    local action = math.random(3)
    experience:store(reward, state, terminal, action)
  end
end

function mytest.sample()
  begin()
  insertAll()
  tester:eq("userdata", type(experience:sample()), "should have a 'sample' member of type userdata")

  -- TODO: Update priorities into clear classes
  local indices = torch.LongTensor(experience.size)
  local delta = opt.Tensor(experience.size, 1)
  for i = 1, experience.size do
    indices[i] = i
    delta[i] = 0.3
    if i > math.ceil(experience.size/3) then
      delta[i] = 0.7
    end
    if i > math.ceil(experience.size/3)*2 then
      delta[i] = 0.5
    end
    delta[i] = delta[i] + (math.random(1000)/10000)
  end
  experience:updatePriorities(indices, delta)

  local indices, ISWeights = experience:sample(1)
  print("indices")
  print(indices)
  print("ISWeights")
  print(ISWeights)
  for i = 1, indices:size(1) do
    print("indices[i]: " .. indices[i])
    print("getValueByVal: " .. experience.priorityQueue:getValueByVal(indices[i]))
    print("priority: " .. experience.priorityQueue.array[indices[i]][1])
    print("val: " .. experience.priorityQueue.array[indices[i]][2])
  end

  -- TODO: Sample many times
  -- TODO: Test number of each class represented in samples
  -- TODO: Test ISWeight is proportional to priority

end

tester:add(mytest)
--tester:disable('sample')
tester:run()
