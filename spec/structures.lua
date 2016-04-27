local binaryheap = torch.TestSuite()

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
    local priority = 0.1 + math.random(500)/1000
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
    local priority = 0.1 + math.random(900)/1000
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

function binaryheap.getValueByVal()
  before()
  insertAll()
  tester:eq("number", type(heap:getValueByVal(1)), "should have a 'getValueByVal' member of type number")
end

function binaryheap.checkChildren()
  before()
  insertAll()
  for i = 1, size do
    priorityLessThanEitherChild(i)
  end
  updateAll()
  for i = 1, size do
    priorityLessThanEitherChild(i)
  end
end

function binaryheap.findMax()
  before()
  insertAll()
  tester:eq("number", type(heap:findMax()), "should have a 'findMax' member of type number")
  tester:eq(max, heap:findMax(), "'findMax' should equal inserted max")
  updateAll()
  tester:eq(max, heap:findMax(), "'findMax' should equal updated max")
end

function binaryheap.findMin()
  before()
  insertAll()
  tester:eq("number", type(heap:findMin()), "should have a 'findMin' member of type number")
  tester:assertGeneralEq(heap:findMin(), min, 0.2, "'findMin' should be close to inserted min")
  tester:assertlt(heap:findMin(), max, "'findMin' should be less than inserted max")
  updateAll()
  tester:assertGeneralEq(heap:findMin(), min, 0.4, "'findMin' should be close to updated min")
  tester:assertlt(heap:findMin(), max, "'findMin' should be less than updated max")
end

function binaryheap.insert()
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
  for i = 1, 3 do
    priorityLessThanEitherChild(i)
  end
end

function binaryheap.updateByVal()
  before()
  heap:insert(0.6, 1)
  heap:insert(0.4, 2)
  heap:insert(0.5, 3)
  --tester:eq(3, heap:getValueByVal(3), "'heap:getValueByVal(3)' should equal 3")
  tester:eq(0.6, heap:findMax(), "'findMax' should equal 0.6")
  heap:updateByVal(2, 0.7, 2)
  -- Was it rebalanced to beginning?
  tester:eq(1, heap:getValueByVal(2), "'heap:getValueByVal(2)' should equal 1")
  tester:eq(3, heap.size, "'size' should equal 3")
  tester:eq(0.7, heap:findMax(), "'findMax' should equal 0.7")
  heap:updateByVal(1, 0.8, 1)
  -- Was it rebalanced to beginning?
  tester:eq(1, heap:getValueByVal(1), "'heap:getValueByVal(1)' should equal 1")
  tester:eq(3, heap.size, "'size' should equal 3")
  tester:eq(0.8, heap:findMax(), "'findMax' should equal 0.8")
  heap:updateByVal(2, 0.9, 2)
  -- Was it rebalanced to beginning?
  tester:eq(1, heap:getValueByVal(2), "'heap:getValueByVal(2)' should equal 1")
  tester:eq(3, heap.size, "'size' should equal 3")
  tester:eq(0.9, heap:findMax(), "'findMax' should equal 0.9")
  heap:updateByVal(3, 0.3, 3)
  heap:updateByVal(1, 0.4, 1)
  -- Was it rebalanced towards end?
  --tester:assertgt(1, heap:getValueByVal(3), "'heap:getValueByVal(3)' should greater than 1")
  tester:eq(3, heap.size, "'size' should equal 3")
  tester:eq(0.9, heap:findMax(), "'findMax' should equal 0.9")
  for i = 1, 3 do
    priorityLessThanEitherChild(i)
  end
end

function priorityLessThanEitherChild(i)
  local l, r = 2*i, 2*i + 1
  local priority = heap.array[i][1];
  if l <= heap.size then
    local priority_l = heap.array[l][1];
    tester:assertlt(priority, priority_l, "Parent priority should be less than left child")
  end
  if r <= heap.size then
    local priority_r = heap.array[r][1];
    tester:assertlt(priority, priority_r, "Parent priority should be less than right child")
  end
end

tester:add(binaryheap)
tester:disable('updateByVal')
tester:run()
