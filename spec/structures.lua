local mytest = torch.TestSuite()

local tester = torch.Tester()

local BinaryHeap = require 'structures/BinaryHeap'

local size = 10000

local max = 0
local min = 1

local heap = BinaryHeap(size)

-- Insert
for i = 1, size do
  local priority = math.random(500)/1000
  heap:insert(priority, i)
  if priority > max then
    max = priority
  end
  if priority < min then
    min = priority
  end
end

function updateAll()
  max = 0
  min = 1
  -- Update
  for i = 1, size do
    local priority = math.random(900)/1000
    --heap:update(i, priority, i)
    heap:updateByVal(i, priority, i)
    if priority > max then
      max = priority
    end
    if priority < min then
      min = priority
    end
  end
end

function mytest.getValueByVal()
  tester:eq("number", type(heap:getValueByVal(1)), "should have a 'getValueByVal' member of type number")
end

function mytest.findMax()
  tester:eq("number", type(heap:findMax()), "should have a 'findMax' member of type number")
  tester:eq(max, heap:findMax(), "'findMax' should equal inserted max")
  updateAll()
  tester:eq(max, heap:findMax(), "'findMax' should equal updated max")
end

function mytest.findMin()
  tester:eq("number", type(heap:findMin()), "should have a 'findMin' member of type number")
  tester:eq(min, heap:findMin(), "'findMin' should equal inserted min")
  updateAll()
  tester:eq(min, heap:findMin(), "'findMin' should equal updated min")
end

tester:add(mytest)
tester:run()
