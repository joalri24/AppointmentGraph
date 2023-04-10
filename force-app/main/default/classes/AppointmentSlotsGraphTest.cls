@isTest
public class AppointmentSlotsGraphTest
{
	private static final String INTERNAL_MEDICINE = 'Internal medicine';
	private static final String CLINICAL_LAB = 'Laboratory Medicine';
	private static final String PSYCHIATRY = 'Psychiatry';
	private static final Long TWENTY_MINUTES = 1200000;

	@isTest
	public static void itShouldCreateAGraphWithNoEdges()
	{
		// GIVEN - A List of Slots of the same specialty
		List<AppointmentSlot__c> slots = new List<AppointmentSlot__c>{
			createSlot(INTERNAL_MEDICINE, DateTime.now()),
			createSlot(INTERNAL_MEDICINE, DateTime.now().addMinutes(30)),
			createSlot(INTERNAL_MEDICINE, DateTime.now().addHours(4)),
			createSlot(INTERNAL_MEDICINE, DateTime.now().addDays(1))
		};

		// WHEN - The  Graph is created
		Test.startTest();
		AppointmentSlotsGraph graph = new AppointmentSlotsGraph(slots, TWENTY_MINUTES, true);
		Test.stopTest();

		// THEN - It should Create a Graph without any Edges
		List<AppointmentSlotsGraph.Node> nodes = graph.nodesById.Values();
		Map<Id, List<AppointmentSlotsGraph.Edge>> edges = graph.edgesByNodeId;

		Assert.isFalse(nodes.isEmpty());
		Assert.areEqual(slots.size(), nodes.Size(), 'The Amount of nodes is not the expected.');
		Assert.areEqual(INTERNAL_MEDICINE, nodes[0].specialty, 'The Node details might not be correct');
		System.debug('Nodes: '+ nodes);
		Assert.isTrue(edges.isEmpty(), 'No Edges should have been created.');
		System.debug('Edges: '+ edges);
	}

	@isTest
	public static void itShouldCreateAGraphWithEdgesFromSortedList()
	{
		// GIVEN - A List of Slots of with different specialties and sorted by time
		DateTime initialTime = DateTime.newInstance(
			Date.today().year(),
			Date.today().month(),
			Date.today().day()
		);
		List<AppointmentSlot__c> slots = new List<AppointmentSlot__c>{
			createSlot(CLINICAL_LAB, initialTime),
			createSlot(CLINICAL_LAB, initialTime.addMinutes(15)),
			createSlot(PSYCHIATRY, initialTime.addMinutes(30)),
			createSlot(INTERNAL_MEDICINE, initialTime.addMinutes(45)),
			createSlot(INTERNAL_MEDICINE, initialTime.addMinutes(60)),
			createSlot(CLINICAL_LAB, initialTime.addHours(2)),
			createSlot(PSYCHIATRY, initialTime.addMinutes(180)),
			createSlot(INTERNAL_MEDICINE, initialTime.addHours(5)),
			createSlot(PSYCHIATRY, initialTime.addDays(1))
		};

		// WHEN - The  Graph is created
		Test.startTest();
		AppointmentSlotsGraph graph = new AppointmentSlotsGraph(slots, TWENTY_MINUTES, true);
		Test.stopTest();

		// THEN - It should Create a Graph with some specific Edges
		List<AppointmentSlotsGraph.Node> nodes = graph.nodesById.Values();
		Map<Id, List<AppointmentSlotsGraph.Edge>> edges = graph.edgesByNodeId;
		Id latestSlotId = slots.get(slots.size() -1).Id; // Because list is sorted, the last one is the latest slot.
		Id clinicalLab1Id = slots.get(0).Id;
		Id clinicalLab2Id = slots.get(1).Id;
		Id clinicalLab3Id = slots.get(5).Id;
		Id psychiatry1Id = slots.get(2).Id;
		Set<Id> clinicalLabIds = new Set<Id> {clinicalLab1Id, clinicalLab2Id, clinicalLab3Id};

		Assert.isFalse(nodes.isEmpty());
		Assert.areEqual(slots.size(), nodes.Size(), 'The Amount of nodes is not the expected.');
		Assert.isFalse(edges.isEmpty(), 'Some Edges should have been created.');
		Assert.isFalse(edges.containsKey(latestSlotId), 'The latest slot should not have any edges');

		List<AppointmentSlotsGraph.Edge> clinicalLab1Edges = edges.get(clinicalLab1Id);
		Assert.isFalse(clinicalLab1Edges.isEmpty(), 'The Clinical Lab First slot should have some edges');
		Assert.areEqual(6, clinicalLab1Edges.size(), 'The Clinical Lab 1 should have 6 edges');
		for (AppointmentSlotsGraph.Edge edge : clinicalLab1Edges)
		{
			Assert.isFalse(
					clinicalLabIds.contains(edge.nodeId),
					'The Clinical Lab Nod slot should not have edges to other clinical slots'
			);
		}

		List<AppointmentSlotsGraph.Edge> clinicalLab2Edges = edges.get(clinicalLab2Id);
		Assert.isFalse(clinicalLab2Edges.isEmpty(), 'The Clinical Lab Second slot should have some edges');
		Assert.areEqual(5, clinicalLab2Edges.size(), 'The Clinical Lab 2 should have 5 edges');
		for (AppointmentSlotsGraph.Edge edge : clinicalLab2Edges)
		{
			Assert.areNotEqual(
					psychiatry1Id,
					edge.nodeId,
					'The Clinical Lab 2 slot should not have edges to the Psychiatry 1 slot as they dates are less than 20 minutes apart'
			);
		}
		// System.debug('Nodes: ------');
		// for (AppointmentSlotsGraph.Node node : nodes)
		// {
		// 	System.debug(node);
		// }
		// System.debug('------')

		// System.debug('Edges: ------');
		// for (Id nodeId : edges.keySet())
		// {
		// 	System.debug(nodeId + ' ' + edges.get(nodeId));
		// }
		// System.debug('------');
	}

	private static AppointmentSlot__c createSlot(String specialty, Datetime slotTime)
	{
		AppointmentSlot__c slot = new AppointmentSlot__c();
		slot.Id = IdGenerator.generate(AppointmentSlot__c.getSObjectType());
		slot.AppointmentDate__c = slotTime;
		slot.Specialty__c = specialty; //'Internal medicine';
		return slot;
	}
}