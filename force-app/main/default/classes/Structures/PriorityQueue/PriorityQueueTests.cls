@isTest
public class PriorityQueueTests
{
	public static final Integer NUMBER_OF_ELEMENTS = 25;

	@isTest
	public static void itShouldEnqueueCorrectly()
	{
		// TODO: test this with Comparable class, Integer is not working
		// Given: a new instance of the PriorityQueue class and we enqueue 25 random elements
		PriorityQueue queue = new PriorityQueue();
		
		List<Comparable> valuesToEnqueue = new List<Comparable>();
		for (Integer i = 0; i < NUMBER_OF_ELEMENTS; i++)
		{
			Integer randomInt = Integer.valueOf(Math.floor(Math.random() * 100));
			valuesToEnqueue.add((Comparable) randomInt);
		}

		// When: we enqueue the list of integers into the queue
		Test.startTest();
		queue.enqueue(valuesToEnqueue);
		Test.stopTest();
	
		// Then: the elements should have been added preserving the integrity of the Binary Heap.
		Assert.isTrue(queue.size() == NUMBER_OF_ELEMENTS, 'The Queue should have ' + NUMBER_OF_ELEMENTS + ' elements.');
		System.debug('** queue: ' + queue.toString());
		Assert.isTrue(checkBinaryHeapIntegrity(queue), 'The Binary Heap integrity is not maintained');
	}

	/**
	* Checks the integrity of the binary heap.
	*
	* @return true if the binary heap is valid, false otherwise.
	*/
	private static Boolean checkBinaryHeapIntegrity(PriorityQueue queue)
	{

		List<Comparable> heap = queue.queue;
		Integer size = heap.size();
		Integer parentIndex = 0;
		Integer rightChildIndex = 0;

		for (Integer i = 0; i < size; i++)
		{
			parentIndex = (i - 1) / 2;
			if (parentIndex >= 0 && heap[i].compareTo(heap[parentIndex]) < 0)
			{
				return false;
			}
		}
		return true;
	}
}