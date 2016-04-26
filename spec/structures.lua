local mytest = torch.TestSuite()

local tester = torch.Tester()

local BinaryHeap = require 'structures/BinaryHeap'

local size = 10000

local max = 0
local min = 1

local heap

function before()
  heap = nil
  heap = BinaryHeap(size)
end

function insertAll()
  max = 0
  min = 1
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
end

function updateAll()
  max = 0
  min = 1
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
  before()
  insertAll()
  tester:eq("number", type(heap:getValueByVal(1)), "should have a 'getValueByVal' member of type number")
end

function mytest.findMax()
  before()
  insertAll()
  tester:eq("number", type(heap:findMax()), "should have a 'findMax' member of type number")
  tester:eq(max, heap:findMax(), "'findMax' should equal inserted max")
  updateAll()
  tester:eq(max, heap:findMax(), "'findMax' should equal updated max")
end

function mytest.findMin()
  before()
  insertAll()
  tester:eq("number", type(heap:findMin()), "should have a 'findMin' member of type number")
  tester:assertGeneralEq(heap:findMin(), min, 0.2, "'findMin' should equal inserted min")
  tester:assertlt(heap:findMin(), max, "'findMin' should be less than max")
  updateAll()
  tester:assertGeneralEq(heap:findMin(), min, 0.4, "'findMin' should equal inserted min")
  tester:assertlt(heap:findMin(), max, "'findMin' should be less than max")
end

function mytest.insert()
  before()
  heap:insert(0.5, 1)
  tester:eq("number", type(heap.size), "should have a 'size' member of type number")
  tester:eq(1, heap.size, "'size' should equal 1")
  tester:eq(1, heap:getValueByVal(1), "'heap:getValueByVal(1)' should equal 1")
  heap:insert(0.4, 2)
  tester:eq(2, heap.size, "'size' should equal 2")
  tester:eq(2, heap:getValueByVal(2), "'heap:getValueByVal(2)' should equal 2")
  heap:insert(0.6, 3)
  tester:eq(3, heap.size, "'size' should equal 3")
  -- Was it rebalanced to beginning?
  tester:eq(1, heap:getValueByVal(3), "'heap:getValueByVal(3)' should equal 1")
  tester:eq(0.6, heap:findMax(), "'findMax' should equal 0.6")
end

function mytest.updateByVal()
  before()
  heap:insert(0.5, 1)
  heap:insert(0.4, 2)
  heap:insert(0.6, 3)
  tester:eq(1, heap:getValueByVal(3), "'heap:getValueByVal(3)' should equal 1")
  tester:eq(0.6, heap:findMax(), "'findMax' should equal 0.6")
  heap:updateByVal(2, 0.7, 2)
  -- Was it rebalanced to beginning?
  tester:eq(1, heap:getValueByVal(2), "'heap:getValueByVal(2)' should equal 1")
  tester:eq(3, heap.size, "'size' should equal 3")
  tester:eq(0.7, heap:findMax(), "'findMax' should equal 0.7")
end

tester:add(mytest)
--tester:disable('findMin')
tester:run()
