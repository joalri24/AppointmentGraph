/**
 * Implements a priority queue using a Binary Heap. We are optimizing using a list to represent the binary tree.
 */
public class PriorityQueue implements IPriorityQueue
{

	@testVisible
	private List<Comparable> queue;


	public PriorityQueue()
	{
		queue = new List<Comparable>();
	}

	/**
	 * Adds an item to the queue in priority order.
	 *
	 * @param item The item to enqueue.
	 */
	public void enqueue(Comparable item)
	{
		if (item == null)
		{
			return;
		}

		// If the queue is empty, simply add the element.
		if(queue.isEmpty())
		{
			queue.Add(item);
			return;
		}

		// Insert item to last position of the tree
		queue.Add(item);
		Integer current = queue.size() - 1; // set the current index as the last position
		Integer parent;
		Comparable temp;
		while(current != 0)
		{
			// find current's parent
			parent = (current - 1) / 2;

			// if the parent is more important that the current, then we are done.
			if (queue[parent].CompareTo(queue[current]) <= 0)
				break;

			// If the parent is less important than the current, swap them.
			temp = queue[parent];
			queue[parent] = queue[current];
			queue[current] = temp;

			// Update the current index
			current = parent;
		}
	}

	/**
	 * Adds a list of items to the queue in priority order.
	 *
	 * @param items The list of items to enqueue.
	 */
	public void enqueue(List<Comparable> items)
	{
		if (items == null || items.isEmpty())
			return;

		for (Comparable item : items)
			enqueue(item);
	}

	/**
	 * Removes and returns the highest priority item from the queue.
	 *
	 * @return The highest priority item.
	 */
	public Comparable dequeue()
	{
		// Not implemented
		return null;
	}

	/**
	 * Returns the highest priority item from the queue without removing it.
	 *
	 * @return The highest priority item, or null if the queue is empty.
	 */
	public Comparable peek()
	{
		if (queue.isEmpty())
		{
			return null;
		}
		return queue.get(0);
	}

	/**
	 * Returns a string representation of the queue.
	 *
	 * @return A string representation of the queue.
	 */
	public override String toString()
	{
		return queue.toString();
	}

	/**
	 * Returns the size of the queue
	 *
	 * @return A String with the number of elements in the queue.
	 */
	public Integer size()
	{
		return queue.size();
	}
}
