/**
 * Defines a generic queue interface.
 * BIG DISCLAIMER:
 * I'm using Comparable instead of <T> because Apex does not support Generic Types yet.
 * I know it's ugly but it's what we have :(
 */
public interface IQueue
{
	/**
	 * Adds an item to the end of the queue.
	 *
	 * @param item The item to enqueue.
	 */
	void enqueue(Comparable item);

	/**
	 * Adds a list of items to the end of the queue.
	 *
	 * @param items The list of items to enqueue.
	 */
	void enqueueList(List<Comparable> items);

	/**
	 * Removes and returns the item at the front of the queue.
	 *
	 * @return The item at the front of the queue.
	 */
	Comparable dequeue();

	/**
	 * Returns the item at the front of the queue without removing it.
	 *
	 * @return The item at the front of the queue.
	 */
	Comparable peek();

	/**
	 * Returns a string representation of the queue.
	 *
	 * @return A string representation of the queue.
	 */
	String toString();
}