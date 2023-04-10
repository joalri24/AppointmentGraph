public without sharing class AppointmentSlotsGraph
{
	@TestVisible
	private Map<Id, Node> nodesById;

	@TestVisible
	private Map<Id, List<Edge>> edgesByNodeId;
	
	// minimumGapTime in milliseconds
	public AppointmentSlotsGraph(List<AppointmentSlot__c> slots, Long minimumGapTime, Boolean isSorted)
	{
		nodesById = new Map<Id, Node>();
		edgesByNodeId = new Map<Id, List<Edge>>();
		// Fill the Nodes map with the provided slots
		for (AppointmentSlot__c slot : slots)
		{
			nodesById.put(slot.Id, new Node(slot.Id, slot.AppointmentDate__c, slot.Specialty__c));
		}

		// Create the edges based on the slot's times and categories
		createEdges(minimumGapTime, isSorted);
	}

	private void createEdges(Long minimumGapTime, Boolean isSorted)
	{
		/*
		* An edge is created only if:
		* - The second Node is of a different Specialty
		* - The second Node is at more than the "minimumGapTime" further ahead from the first.
		*/

		// if the List is sorted we can use a slightly more efficient loop.
		if (isSorted)
		{
			List<Node> slots = nodesById.values();
			Node firstNode;
			Node secondNode;
			Long timeDifference;
			for (Integer i = 0; i < slots.Size() - 1; i++)
			{
				firstNode = slots[i];

				for (Integer j = i + 1; j < slots.Size(); j++)
				{
					secondNode = slots[j];
					timeDifference = secondNode.slotTime.getTime() - firstNode.slotTime.getTime();
					
					if (firstNode.specialty != secondNode.specialty &&
						timeDifference > minimumGapTime)
					{
						// If the value is not yet in the Edges list, initialize it first
						if (!edgesByNodeId.containsKey(firstNode.Id))
						{
							edgesByNodeId.put(firstNode.Id, new List<Edge>());
						}
						edgesByNodeId.get(firstNode.Id).add(new Edge(secondNode.Id, timeDifference));
					}
				}
			}

		}
		else
		{
			
		}
	}

	@TestVisible
	private class Node 
	{
		public Id id;
		public Datetime slotTime;
		public string specialty;
		
		public Node (Id idP, Datetime timeP, String specialtyP)
		{
			id = idP;
			slotTime = timeP;
			specialty = specialtyP;
		}
	}

	@TestVisible
	private class Edge
	{
		public Id nodeId; // Id of the Node that this edge is pointing to.
		public Long weight;

		public Edge(Id nodeIdP, Long weightP)
		{
			nodeId = nodeIdP;
			weight = weightP;
		}
	}
}